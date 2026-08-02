---
title: Sharing & portability — the system for other users
type: explainer
status: active
updated: 2026-07-28
description: What it takes to make the memory system adoptable by other users — convention over configuration, zero hardcoded user paths, the vault repo as the shipped scaffold, the one hard dependency on Claude Code's path-keying, and the privacy line that tracked memory rides git history.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-claude-memory]]"
  - "[[01-memory-system|the memory system]]"
  - "[[03-kol-glass-vault|the vault lens]]"
---

# Sharing & portability

Making this shareable does **not** change the architecture — distributed storage, symlinked write path, vault lens all survive contact with another user's machine. What it changes is the packaging: everything user-specific must be *derived or declared*, never baked in.

## Requirements

| Requirement | Meaning |
|---|---|
| **Convention over config** | A repo joins by carrying `.kol/llm-memory/` — no registry, no manifest. The sync script discovers members by scanning; membership *is* the directory. |
| **Zero literal user paths** | No `/Users/biskup` anywhere in tracked files. Scan roots + the global-tier location are the two variables at the top of `sync.sh` (or env vars); everything else derives — the `~/.claude/projects` key derives from the absolute path, link names from dir names. Same discipline as the repo's no-hardcoded-brew-prefix rule. |
| **The scaffold is the product** | What ships is the **`memory-glass` template repo** (built 2026-07-28 at `~/dev/projects/kol-humpty-dumpty/memory-glass`, separate from the private kol-glass instance): `sync.sh` + README + generic INDEX + bundled `docs/SYSTEM.md` + ignore rules. A new user clones it, sets the two variables, runs the script. Their memory content is generated on their machine, never shipped. |
| **Global tier is a pattern, not a path** | "Your dotfiles repo carries `claude/memory/`" is the convention; users without a dotfiles repo point the variable at any git-backed dir. |

## The one hard dependency

The write-path trick rides Claude Code's **implementation detail** that per-project memory lives at `~/.claude/projects/<flattened-abs-path>/memory/`. That keying is not a public contract — a harness update could move or restructure it. Contained: the assumption lives in one function of `sync.sh` (path → key), and the storage itself is plain files in git, so a keying change costs a script edit, never the memory.

## Privacy line

- **Tracked memory rides git history.** A repo's `.kol/llm-memory/` goes wherever the repo goes — push a repo public and its memory (and every past version of it) is public. Facts about people, clients, or credentials don't belong in a tier that ships.
- The global tier is the most personal layer (user preferences, working style) — it belongs in a **private** repo, full stop.
- The shipped scaffold contains no memory at all; only the empty machinery. Nothing about one user's palace ever reaches another's.

## Non-goals

- No hosted/sync service, no database, no embeddings in the shareable core — plain files + git stay the whole stack ([[01-memory-system|01]] § what stays stock).
- No multi-user shared memory (two people writing one tier) — out of scope; git already models collaboration if a team wants to share a repo tier deliberately.
