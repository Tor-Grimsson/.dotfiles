---
title: The memory system — localise, share, look up
type: explainer
status: active
updated: 2026-07-28
description: Why Claude's stock memory loses history and stays siloed, and the three-move design that fixes it — memory stored per-repo in .kol/, a global tier in dotfiles claude/memory, write-path symlinks, and the kol-glass vault as the single lookup surface. Master ASCII diagram + the tier split rule.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-claude-memory]]"
  - "[[02-repo-contract|dependencies & repo contract]]"
  - "[[03-kol-glass-vault|the vault lens]]"
---

# The memory system

## The problem (stock behavior)

| Fact | Consequence |
|---|---|
| Memory is keyed to the **absolute launch path**, flattened (`/`→`-`), under `~/.claude/projects/<key>/memory/` | Move or rename a repo and its memory is orphaned — the new path gets a fresh empty dir, the old files sit unread |
| Memory is **per-directory**, no global tier | A fact learned in one repo is invisible in every other; ~41 isolated memory dirs exist today, most keyed to dead paths |
| Memory is **untracked runtime state** | Nothing syncs between the iMac and the MBP; git never sees it |
| Only the launch dir's `MEMORY.md` index is auto-loaded | Cross-repo lookup doesn't exist — there is no surface to even grep |

## The design — three moves

1. **Localise** — each repo owns its memory at `.kol/llm-memory/` (agent-state, beside `.kol/llm-context/`). Tracked, so it moves with the repo and syncs between machines via git.
2. **Redirect** — the harness keeps writing where it always writes; a symlink per repo turns `~/.claude/projects/<key>/memory` into a view of the repo's `.kol/llm-memory/`. Claude Code needs zero changes.
3. **Aggregate** — the kol-glass vault grows a `memory/` lens beside `repos/`: one flat dir where every repo's memory (plus the global tier) is grep-able, Obsidian-searchable, and cross-linkable at once.

## Master diagram

```
STORAGE — each repo owns its memory (tracked, syncs via git like any file)

  ~/.dotfiles/                                  ~/dev/projects/<repo>/
  ├── claude/                                   ├── .kol/
  │   ├── CLAUDE.md, hooks/, skills/ …          │   ├── llm-context/
  │   └── memory/          ◀── GLOBAL tier      │   └── llm-memory/   ◀── REPO tier
  │       ├── MEMORY.md        (cross-repo      │       ├── MEMORY.md
  │       └── *.md              facts)          │       └── *.md
  └── .kol/
      └── llm-memory/      ◀── dotfiles' own REPO tier


WRITE PATH — Claude changes nothing; symlinks redirect its writes into git

  ~/.claude/projects/
  ├── -Users-biskup/
  │   └── memory ────────▶ ~/.dotfiles/claude/memory            (global)
  ├── -Users-biskup--dotfiles/
  │   └── memory ────────▶ ~/.dotfiles/.kol/llm-memory
  └── -Users-biskup-dev-projects-<repo>/
      └── memory ────────▶ ~/dev/projects/<repo>/.kol/llm-memory

  (per-machine machinery, recreated by the sync script; a repo move
   costs one relink instead of the whole memory history)


LOOKUP — the vault aggregates memory exactly like it aggregates docs

  ~/dev/projects/kol-glass/
  ├── INDEX.md
  ├── repos/                        (exists — the docs lens)
  │   ├── dotfiles   ──▶ ~/.dotfiles/docs
  │   └── <repo>     ──▶ ~/dev/projects/<repo>/docs
  └── memory/                       (new — the memory lens)
      ├── _global    ──▶ ~/.dotfiles/claude/memory
      ├── dotfiles   ──▶ ~/.dotfiles/.kol/llm-memory
      └── <repo>     ──▶ ~/dev/projects/<repo>/.kol/llm-memory
```

## The tier split rule

| A fact belongs in… | When |
|---|---|
| `claude/memory/` (global) | It applies **everywhere** — behavior rules, user preferences, cross-repo conventions. Most of today's `feedback_*` files are this in disguise. |
| `.kol/llm-memory/` (repo) | It's true **only in this repo** — its architecture quirks, machines, gotchas (e.g. dotfiles' two-machine/brew-prefix facts). |

When in doubt: would the fact be wrong or meaningless in another repo? No → global.

## What stays stock

File-per-fact markdown with frontmatter, `MEMORY.md` as the index, the harness auto-loading the launch dir's index — all unchanged. This design only relocates the storage and adds a lookup surface; no new tools, no database, no embeddings. Semantic search (MemPalace-style) is a later option **only if** grep over the vault lens measurably stops being enough.
