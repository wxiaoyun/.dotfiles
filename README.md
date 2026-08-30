# Dotfiles Repository

This repository uses [mise bootstrap](https://mise.jdx.dev/bootstrap.html) for dotfiles, host packages, tools, and shell activation.

## Bootstrap

```sh
git clone --recursive https://github.com/wxiaoyun/dotfiles.git
cd dotfiles
mise trust
mise bootstrap plan
mise bootstrap dotfiles apply --dry-run --verbose
mise bootstrap
```

`mise bootstrap` selects Homebrew on macOS and Pacman on Arch Linux. Arch AUR packages install through a small idempotent bootstrap task.

For Debian host using Linuxbrew profile:

```sh
mise -E remote_box bootstrap plan
mise -E remote_box bootstrap
```

## Safety and rollback

Normal migration never uses `--force-dotfiles`. Resolve each dry-run conflict manually.

Preview removal of identifiable managed dotfiles:

```sh
mise bootstrap dotfiles unapply --dry-run
```

Use `mise bootstrap status` to inspect applied, missing, and differing configuration.
