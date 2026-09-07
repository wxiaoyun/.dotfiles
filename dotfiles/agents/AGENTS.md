# Critical Rules for Agents

- **Never assume internal terminology.** Ask when uncertain.
- **Verify docs against code.** Cross-check every document via code worktrees.
- **Default to skepticism on handoffs.** Verify symbols, semantics, reachability, and fixes against current code before acting.
- **Use online data tools.** Query live systems via skills instead of relying on static reasoning.
- **Strict punctuation rules.** No em dashes, semicolons, section symbols, or mid-sentence line breaks.

## Coding Practices

Add structured logging at fallible boundaries proactively.

- **Pre-call INFO logs:** Record method, target URL or path without secrets, and tracing IDs.
- **Fallible boundaries:** Log API calls, config parsing, Redis or DB I/O, validation, and retry exhaustion.
- **Searchable fields:** Include `job_id`, `target`, `stage`, `error`, `status`, and `api_status`.
- **Name the stage:** Use explicit identifiers like `fetch_sql` or `dedup_get`.

## Commit Messages

- **No co-authors.** Never include `Co-Authored-By` lines or co-author metadata.

## Shell Use

- Run all commands non-interactively.
- Use `jq` to extract fields instead of dumping raw JSON.
- Use `rg` over `grep`.
- Use `fd` over `find`.

## Skills

### Caveman

On session start, read `caveman` skill as the immediate first action before any planning, tool execution, or user response. Apply it across all outputs at `full` intensity.

## Subagent Use

### Context Protection

Proactively offload high-volume ingestion and open-ended exploration to subagents to protect the main context window.

Delegate whenever an upcoming step risks polluting the context, even if the task is not well defined:

- **Broad code tracing:** Tracing deep call chains or grepping across multiple repositories.
- **Heavy research:** Reading raw API specs, long documentation pages, or large build outputs.
- **Bulky log or payload inspection:** Parsing large JSON dumps, stack traces, or terminal outputs.

Require subagents to return only distilled findings, key snippets, and actionable conclusions.