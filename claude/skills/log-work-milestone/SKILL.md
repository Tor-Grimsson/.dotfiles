---
name: log-work-milestone
description: Log a MILESTONE — the close of a process/arc within whatever concept the work has focused on. A capstone session log that declares the arc DONE and CLOSES its open threads (resolve them, park them in a plan file, or mark them complete — never carry an "open items / next steps" list forward). The closure sibling of /log-work. Use when the user invokes /log-work-milestone, or says a process/phase/arc is finished and wants it sealed.
---

# Log Work — Milestone

A **milestone** marks the end of a process/arc — the point where a concept's work is *done*, not merely paused or checkpointed. This writes the capstone session log and **seals** the arc: it closes open threads instead of listing them. The closure member of the log family:

| Skill | Writes | When | Open threads |
|---|---|---|---|
| `/log-work` | `session-log/…md` | end of a session | may list Next steps |
| `/log-work-handoff` | `session-bridge/…md` | pausing mid-arc | carries them forward |
| `/log-work-playbook` | `playbook/…md` | continuously, mid-work | append-only journal |
| **`/log-work-milestone`** | `session-log/…md` **+ AGENT-CONTEXT 🏁** | an arc/process is DONE | **closes** them — nothing carried |

Summary from user: $ARGUMENTS

## Locate the context directory
Check in order, first that exists: 1. `.kol/llm-context/` (current) · 2. `.claude/llm-context/` · 3. `.llm-context/` · 4. `docs/llm-context/`. If none, say so and stop.

## Steps

1. Read `<ctx>/AGENT-CONTEXT.md` — the arc's prior state and every open item it leaves.
2. **Close the threads.** For each open item: resolve it, move it to a plan file (`<ctx>/llm-plan/NN-…md`), or mark it DONE with the outcome. A milestone emits **no** "Next steps" / "Known issues" list — if something is genuinely unfinished, it is not a milestone; use `/log-work` or `/log-work-handoff` instead.
3. Write the capstone at `<ctx>/session-log/`date +%Y-%m-%d`-MILESTONE-<slug>.md`:

```
# 🏁 Milestone: [arc / concept]

**Date:** YYYY-MM-DD
**Agent:** [identifier]
**Arc:** [the process this closes — one line]
**Delivered:** [the capstone summary — what the arc produced]

## What closed
- [thread] → [resolved | parked at <plan> | done, with outcome]

## The arc (brief)
- [3–6 lines on the shape of the work; link the session logs it spans]
```

4. Update `<ctx>/AGENT-CONTEXT.md`: prepend (or mark the head entry) with a leading `🏁`, **trim the "Last updated" chain to 5**, and ensure **no open item survives** — each is closed or parked. AGENT-CONTEXT is *current state*; a closed arc is state, an open TODO is not.
5. Reinforcement is automatic (the `agent-reinforce` hook) — nothing to load.
6. Report **minimally** — one line: `🏁 Milestone logged: session-log/<file>.md`. Nothing more. A milestone closes reporting; it does not open it.
