#!/usr/bin/env sh
set -eu

if [ -z "${AUR_PACKAGES:-}" ]; then
  printf '%s\n' '[mise_aur] ERROR stage=config error=missing_package_list' >&2
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  printf '%s\n' '[mise_aur] stage=os_check reason=not_arch skip' >&2
  exit 0
fi

if ! command -v yay >/dev/null 2>&1; then
  printf '%s\n' '[mise_aur] stage=yay_install method=git_clone url=https://aur.archlinux.org/yay.git' >&2
  tmpdir=$(mktemp -d)
  trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
fi

set -f
set -- $AUR_PACKAGES
printf '%s\n' "[mise_aur] stage=aur_install packages=$*" >&2
yay -S --needed --noconfirm "$@"
