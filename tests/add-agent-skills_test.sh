#!/usr/bin/env sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM
printf '%s\n' '#!/usr/bin/env sh' 'printf "npx %s\n" "$*"' > "$tmpdir/npx"
chmod +x "$tmpdir/npx"

SKILLS='JuliusBrussee/caveman --skill caveman
mattpocock/skills --skill grilling
'

PATH="$tmpdir:$PATH" AGENT_SKILLS="$SKILLS" AGENTS='amp codex' "$ROOT/scripts/add-agent-skills.sh" > "$tmpdir/agents.out" 2>/dev/null || fail 'script exited non-zero with AGENTS set'
grep -F 'npx --yes skills add JuliusBrussee/caveman --skill caveman --agent amp codex --global --yes' "$tmpdir/agents.out" >/dev/null || fail 'AGENTS list not appended after --agent'
grep -F 'npx --yes skills add mattpocock/skills --skill grilling --agent amp codex --global --yes' "$tmpdir/agents.out" >/dev/null || fail 'AGENTS list missing on second source'
[ "$(grep -c -- '--agent universal' "$tmpdir/agents.out")" -eq 0 ] || fail 'universal fallback still emitted when AGENTS set'

PATH="$tmpdir:$PATH" AGENT_SKILLS="$SKILLS" "$ROOT/scripts/add-agent-skills.sh" > "$tmpdir/default.out" 2>/dev/null || fail 'script exited non-zero without AGENTS'
grep -F 'npx --yes skills add JuliusBrussee/caveman --skill caveman --agent universal --global --yes' "$tmpdir/default.out" >/dev/null || fail 'universal fallback missing when AGENTS unset'

printf 'PASS add-agent-skills AGENTS handling\n'
