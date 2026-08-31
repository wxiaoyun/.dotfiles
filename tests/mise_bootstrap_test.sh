#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

for file in mise.toml .miserc.toml mise.macos.toml mise.linux.toml mise.remote_box.toml scripts/add-universal-skills.sh scripts/add-pi-extension.sh scripts/install-aur-packages.sh; do
  [ -f "$ROOT/$file" ] || fail "missing $file"
done

for directory in dotfiles/home dotfiles/config dotfiles/agents dotfiles/local-bin linux/config macos/config scripts; do
  [ -d "$ROOT/$directory" ] || fail "missing source directory $directory"
done

[ -x "$ROOT/scripts/add-universal-skills.sh" ] || fail 'agent skill script is not executable'
[ -x "$ROOT/scripts/add-pi-extension.sh" ] || fail 'Pi extension script is not executable'
[ -x "$ROOT/scripts/install-aur-packages.sh" ] || fail 'AUR script is not executable'
[ -f "$ROOT/dotfiles/home/zshrc" ] || fail 'missing zshrc source'
[ -f "$ROOT/dotfiles/config/ghostty/config" ] || fail 'missing shared Ghostty source'
[ -f "$ROOT/macos/config/ghostty/platform_config" ] || fail 'missing macOS Ghostty source'

! grep -qi 'stow' "$ROOT/README.md" || fail 'README still references Stow'
[ ! -e "$ROOT/.stow-local-ignore" ] || fail 'Stow ignore file remains'
[ ! -e "$ROOT/install.txt" ] || fail 'legacy install list remains'
[ ! -e "$ROOT/install" ] || fail 'legacy install directory remains'

grep -F 'auto_env = true' "$ROOT/.miserc.toml" >/dev/null || fail 'auto_env is not enabled'
grep -F 'system_packages.managers = ["brew", "brew-cask"]' "$ROOT/mise.macos.toml" >/dev/null || fail 'macOS manager selection missing'
grep -F 'system_packages.managers = ["pacman"]' "$ROOT/mise.linux.toml" >/dev/null || fail 'Linux Pacman selection missing'
grep -F 'system_packages.managers = ["brew"]' "$ROOT/mise.remote_box.toml" >/dev/null || fail 'remote Linuxbrew manager selection missing'
grep -F '"~/.config" = { source = "dotfiles/config", mode = "symlink-each"' "$ROOT/mise.toml" >/dev/null || fail 'shared config mapping missing'
grep -F 'source = "macos/config/**/platform*"' "$ROOT/mise.macos.toml" >/dev/null || fail 'macOS platform mapping missing'
grep -F 'source = "linux/config/**/platform*"' "$ROOT/mise.linux.toml" >/dev/null || fail 'Linux platform mapping missing'
grep -F 'depends = ["os-bootstrap"]' "$ROOT/mise.toml" >/dev/null || fail 'root bootstrap dependency missing'
grep -F '{ task = "add-universal-skills" }' "$ROOT/mise.toml" >/dev/null || fail 'agent skill bootstrap task missing'
grep -F '{ task = "add-pi-extension" }' "$ROOT/mise.toml" >/dev/null || fail 'Pi extension bootstrap task missing'
grep -F 'run = "{{ cwd | quote }}/scripts/add-universal-skills.sh"' "$ROOT/mise.toml" >/dev/null || fail 'agent skill script task missing'
grep -F 'run = "{{ cwd | quote }}/scripts/add-pi-extension.sh"' "$ROOT/mise.toml" >/dev/null || fail 'Pi extension script task missing'
grep -F 'run = "{{ cwd | quote }}/scripts/install-aur-packages.sh"' "$ROOT/mise.linux.toml" >/dev/null || fail 'AUR bootstrap task missing'
grep -F 'agent_skills = """' "$ROOT/mise.toml" >/dev/null || fail 'agent skill list missing'
grep -F 'pi_packages = """' "$ROOT/mise.toml" >/dev/null || fail 'Pi package list missing'
grep -F 'aur_packages = """' "$ROOT/mise.linux.toml" >/dev/null || fail 'AUR package list missing'

mise -C "$ROOT" -E linux tasks validate >/dev/null
mise -C "$ROOT" -E macos tasks validate >/dev/null
mise -C "$ROOT" -E remote_box tasks validate >/dev/null

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM
for command in pacman yay pi; do
  printf '%s\n' '#!/usr/bin/env sh' "printf '$command %s\\n' \"\$*\"" > "$tmpdir/$command"
  chmod +x "$tmpdir/$command"
done
printf '%s\n' '#!/usr/bin/env sh' 'cat >/dev/null' 'printf "npx %s\n" "$*"' > "$tmpdir/npx"
chmod +x "$tmpdir/npx"
PATH="$tmpdir:$PATH" mise -C "$ROOT" -E remote_box run bootstrap > "$tmpdir/output" 2>&1
grep -F 'npx --yes skills add JuliusBrussee/caveman --skill caveman --agent universal --global --yes' "$tmpdir/output" >/dev/null || fail 'Caveman skill was not installed'
grep -F 'npx --yes skills add obra/superpowers --skill brainstorming --skill executing-plans --skill subagent-driven-development --skill writing-plans --agent universal --global --yes' "$tmpdir/output" >/dev/null || fail 'Superpowers skills were not installed'
skills_last=$(grep -n 'npx --yes skills add obra/superpowers' "$tmpdir/output" | cut -d: -f1)
pi_first=$(grep -n 'pi install npm:pi-web-access' "$tmpdir/output" | cut -d: -f1)
[ "$skills_last" -lt "$pi_first" ] || fail 'Pi packages ran before skills'

printf 'PASS mise bootstrap configuration\n'
