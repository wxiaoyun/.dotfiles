#!/usr/bin/env sh
set -eu

log()  { printf '[install_pacman] %s\n' "$*" >&2; }
fail() { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_LIST="$(cd "$SCRIPT_DIR/.." && pwd)/install.txt"
OVERRIDES="${SCRIPT_DIR}/pacman-overrides.txt"
[ -f "$INSTALL_LIST" ] || fail "stage=config install list not found: $INSTALL_LIST"
[ -f "$OVERRIDES" ] || fail "stage=config overrides not found: $OVERRIDES"

OS=$(uname)
[ "$OS" = "Linux" ] || fail "stage=os_check install_pacman.sh targets Linux (got: $OS)"
have sudo || fail "stage=prerequisite sudo not found; install_pacman.sh requires sudo"

resolve() {
  while IFS='=' read -r key name; do
    [ -z "$key" ] && continue
    case "$key" in '#'*) continue ;; esac
    [ "$key" = "$1" ] && { echo "$name"; return; }
  done < "$OVERRIDES"
  echo "$1"
}

log "stage=pacman_sync command=pacman Syncing pacman..."
sudo pacman -Syu --noconfirm || fail "stage=pacman_sync pacman sync failed"

if ! have yay; then
  log "stage=yay_install command=pacman Installing base-devel and git..."
  sudo pacman -S --needed --noconfirm base-devel git \
    || fail "stage=yay_install base-devel install failed"

  log "stage=yay_install method=git_clone url=https://aur.archlinux.org/yay.git Building yay from AUR..."
  tmpdir=$(mktemp -d) || fail "stage=yay_install temporary directory creation failed"
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay" \
    || fail "stage=yay_install yay clone failed"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm) \
    || fail "stage=yay_install yay makepkg failed"
  rm -rf "$tmpdir"
else
  log "stage=yay_install yay already present: $(yay --version | head -1)"
fi

log "stage=pacman_install Resolving packages from $INSTALL_LIST"
PKGS=$(grep -v '^[[:space:]]*#' "$INSTALL_LIST" \
  | grep -v '^[[:space:]]*$' \
  | while read -r k; do resolve "$k"; done \
  || true)

[ -n "$PKGS" ] || fail "stage=pacman_install no packages resolved"

log "stage=pacman_install command=yay Installing packages: $PKGS"
# shellcheck disable=SC2086
yay -S --needed --noconfirm $PKGS || fail "stage=pacman_install yay install failed"

if ! have cargo; then
  log "stage=rustup_default command=rustup Installing rustup default toolchain..."
  rustup default stable || fail "stage=rustup_default rustup default stable failed"
else
  log "stage=rustup_default cargo already present: $(cargo --version)"
fi

log "stage=done Install complete. Restart your shell or run: exec \$SHELL"
