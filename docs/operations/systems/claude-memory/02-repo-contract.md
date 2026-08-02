---
title: Dependencies & the repo contract
type: reference
status: active
updated: 2026-07-28
description: What makes the memory system work — the .kol/llm-memory contract each repo carries, the global tier in dotfiles claude/memory, the write-path symlinks in ~/.claude/projects, and the harness mechanics (how memory is actually produced, keyed, and recalled). Plus the failure modes.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-claude-memory]]"
  - "[[01-memory-system|the memory system]]"
  - "[[03-kol-glass-vault|the vault lens]]"
---

# Dependencies & the repo contract

## What each piece is and needs

| Piece | Lives at | Does | Needs |
|---|---|---|---|
| **Repo tier** | `<repo>/.kol/llm-memory/` | Holds that repo's facts: `MEMORY.md` index + one `*.md` per fact | The repo tracks it in git (that *is* the sync) |
| **Global tier** | `~/.dotfiles/claude/memory/` | Cross-repo facts; sits beside the other repo-backed `~/.claude` config | dotfiles (already the global-config repo) |
| **Write-path links** | `~/.claude/projects/<key>/memory` → the tier dirs | Redirect the harness's normal writes into the repos | Recreated per machine by the sync script; the home key (`-Users-biskup`) points at the global tier |
| **Lookup lens** | `kol-glass/memory/` | One flat dir over all tiers for grep/Obsidian | The vault repo — see [[03-kol-glass-vault\|03]] |

## How the harness produces memory (stock mechanics)

| Mechanic | Fact |
|---|---|
| **Keying** | The project dir is the absolute launch path with `/` flattened to `-`: launching in `~/.dotfiles` uses `~/.claude/projects/-Users-biskup--dotfiles/` |
| **Writing** | The agent itself writes memory mid-session with ordinary file tools — one markdown file per fact with `name`/`description`/`type` frontmatter (`user · feedback · project · reference`), then a one-line pointer in `MEMORY.md` |
| **Recall** | Only `MEMORY.md` is injected at session start; individual fact files are read when their description looks relevant |
| **Scope** | Per launch dir, nothing global, nothing cross-repo — this is the gap the system closes |

A symlink is invisible to all of this: the harness resolves the path and writes through it. That's the entire trick — no hook, no wrapper, no fork.

## Distribution of the global tier

Storage alone doesn't make global facts *apply* everywhere. They ride the two global channels dotfiles already runs:

| Channel | Role |
|---|---|
| `claude/CLAUDE.md` | Standing rules, hand-curated — the always-loaded layer |
| `claude/hooks/agent-reinforce.sh` | Cadence re-injection mid-session |
| `kol-glass/memory/_global` | On-demand lookup from any session |
| Repo `MEMORY.md` pointer line | Every repo tier's index opens with `> Global tier: ~/.dotfiles/claude/memory/MEMORY.md — read it too`, so any repo session learns the global tier exists at auto-load |

## Failure modes

| Failure | Symptom | Fix |
|---|---|---|
| Repo moved/renamed | New path key gets a fresh plain `memory/` dir; repo's `.kol/llm-memory/` untouched | Re-run the sync script — it replaces the fresh dir with a link (one relink, history intact) |
| New machine | No links exist | Same script, same run |
| Harness writes before the link exists | Plain dir with a few facts at the stale key | Script detects a real dir where a link should be, merges files into the repo tier, then links |
| Repo lacks `.kol/llm-memory/` | Nothing to link | Repo joins the system by gaining the dir — that's the whole membership test |
