---
title: 10 · Naming — the three-family system
type: reference
status: active
updated: 2026-07-28
description: Names are picked from a bag, never invented — Glass owns state (holds/shows context), Ubu Roi owns actors (persona, behavior, enforcement), Alice owns motion (init, traversal, sync, search). Assigned names, seed bags, and the rules. Agent copy lives at .kol/llm-context/NAMING.md.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[08-behavior|08 — behavior]]"
---

# 10 · Naming — the three-family system

Set 2026-07-28. Naming is a **lookup, not a decision**: ask what kind of thing it is, then pick from that family's bag. Three concepts own three domains — state, actors, motion.

| Family | Domain | The test | The well it draws from |
|---|---|---|---|
| **A · Glass** | **State** — holds or shows context | "What's inside the glass?" | memory as snapshot stored in glass — self-explanatory by construction |
| **B · Ubu Roi** | **Actors** — persona, behavior, enforcement | Is it a character or prop in the theater of discipline? | Jarry's absurdist king → modernism (dada, surrealism, absurdism) → the mangled-Shakespeare set (Macbeth, Lear, Hamlet bastardised) |
| **C · Alice** | **Motion** — takes you somewhere | Is it a journey? | Wonderland + Through the Looking-Glass — and Alice enters *through the glass*, which is literally what a symlink does |

## Assigned

| Name | Thing | Family |
|---|---|---|
| **`jabberwocky`** | the umbrella repo — the whole exported OS | Alice |
| **`humpty-dumpty`** | the wall-sitter plugin — reuse doctrine + muzzle stepper | Alice |
| `memory-glass` | the memory tool (public template) | Glass |
| `kol-glass` | the private lens instance | Glass |
| **Ubu Roi** | the published persona — never the private name | Ubu |

**Orthography rule:** compounds hyphenate (`memory-glass`, `white-rabbit`); canonical single names stay one word (`jabberwocky`, `cheshire`). Bags are English-only — the heavy-French seeds (`enchainé`, `pataphysics`) were cut 2026-07-28.

## Seed bags (proposals — nothing here is decided)

- **Glass:** `hourglass` — journaling, time in glass · `spyglass` — search over distant repos · `weather-glass` — status/monitoring
- **Ubu / mangled Shakespeare:** *palotins* — Ubu's henchmen: subagents · `king-ubu` · `nowhere` ("The scene is Poland, that is to say, Nowhere") · `elsinore` · `dunsinane` · `birnam` · `yorick` · `arden`
- **Alice:** **`humpty-dumpty`** — chambered by the user, unassigned · `rabbit-hole` — boot/init, what you fall into · `cheshire` — the handoff that persists as a grin · `red-queen` — context trim, running to stay in place · `white-rabbit` — cron, "I'm late" · `wabe` · `red-king` · `boojum`
- **Modernism (dada · surrealism · absurdism):** `readymade` — a system you take as-is · `merz` — assembled from fragments · `exquisite-corpse` — each hand adds a part without seeing the whole

## Rules

1. New thing → classify (state / actor / motion) → pick from that bag. If no bag word fits, extend the *bag*, not the system.
2. Agents never present a name as decided — propose from the bag, flag, wait. Working titles stay descriptive (`kol-agent-system`).
3. One honest noun per name; the README carries the *what* (the memory-glass precedent).
4. English words only — heavy French died 2026-07-28 (the user shouldn't need a dictionary for his own repo list).

Agent copy: `.kol/llm-context/NAMING.md` — same content, terser.
