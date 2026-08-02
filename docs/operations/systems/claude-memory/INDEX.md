---
title: kol-claude-memory — the shared agent-memory system
type: index
status: active
updated: 2026-07-28
description: Design space for the Claude memory system — per-repo memory that lives in each repo's .kol/, a global tier in dotfiles, write-path symlinks that redirect the harness's writes into git, and the kol-glass vault as the cross-repo lookup lens. Designed + built 2026-07-28.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[../INDEX|docs root]]"
  - "[[01-memory-system|the memory system]]"
  - "[[03-kol-glass-vault|the vault lens]]"
---

# kol-claude-memory

Claude Code's memory is path-keyed runtime state — it lives outside every repo, orphans itself when a repo moves, and no session can see another repo's memory. This space designs the fix: **memory stored in each repo, synced by git, aggregated by one symlink vault**. Designed and built 2026-07-28 (build journal: `.kol/llm-context/playbook/2026-07-28-kol-claude-memory-build.md`); the vault repo was renamed `kol-symlink` → `kol-glass` at build time.

## Docs

| Doc | What it covers |
|---|---|
| [[01-memory-system\|01 — the memory system]] | The problem, the three moves (localise · share · look up), the master diagram, the tier split rule |
| [[02-repo-contract\|02 — dependencies & repo contract]] | What each repo must carry (`.kol/llm-memory/`), the global tier, the write-path symlinks, how the harness actually produces and recalls memory |
| [[03-kol-glass-vault\|03 — the kol-glass vault]] | The lens repo: current state and drift, the new `memory/` lens, the git verdict, the sync-script spec |
| [[04-sharing\|04 — sharing & portability]] | Making the system adoptable by other users — conventions over config, the hard dependency, privacy |

## Build order (v1) — executed 2026-07-28

1. Create `claude/memory/` in dotfiles; move the applies-everywhere `feedback_*` facts there from the current dotfiles memory dir; rebuild both `MEMORY.md` indexes.
2. Create `.kol/llm-memory/` in each participating repo (dotfiles first), seeded from that repo's existing `~/.claude/projects/<key>/memory/` contents where they exist.
3. Replace each `~/.claude/projects/<key>/memory` dir with a symlink to its repo's `.kol/llm-memory/` (home key → `claude/memory/`). Plain `mv` + `ln -sfn`; a small script under the vault repo does the scan-and-link.
4. In kol-glass: repair the 4 broken `repos/` links, add the missing repos, create the `memory/` lens dir with one link per participating repo plus `_global`.
5. User initialises kol-glass as a git repo (policy in [[03-kol-glass-vault|03]]) — tracked: INDEX, ignore rules, sync script; the links themselves stay untracked machinery.
