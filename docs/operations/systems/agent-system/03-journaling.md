---
title: 03 · Journaling — the four log skills
type: explainer
status: active
updated: 2026-07-28
description: The time axis of the system — playbook (live, append-only, real timestamps), session-log (retrospective), session-bridge handoff (forward-looking), and milestone (the seal that closes an arc and zeroes open threads). Who writes what, when, and the rules that keep logs cheap.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[02-context|02 — context]]"
---

# 03 · Journaling — the four log skills

Four skills, four tenses. Logging is **never reflexive** — it happens when the user calls it (the one exception: playbook entries during an effort the user asked to track).

```
            DURING                 AT CLOSE                PAUSING              ARC DONE
     ┌────────────────┐      ┌────────────────┐      ┌────────────────┐    ┌────────────────┐
     │ /playbook      │      │ /log-work      │      │ /log-work-     │    │ /log-work-     │
     │ append-only    │      │ retrospective  │      │  handoff       │    │  milestone 🏁  │
     │ real timestamps│      │ summary        │      │ in-flight state│    │ SEALS the arc  │
     └───────┬────────┘      └───────┬────────┘      └───────┬────────┘    └───────┬────────┘
         playbook/             session-log/           session-bridge/       session-log/ +
                                                                            AGENT-CONTEXT 🏁
```

| Skill | Writes | Shape | Open threads |
|---|---|---|---|
| `/playbook` (alias of `log-work-playbook`) | `playbook/<date>-<slug>.md` | one idea per line, `[HH:MM]` real time from `date`, never guessed; append at bottom, never rewrite | n/a — it's a scrollback |
| `/log-work` | `session-log/<date>-<slug>.md` | 1–2 sentence summary + short change list; ≤2 min of work | may list next steps |
| `/log-work-handoff` | `session-bridge/handoff-*.md` | goal, open decisions, next intended action | carries them forward |
| `/log-work-milestone` | `session-log/<date>-MILESTONE-*.md` | capstone; updates AGENT-CONTEXT with 🏁, trims chain | **closes every one** — resolve, park, or done; nothing carried |

## Rules that keep it cheap

- Real timestamps only (`date` before every playbook append) — the journal's whole value.
- The diff is the source of truth — logs summarize, never re-narrate.
- Milestone = "if something is genuinely unfinished, it is not a milestone."
- `/ag-init` reads the newest log + any newer handoff — journaling is what makes cold boots warm.

## Export notes

- Glass-bag candidate (state-over-time): `hourglass` seeded for the whole module.
- Ships as: the four skill files + this doc; they are nearly dotfiles-independent already (they only assume `.kol/llm-context/`).
- Scrub: skill examples reference private logs — swap for generic ones.
