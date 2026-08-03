---
title: 08 · Behavior — discipline shipped as code
type: explainer
status: superseded
updated: 2026-08-03
description: The anti-word-soup stack — the persona (ships as Ubu Roi), the ponytail laziness ladder, and the enforcement hooks (agent-reinforce cadence injection, footer-gate Stop-block, goal-loop and its checklist, doc-sync-reminder) plus the memory tier that makes corrections durable. Output rules as executable machinery, not vibes.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[04-memory|04 — memory]]"
  - "[[10-naming|10 — naming]]"
---

# 08 · Behavior — discipline shipped as code

> **SUPERSEDED 2026-08-03 — the machinery named below moved to the humpty plugin.**
> Every hook this doc describes left `claude/hooks/` in the agent-behaviour
> consolidation; `settings.json` no longer carries a `hooks` key at all. The file
> map here is kept as the DESIGN RECORD of how it was wired in dotfiles — it is no
> longer where the code lives. Current wiring: `humpty/hooks/hooks.json`.
> Quarantined originals: `_tmp/2026-08-03-agent-behaviour-to-humpty/`.


The thesis: people hate word soup, and a model won't hold the line from a prompt alone. So the line is held by **layers that re-assert themselves** — a persona, a build philosophy, hooks that inject and block, and memory that makes corrections permanent.

```
  LAYER            MECHANISM                        FIRES
  persona          CLAUDE.md (ships as Ubu Roi)     always loaded — tone, report shape, rules
  build philosophy ponytail plugin                  every response — the laziness ladder
  cadence          humpty_track.py (plugin)        turn 1 full · every ~5 turns compact
  gate             humpty_footer.py (plugin)       BLOCKS the reply that breaks the shape
  goal lock        humpty_goal.py (plugin)         blocks stopping until every `- [ ]` is ticked
  sync nudge       doc-sync-reminder.sh             edit a tracked file → reminded to sync its doc
  durability       feedback memories (04)           corrections persist across sessions
```

## Why layered — the failure model

| Failure | Countered by |
|---|---|
| Model drifts mid-session | cadence re-injection (reinforce payloads: full + compact) |
| Model ends with offers/recaps/status prose | the gate — re-emit until the shape holds (body → ONE footer line → stop) |
| Model stops before a long task is done | goal lock |
| Model closes a multi-item goal with items 2–5 undone | the goal lock's **checklist** — `done` is refused while any `- [ ]` remains, and the next item is re-injected by name |
| Correction forgotten next session | feedback memory, global tier |
| Over-building | ponytail ladder: exists? → codebase? → stdlib? → native? → dep? → one line? → then code |

## The goal lock's checklist — `done` is the file's call

Added 2026-08-01, on the **third** occurrence of one failure. The goal was a single prose blob and `status` was binary, so a multi-item plan had nothing the hook could count: an agent that hit a wall on item 1 wrote `status: done` and the loop released, whatever was left.

| Date | What it looked like |
|---|---|
| 2026-07-30 | `done` written at each sub-step — *"that is gaming the loop"* |
| 2026-08-01 | *"wtf. why are these tasks open still? did the loop fail?"* — it did exactly what it was told |
| 2026-08-01 | item 1 rejected, session closed instead of moving to item 2 |

`- [ ]` lines in `.active-goal.md` **are** the list. `status: done` with any box unticked flips the goal back to `active` and re-injects the next one by name. An item you cannot finish is a reason to move on and come back, never a reason to close.

**Three outs keep it from becoming a trap:** a file with no checkboxes behaves exactly as before, `blocked` still releases, and the iteration cap is checked first and is never policed.

## The report shape (what the gate enforces)

Header card → plain-language lead → tables over prose bullets → caveats folded into **one** footer line → nothing after it. Questions answered before work. Verdicts terse; reasoning on request. Clarity beats cleverness — if it needs a metaphor, it isn't clear yet.

## Export notes

- Persona ships as **Ubu Roi** — the tyrant king enforcing absurd discipline; the private persona name never appears. Ubu-bag naming throughout (`ubu-enchainé` seeded for goal-loop; the reinforce/gate pair are stage machinery).
- Ships as: CLAUDE.md **template** (Ubu as the worked example), the ponytail pairing note, the four hooks + two payload files — dual-shipped (embedded in this doc's export form + runnable `.sh`).
- Scrub: hooks are already generic; CLAUDE.md must be templated, not copied — it's the most personal file in the system.
