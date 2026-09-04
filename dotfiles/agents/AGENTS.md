# Critical Rules for Agents

- **Never assume internal terminology.** Ask when uncertain.
- **Always verify docs against code.** Every document must be cross-checked
   via the code worktrees.
- **Default to skepticism on handoff claims.** If a handoff points to a
   specific file:line or proposes a fix, verify the symbol, semantics,
   reachability, and remedy against current code before acting.
- **Review before commit.** Code changes are reviewed by a human before any
   commit or push. Do not auto-commit or auto-push.
- **Use online data tools to verify and clarify.** Query live systems through
   the installed skills instead of reasoning from code alone.
- **No niche symbols or punctuation.** No em-dashes, no semicolons, no
   section symbols. No mid-sentence line breaks.

## Coding Practices

Use logging extensively to help debugging, especially at fallible places to pinpoint point of failure.

1. **Log at failure sites with ERROR** — not only WARN. Final failures after retries must be ERROR so log filters surface them.
2. **Log before external calls with INFO** — include method, URL/path (no secrets), and context (job_id, target, stage, idc, cluster).
3. **Log at every fallible boundary** — API calls, config parse, Redis/DB I/O, mapping/validation, retry exhaustion.
4. **Include structured fields** — use tracing fields (`job_id`, `target`, `stage`, `error`, `status`, `api_status`) so failures are searchable without reading stack traces.
5. **Name the stage** — e.g. `fetch_sql`, `fetch_integral`, `dedup_get` so one log line identifies the broken step.

Default: add logging when touching fallible code even if user did not ask — debugging production issues depends on it.

## Commit Message Preferences

- **No co-author lines**: Never include `Co-Authored-By` or any co-author
  information in commit messages.

## CLI use

- `jq`: use `jq` to extract specific data from JSON files instead of reading entire files

## Skill Use

### Caveman

Session start: FIRST action = Read `$HOME/.agents/skills/caveman/SKILL.md` with Read tool. Do this before any user-facing reply, tool plan, or investigation — including meta/testing/questions.

Then follow skill exactly for all responses. Default intensity: full.
