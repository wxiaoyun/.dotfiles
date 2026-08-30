#!/usr/bin/env sh
set -eu

log() { printf '[mise_aur] %s\n' "$*" >&2; }
fail() { log "ERROR: stage=$1 error=$2"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

if [ "$(uname)" != "Linux" ] || ! have pacman; then
  log 'stage=os_check reason=not_arch skip'
  exit 0
fi

packages='herdr-bin rtk-bin pi-coding-agent-bin'

if ! have yay; then
  log 'stage=yay_install command=sudo pacman -S --needed --noconfirm base-devel git'
  sudo pacman -S --needed --noconfirm base-devel git || fail yay_install pacman_failed
  tmpdir=$(mktemp -d) || fail yay_install mktemp_failed
  trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM
  log 'stage=yay_install method=git_clone url=https://aur.archlinux.org/yay.git'
  git clone https://aur.archlinux.org/yay.git "$tmpdir/yay" || fail yay_install clone_failed
  log 'stage=yay_install command=makepkg -si --noconfirm'
  (cd "$tmpdir/yay" && makepkg -si --noconfirm) || fail yay_install makepkg_failed
fi

for package in $packages; do
  if pacman -Q "$package" >/dev/null 2>&1; then
    log "stage=aur_install package=$package reason=installed skip"
    continue
  fi
  log "stage=aur_install package=$package command=yay -S --needed --noconfirm"
  yay -S --needed --noconfirm "$package" || fail aur_install "package=$package"
done
