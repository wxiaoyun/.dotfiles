#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
FAKE_BIN="$TMP/bin"
CALLS="$TMP/calls"
mkdir -p "$FAKE_BIN"
: > "$CALLS"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

make_fake() {
  name=$1
  cat > "$FAKE_BIN/$name" <<'EOF'
#!/usr/bin/env sh
printf '%s %s\n' "$(basename "$0")" "$*" >> "$CALLS"
case "$(basename "$0")" in
  uname) printf '%s\n' "${FAKE_OS:-Linux}" ;;
  brew) [ "${1:-}" = shellenv ] && printf '%s\n' ':' ;;
  yay) [ "${1:-}" = --version ] && printf '%s\n' 'yay test' ;;
  cargo) printf '%s\n' 'cargo test' ;;
esac
exit 0
EOF
  chmod +x "$FAKE_BIN/$name"
}

for command in uname sudo pacman yay git makepkg rustup cargo brew curl; do
  make_fake "$command"
done

test_pacman_resolves_overrides() {
  [ -x "$ROOT/scripts/install_pacman.sh" ] || fail 'pacman installer missing or not executable'
  CALLS="$CALLS" FAKE_OS=Linux PATH="$FAKE_BIN:/usr/bin:/bin" \
    "$ROOT/scripts/install_pacman.sh" >"$TMP/pacman.log" 2>&1 \
    || { sed -n '1,120p' "$TMP/pacman.log" >&2; fail 'pacman installer exited nonzero'; }
  grep -F 'yay -S --needed --noconfirm fzf zoxide eza fastfetch git dua-cli jq herdr-bin stow rtk-bin neovim nodejs python rustup ttf-iosevka-nerd' "$CALLS" >/dev/null \
    || fail 'pacman installer did not resolve canonical package overrides'
}

test_brew_splits_formulae_and_casks() {
  [ -x "$ROOT/scripts/install_brew.sh" ] || fail 'brew installer missing or not executable'
  : > "$CALLS"
  CALLS="$CALLS" FAKE_OS=Darwin PATH="$FAKE_BIN:/usr/bin:/bin" \
    "$ROOT/scripts/install_brew.sh" >"$TMP/brew.log" 2>&1 \
    || { sed -n '1,120p' "$TMP/brew.log" >&2; fail 'brew installer exited nonzero'; }
  grep -F 'brew install fzf zoxide eza fastfetch git dua-cli jq herdr stow rtk neovim node python rustup' "$CALLS" >/dev/null \
    || fail 'brew installer did not install formulae from canonical list'
  grep -F 'brew install --cask font-iosevka-nerd-font' "$CALLS" >/dev/null \
    || fail 'brew installer did not install casks from canonical list'
}

test_pacman_resolves_overrides
test_brew_splits_formulae_and_casks
printf 'PASS: install script behavior\n'
