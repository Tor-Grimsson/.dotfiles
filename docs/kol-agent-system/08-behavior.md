---
title: 08 · Behavior — discipline shipped as code
type: explainer
status: active
updated: 2026-07-28
description: The anti-word-soup stack — the persona (ships as Ubu Roi), the ponytail laziness ladder, and the enforcement hooks (agent-reinforce cadence injection, footer-gate Stop-block, goal-loop, doc-sync-reminder) plus the memory tier that makes corrections durable. Output rules as executable machinery, not vibes.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[04-memory|04 — memory]]"
  - "[[10-naming|10 — naming]]"
---

# 08 · Behavior — discipline shipped as code

The thesis: people hate word soup, and a model won't hold the line from a prompt alone. So the line is held by **layers that re-assert themselves** — a persona, a build philosophy, hooks that inject and block, and memory that makes corrections permanent.

```
  LAYER            MECHANISM                        FIRES
  persona          CLAUDE.md (ships as Ubu Roi)     always loaded — tone, report shape, rules
  build philosophy ponytail plugin                  every response — the laziness ladder
  cadence          agent-reinforce.sh (hook)        turn 1 full · every ~5 turns compact
  gate             footer-gate.sh (Stop hook)       BLOCKS the reply that breaks the shape
  goal lock        goal-loop.sh (Stop hook)         blocks stopping until /kol-goal done
  sync nudge       doc-sync-reminder.sh             edit a tracked file → reminded to sync its doc
  durability       feedback memories (04)           corrections persist across sessions
```

## Why layered — the failure model

| Failure | Countered by |
|---|---|
| Model drifts mid-session | cadence re-injection (reinforce payloads: full + compact) |
| Model ends with offers/recaps/status prose | the gate — re-emit until the shape holds (body → ONE footer line → stop) |
| Model stops before a long task is done | goal lock |
| Correction forgotten next session | feedback memory, global tier |
| Over-building | ponytail ladder: exists? → codebase? → stdlib? → native? → dep? → one line? → then code |

## The report shape (what the gate enforces)

Header card → plain-language lead → tables over prose bullets → caveats folded into **one** footer line → nothing after it. Questions answered before work. Verdicts terse; reasoning on request. Clarity beats cleverness — if it needs a metaphor, it isn't clear yet.

## Export notes

- Persona ships as **Ubu Roi** — the tyrant king enforcing absurd discipline; the private persona name never appears. Ubu-bag naming throughout (`ubu-enchainé` seeded for goal-loop; the reinforce/gate pair are stage machinery).
- Ships as: CLAUDE.md **template** (Ubu as the worked example), the ponytail pairing note, the four hooks + two payload files — dual-shipped (embedded in this doc's export form + runnable `.sh`).
- Scrub: hooks are already generic; CLAUDE.md must be templated, not copied — it's the most personal file in the system.
