---
title: 02 · Context — state without breaking the context bank
type: explainer
status: active
updated: 2026-07-28
description: The .kol/llm-context state files — AGENT-CONTEXT (current state), ARCHITECTURE (load-bearing decisions), HISTORY (the why) — and the trim discipline that keeps them loadable forever: 5-entry chain, bounded status list, session-log as the archive, ~30 KB re-trim trigger.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[03-journaling|03 — journaling]]"
  - "[[05-plans|05 — plans]]"
---

# 02 · Context — state without breaking the context bank

Context is the scarce resource. This module is how an agent stays *informed* without the state files growing until they eat the window.

```
.kol/llm-context/
├── ARCHITECTURE.md     load-bearing decisions — "don't revisit without reason"
├── AGENT-CONTEXT.md    current state — loaded EVERY session, so bounded by rule
├── HISTORY.md          the narrative why — read on demand, never auto-loaded
├── session-log/        the archive — detail lives here, one hop away
├── session-bridge/     in-flight handoffs (03)
└── playbook/           live journals (03)
```

## The trim discipline (red-queen: run to stay in place)

| Rule | Bound |
|---|---|
| "Last updated" chain | **5 entries max** — older entries die at every milestone; each links its session log |
| "Status at a glance" | Bounded orientation window — append-only growth is the failure mode |
| Whole file | Re-trim when it drifts past **~30 KB** (recurring; 70→21 KB on 2026-07-11) |
| Open items | Live items only — closed/parked items leave the file (a milestone takes them to zero) |
| Detail | Never in AGENT-CONTEXT — the session log holds it; the state file links it |

**The invariant:** nothing is lost by trimming, because every cut bullet already links its archive entry. State files answer "where are we"; logs answer "how did we get here".

## Anatomy of AGENT-CONTEXT.md

1. **Last updated** — the 5-entry chain (newest first, 🏁 marks milestones).
2. **Status at a glance** — the orientation window.
3. **Repo layout** — table of what lives where.
4. **Consistency seams** — the places that drift if you're careless.
5. **Open items (live)** — zero after a milestone.
6. **Known gotchas** + **Contracts the next agent must not quietly break**.

## Export notes

- Alice-bag candidate (motion): the trim discipline (`red-queen` seeded). The state files themselves are glass-bag (state).
- Ships as: templates for the three files + the trim rules as a short spec + the milestone-seals-the-ledger convention ([[03-journaling|03]]).
- Scrub: templates only — real AGENT-CONTEXT files are full of private state.
