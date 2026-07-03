---
_template:
  version: 1
  path: .kol/llm-context/ARCHITECTURE.md
  sync: skip
---

# {{PROJECT_NAME}} — Architecture

Load-bearing decisions and constraints. Anything in this document is "we chose this deliberately and it has downstream consequences." Do not revisit without explicit reason. For decision history (alternatives considered, rejections, and evolution), see `../history.md`.

---

<!--
Structure each decision as:
  ## §N — [short rule / invariant]
  [One to three sentences explaining what the rule is and why it holds.]
  **Consequence:** [what this enables or forbids downstream]
  **Do not revisit** unless [specific condition that would flip it]

Keep sections short. If it's growing into a session-log-style narrative, it belongs in a session log, not here.

Example:
-->

## §1 — [First load-bearing decision]

[One-sentence statement of the rule.]

[Short explanation of why this was chosen.]

**Consequence:** [downstream implication that shapes future decisions]

**Do not revisit** unless [specific trigger condition].

---

## §2 — [Second load-bearing decision]

...

---

## §N — Non-goals (do not reopen)

Stated design limits. Opening discussion on any of these requires explicit user ask:

- [Non-goal 1]
- [Non-goal 2]
- [Non-goal 3]
