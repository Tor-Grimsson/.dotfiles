---
title: 04 · Memory — the shipped cog
type: reference
status: active
updated: 2026-07-28
description: Pointer module — the tier system (global claude/memory, per-repo .kol/llm-memory), the write-path redirect, and the lens are fully designed in kol-claude-memory/ and shipped as memory-glass. This doc places the cog in the wholesale and records what the other modules assume of it.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[../kol-claude-memory/INDEX|kol-claude-memory — the deep docs]]"
  - "[[09-routing|09 — routing]]"
---

# 04 · Memory — the shipped cog

The one module already extracted and shipped: **memory-glass** (public template) / **kol-glass** (private instance). The deep design lives in [[../kol-claude-memory/INDEX|kol-claude-memory/]] — this doc only places the cog in the wholesale.

```
  global tier   dotfiles claude/memory/      cross-repo facts (applies everywhere)
  repo tier     <repo>/.kol/llm-memory/      this-repo-only facts
  redirect      ~/.claude/projects/<key>/memory → symlink into the tiers
  lens          kol-glass memory/            all tiers, one grep-able surface
```

## What the other modules assume of memory

| Module | Assumption |
|---|---|
| [[01-init\|01 init]] | The launch repo's `MEMORY.md` auto-loads; a pointer line in it names the global tier |
| [[02-context\|02 context]] | Memory holds *facts*; AGENT-CONTEXT holds *state* — a fact that's really project state belongs there instead |
| [[08-behavior\|08 behavior]] | Feedback memories are the durable half of discipline — hooks enforce in-session, memory persists across sessions |
| [[09-routing\|09 routing]] | The memory lens is one of the glass surfaces routing searches |

## The split judgment (the one manual step)

The harness always writes to the launch repo's tier. The agent then judges: *would this fact be wrong or meaningless in another repo?* No → move it up to the global tier and index it there. Live example 2026-07-28: a clarity rule written in dotfiles, moved up within the minute.

## Export notes

- Already exported — the discipline this module models for every other extraction: design docs first, scrub screen, instance/template name split, adapter seam isolated.
- Remaining private backlog: ~30 dead-key memory dirs awaiting triage (parked).
