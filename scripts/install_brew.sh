#!/usr/bin/env sh
set -eu

log()  { printf '[install_brew] %s\n' "$*" >&2; }
fail() { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_LIST="$(cd "$SCRIPT_DIR/.." && pwd)/install.txt"
OVERRIDES="${SCRIPT_DIR}/brew-overrides.txt"
[ -f "$INSTALL_LIST" ] || fail "stage=config install list not found: $INSTALL_LIST"
[ -f "$OVERRIDES" ] || fail "stage=config overrides not found: $OVERRIDES"

resolve() {
  while IFS='=' read -r key name; do
    [ -z "$key" ] && continue
    case "$key" in '#'*) continue ;; esac
    [ "$key" = "$1" ] && { echo "$name"; return; }
  done < "$OVERRIDES"
  echo "$1"
}

OS=$(uname)
[ "$OS" = "Darwin" ] || fail "stage=os_check install_brew.sh targets macOS only (got: $OS)"

if ! have brew; then
  log "stage=install_brew method=GET url=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    || fail "stage=install_brew Homebrew install failed"
else
  log "stage=install_brew Homebrew already present: $(brew --version | head -1)"
fi

eval "$(brew shellenv)"

log "stage=brew_update Running brew update..."
brew update --quiet || fail "stage=brew_update brew update failed"

log "stage=brew_install Reading package list from $INSTALL_LIST"
FORMULAE=$(sed -n '/^# Fonts (cask)/q; p' "$INSTALL_LIST" \
  | grep -v '^[[:space:]]*#' \
  | grep -v '^[[:space:]]*$' \
  | while read -r k; do resolve "$k"; done \
  || true)

CASKS=$(sed -n '/^# Fonts (cask)/,$p' "$INSTALL_LIST" \
  | grep -v '^[[:space:]]*#' \
  | grep -v '^[[:space:]]*$' \
  | while read -r k; do resolve "$k"; done \
  || true)

if [ -n "$FORMULAE" ]; then
  log "stage=brew_install Installing formulae: $FORMULAE"
  # shellcheck disable=SC2086
  brew install $FORMULAE || fail "stage=brew_install brew install formulae failed"
else
  log "stage=brew_install reason=empty_formulae No formulae to install"
fi

if [ -n "$CASKS" ]; then
  log "stage=brew_install Installing casks: $CASKS"
  # shellcheck disable=SC2086
  brew install --cask $CASKS || fail "stage=brew_install brew install casks failed"
else
  log "stage=brew_install reason=empty_casks No casks to install"
fi

if ! have cargo; then
  log "stage=rustup_default Installing rustup default toolchain..."
  rustup default stable || fail "stage=rustup_default rustup default stable failed"
else
  log "stage=rustup_default cargo already present: $(cargo --version)"
fi

log "stage=done Install complete. Restart your shell or run: exec \$SHELL"
