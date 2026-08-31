#!/usr/bin/env sh
set -eu

if [ -z "${PI_PACKAGES:-}" ]; then
  printf '%s\n' '[mise_agents] ERROR stage=config error=missing_package_list' >&2
  exit 1
fi

while IFS= read -r package; do
  [ -n "$package" ] || continue
  printf '%s\n' "[mise_agents] stage=pi_install package=$package" >&2
  pi install "$package"
done <<PACKAGES
$PI_PACKAGES
PACKAGES
