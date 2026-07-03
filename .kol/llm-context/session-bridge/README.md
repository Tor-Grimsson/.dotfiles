---
_template:
  version: 1
  path: .kol/llm-context/session-bridge/README.md
  sync: replace
---

# session-bridge — in-flight handoffs

Short-lived handoff notes for work paused **mid-arc**, before a natural retrospective break. Distinct from:

- `../session-log/` — past-tense, archival; written when a unit of work *concludes*.
- `../AGENT-CONTEXT.md` — long-lived committed state, not in-flight thoughts.

A bridge fills the gap when you hit `/clear`, `/compact`, or open a new chat mid-task — the "I just tried X, was about to do Y, hit Z" working memory that nothing else captures.

## Filename
`handoff-YYYY-MM-DD-HHMM[-brief-slug].md` (the `HHMM` makes same-date comparison against a session log unambiguous).

## Startup protocol
After reading `ARCHITECTURE.md` + `AGENT-CONTEXT.md`: always read the newest `../session-log/`; also read the newest `handoff-*.md` if it's newer (same-date tie → handoff wins, since it's written last). Older handoffs are passive history.

## What a handoff covers
1. Goal of the current arc. 2. Last actions taken (the causal trail). 3. Current state / blocker / decision point. 4. Next intended action. 5. Anything in working memory not yet in AGENT-CONTEXT. Keep it brief — a bridge, not a document.

## Lifecycle
Created by `/log-work` when work is mid-arc; read by the next session; superseded by a later-dated session log; **never auto-deleted** by the agent.
