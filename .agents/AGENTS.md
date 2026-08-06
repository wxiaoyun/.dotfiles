## Communication Style

**!!! VERY IMPORTANT: YOU MUST FOLLOW THESE COMMUNICATION STYLES STRICTLY !!!**

Be as CONCISE as possible.
Be as DIRECT as possible.
Be as CONCRETE as possible.
Be as DETAILED as possible while keeping the response concise.

YAPPING is STRICTLY PROHIBITED.
You MUST NOT COMMENT unnecessarily.
You don't need to explain that you understand the user's request.
You just need to follow the instructions and provide the final report.
You must be quiet and focus on the task at hand.

## Critical Rules for Agents

- **Never assume internal terminology.** Ask when uncertain.
- **Always verify docs against code.** Every document must be cross-checked
   via the code worktrees.
- **Use lead/member separation for multi-agent work.** The lead orchestrates,
   cross-references, follows up, and updates docs. Members handle code analysis.
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

When writing or modifying code (especially services, clients, orchestrators, cron jobs):

1. **Log at failure sites with ERROR** — not only WARN. Final failures after retries must be ERROR so log filters surface them.
2. **Log before external calls with INFO** — include method, URL/path (no secrets), and context (job_id, target, stage, idc, cluster).
3. **Log at every fallible boundary** — API calls, config parse, Redis/DB I/O, mapping/validation, retry exhaustion.
4. **Include structured fields** — use tracing fields (`job_id`, `target`, `stage`, `error`, `status`, `api_status`) so failures are searchable without reading stack traces.
5. **On HTTP/API errors** — log status + truncated response body (cap ~512 chars); never log tokens or credentials.
6. **Name the stage** — e.g. `fetch_sql`, `fetch_integral`, `dedup_get` so one log line identifies the broken step.
7. **Retries** — WARN on intermediate retry; ERROR on final attempt with attempt count.
8. **Skips are INFO** — log reason (`empty_value_list`, `no_new_day`) with context.

Default: add logging when touching fallible code even if user did not ask — debugging production issues depends on it.

Rust: `tracing::{info, warn, error}`. Match existing project conventions.

## Commit Message Preferences

- **No co-author lines**: Never include `Co-Authored-By` or any co-author
  information in commit messages.
- **Title format**: Use `<type>: <title>` (e.g., `fix: resolve login bug`,
  `feat: add search bar`). Do NOT use parenthesized subtypes like `fix(auth): ...`.

# Tool Use

## Rust Token Killer

Every Shell tool command: wrap with `rtk` subcommand. Cursor has no rtk hook — you must prefix manually every time.

Session start (once per chat): Read `$HOME/.claude/RTK.md`.

Prefix mapping:
- git …          → rtk git …
- gh …           → rtk gh …
- rg … / grep …  → rtk rg … / rtk grep …
- ls …           → rtk ls …
- cat/head/tail file → rtk read <path>
- find …         → rtk find …
- diff …         → rtk diff …
- docker …       → rtk docker …
- kubectl …      → rtk kubectl …
- pnpm/npm test/build → rtk pnpm … or rtk test …
- cargo test …   → rtk test cargo test …

Exceptions:
- pure shell with no command output (cd, export, mkdir, true) — no rtk
- need full unfiltered output → rtk proxy <original command>
- MCP / non-Shell tools — rtk not apply

If `rtk gain` fails: wrong binary installed (Rust Type Kit collision). Check `which rtk` = `/opt/homebrew/bin/rtk`.<D-b>

## CRITICAL: Efficient JSON Reading with `jq`

**YOU MUST USE `jq` to extract specific data from JSON files instead of reading entire files.**
**THE ONLY EXCEPTION IS FOR THE `<ANALYSIS_DIR>/*_short.json` FILES WHICH WILL BE MORE EFFICIENT IF YOU JUST READ THE WHOLE FILE!**

### Common Patterns:

**Get completed items from analysis_queue.json:**
```bash
jq '.completed[] | select(.id == "<dependency_id>")' <ANALYSIS_DIR>/analysis_queue.json
```

**Get specific node from dependency_tree.json:**
```bash
jq '.nodes["<node_id>"]' <ANALYSIS_DIR>/dependency_tree.json
```

**Get calls array from a node:**
```bash
jq '.nodes["<node_id>"].calls' <ANALYSIS_DIR>/dependency_tree.json
```

### YOU MUST NEVER EVER!:
- Use Read tool to read entire JSON files EXCEPT for the `<ANALYSIS_DIR>/*_short.json` files
- Load full analysis files when you only need specific fields

# Skill Use

## Caveman

Session start + every user message: FIRST action = Read `$HOME/.agents/skills/caveman/SKILL.md` with Read tool. Do this before any user-facing reply, tool plan, or investigation — including meta/testing/questions.

Then follow skill exactly for all responses. Default intensity: full.

Exceptions (no caveman): user says "stop caveman" / "normal mode"; OR task is written documentation (README, design doc, PR body, blog).

On conflict with other style rules (blog prose, tables, pleasantries), caveman wins unless exception above applies.

Do not announce caveman mode. Do not answer in normal prose then add caveman recap.
