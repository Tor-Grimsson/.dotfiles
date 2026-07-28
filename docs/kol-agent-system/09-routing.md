---
title: 09 · Routing — the glass lenses and search
type: explainer
status: active
updated: 2026-07-28
description: The mother-load layer — kol-glass aggregates 30+ repos' docs and memory into two symlink lenses, one Obsidian meta-vault, one grep surface. Search strategy stays lazy — grep and Obsidian until they measurably fail; an indexer is the parked upgrade, not the default.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[04-memory|04 — memory]]"
  - "[[07-human-tier|07 — human tier]]"
---

# 09 · Routing — the glass lenses and search

One place to look. The private instance (kol-glass) lenses every repo; the pattern is shipped in memory-glass; the future is more lenses, not more machinery.

```
  kol-glass (private)                       30+ source repos
  ├── repos/    ──▶ every <repo>/docs             ▲
  ├── memory/   ──▶ every tier + _global          │ sync.sh (idempotent)
  └── sync.sh   ── scans ROOTS, links, prunes, ───┘
                   wires the write paths
```

## Search strategy — the ladder holds

| Rung | Surface | When it fails |
|---|---|---|
| 1 | **Obsidian** over the lens — search, graph, backlinks | never for reading; weak for bulk queries |
| 2 | **grep** — `grep -r <pat> repos/*/ memory/*/` (the `*/` descends symlinks) | vocabulary mismatch at large corpus |
| 3 | an **indexer** (python, or embeddings) | build ONLY when 2 measurably fails — parked, per the MemPalace verdict |

## What routing gives each audience

| Audience | Win |
|---|---|
| Human | one vault over every project; edits write through to source repos |
| Agent | cross-repo lookup for memory and docs that stock harnesses simply don't have |
| Export | the lens repo IS the shipped scaffold — tracked trio (INDEX · ignore · sync.sh), links regenerated locally |

## Export notes

- Glass-bag: `spyglass` seeded for the search layer if it ever becomes its own tool; the lens pattern already shipped in memory-glass.
- Scrub: the private instance's INDEX (client roster) never ships — the memory-glass template is the public face.
- Rule carried from the build: membership = `.git ∨ docs/ ∨ .kol/llm-memory/`; personal vaults excluded by name.
