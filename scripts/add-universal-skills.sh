#!/usr/bin/env sh
set -eu
set -f

if [ -z "${AGENT_SKILLS:-}" ]; then
  printf '%s\n' '[mise_agents] ERROR stage=config error=missing_skill_list' >&2
  exit 1
fi

while IFS= read -r skill; do
  [ -n "$skill" ] || continue
  set -- $skill
  printf '%s\n' "[mise_agents] stage=skills_install source=$1" >&2
  npx --yes skills add "$@" --agent universal --global --yes </dev/null
done <<SKILLS
$AGENT_SKILLS
SKILLS
