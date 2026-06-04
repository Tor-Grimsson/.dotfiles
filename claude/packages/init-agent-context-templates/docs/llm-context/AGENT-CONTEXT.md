---
_template:
  version: 1
  path: docs/llm-context/AGENT-CONTEXT.md
  sync: skip
---

# {{PROJECT_NAME}} — Agent Context

Current project state + operational reference. Updated at the end of each significant session.

For chronological detail see `session-log/`. For load-bearing decisions see `ARCHITECTURE.md`. For decision history / alternatives considered see `../history.md`. For speculative future work see `../plan.md`.

**Last updated:** {{TODAY_ISO}}

---

## Status at a glance

<!-- Short bullet summary of where the project is. Example:
- v0.1 — runtime-verified on X. Records Y files end-to-end.
- Packaging — not yet distributed.
- Smoke tests — items #1–#3 passed; #4–#10 pending.
-->

---

## What works

<!-- Bullet list of functional features. Keep concrete. -->

## What's pending

<!-- Bullet list of features/work that exists in the repo but isn't verified or complete. -->

## Active known issues

<!-- Bullet list of bugs or gaps that users/agents should know about. Mark severity if useful. -->

---

## Key files and their roles

<!-- Table of the most important files. Example:
| file | role | hot edit points |
|---|---|---|
| `src/main.js` | entry point | `init()`, `render()` |
| ... |
-->

| file | role | hot edit points |
|---|---|---|
| `...` | ... | ... |

---

## Critical consistency seams

<!-- Document any "if you change X, you must also change Y" requirements. These are the places that silently break when split and usually trip up new agents. -->

### [Seam name]

[Description of the duplication or tight coupling, and the rule for keeping it in sync.]

---

## Roadmap (prioritized)

<!-- Numbered list, ordered by impact-per-effort. Example:
1. **Feature X.** Description. ~N lines.
2. ...
-->

---

## Known gotchas

<!-- Bucket for bugs, quirks, performance traps, or environment-specific weirdness that agents should know about. Structure each as a small heading + 2-3 sentence explanation + planned fix. -->

### [Gotcha name]

[Description + fix plan if any.]

---

## Debugging recipes

<!-- Short reference for "how do I debug X?" questions. Example:
**Logs:** `path/to/log` — look for pattern X.
**Reload loop:** after editing Y, do Z.
-->

---

## Contracts the next agent should not quietly break

<!-- Invariants that must not drift. Example:
- `DEFAULTS` in file A must match `DEFAULT_CONFIG` in file B.
- Message type X is referenced in files Y, Z — rename = grep all.
-->

---

## Open architecture explorations

<!-- Pointer to ../plan.md if it carries real speculative work. Otherwise delete this section. -->
