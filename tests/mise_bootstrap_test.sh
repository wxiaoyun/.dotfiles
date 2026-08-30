#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

for file in mise.toml .miserc.toml mise.macos.toml mise.linux.toml mise.remote_box.toml bootstrap/install-aur-packages.sh; do
  [ -f "$ROOT/$file" ] || fail "missing $file"
done

for directory in dotfiles/home config/common config/macos config/linux shell/common shell/macos shell/linux; do
  [ -d "$ROOT/$directory" ] || fail "missing source directory $directory"
done

grep -F 'auto_env = true' "$ROOT/.miserc.toml" >/dev/null || fail 'auto_env is not enabled'
grep -F 'system_packages.managers = ["brew", "brew-cask"]' "$ROOT/mise.macos.toml" >/dev/null || fail 'macOS manager selection missing'
grep -F 'system_packages.managers = ["pacman"]' "$ROOT/mise.linux.toml" >/dev/null || fail 'Linux Pacman selection missing'
grep -F 'system_packages.managers = ["brew"]' "$ROOT/mise.remote_box.toml" >/dev/null || fail 'remote_box Linuxbrew selection missing'
grep -F 'file = "bootstrap/install-aur-packages.sh"' "$ROOT/mise.linux.toml" >/dev/null || fail 'Linux AUR bootstrap task missing'
! grep -F '[tasks.bootstrap]' "$ROOT/mise.toml" >/dev/null || fail 'AUR bootstrap task must not run on macOS'
! grep -F '[bootstrap.mise_shell_activate]' "$ROOT/mise.toml" >/dev/null || fail 'shell activation conflicts with managed shell symlinks'

grep -F '"~/.config" = { source = "config/common", mode = "symlink-each", exclude = ["nvim", "ghostty"] }' "$ROOT/mise.toml" >/dev/null || fail 'common config tree mapping missing'
grep -F 'run = "mkdir -p \"$HOME/.local/bin\""' "$ROOT/mise.toml" >/dev/null || fail 'local bin pre-dotfiles directory hook missing'
grep -F '"~/.config/ghostty" = { source = "config/macos/ghostty", mode = "symlink-each" }' "$ROOT/mise.macos.toml" >/dev/null || fail 'macOS Ghostty mapping missing'
grep -F '"~/.config/ghostty" = { source = "config/common/ghostty", mode = "symlink-each" }' "$ROOT/mise.linux.toml" >/dev/null || fail 'Linux common Ghostty mapping missing'
grep -F '"~/.config/hypr" = { source = "config/linux/hypr", mode = "symlink-each" }' "$ROOT/mise.linux.toml" >/dev/null || fail 'Linux Hyprland mapping missing'

[ -f "$ROOT/dotfiles/home/zshrc" ] || fail 'missing moved zshrc source'
[ -f "$ROOT/config/macos/ghostty/config" ] || fail 'missing macOS Ghostty source'
[ -f "$ROOT/config/common/ghostty/config" ] || fail 'missing common Ghostty source'
[ -f "$ROOT/shell/common/init.zsh" ] || fail 'missing shell helper source'
[ ! -e "$ROOT/.stow-local-ignore" ] || fail 'Stow ignore file remains'
[ ! -e "$ROOT/install.txt" ] || fail 'legacy install list remains'
[ ! -e "$ROOT/install" ] || fail 'legacy install directory remains'
! grep -qi 'stow' "$ROOT/README.md" || fail 'README still references Stow'

grep -F 'platform.zsh' "$ROOT/dotfiles/home/zshrc" >/dev/null || fail 'stable shell platform source missing'
grep -F 'eval "$(mise activate zsh)"' "$ROOT/shell/common/init.zsh" >/dev/null || fail 'zsh activation missing from shared initialization'
! grep -F 'eval "$(mise activate zsh)"' "$ROOT/dotfiles/home/zshrc" >/dev/null || fail 'zsh activation must not remain in zshrc'
grep -F 'platform.zprofile' "$ROOT/dotfiles/home/zprofile" >/dev/null || fail 'stable zprofile platform source missing'
grep -F 'eval "$(mise activate zsh --shims)"' "$ROOT/dotfiles/home/zprofile" >/dev/null || fail 'zprofile shims activation missing from managed shell source'

printf 'PASS mise bootstrap migration configuration\n'
