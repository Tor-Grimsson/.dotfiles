---
title: Git worktrees (parallel-agent workflow)
type: guide
status: active
updated: 2026-06-24
description: Run two (or more) coding agents on the same repo without clashing — one git worktree per agent, each on its own branch in its own directory, so they physically can't edit the same file.
aliases:
  - git worktrees
  - worktree
  - parallel agents
tags:
  - domain/dev
  - domain/ai/llm
covers:
  - Why two agents in one working tree clash (and why disjoint scope doesn't save you)
  - Setting up a worktree per agent
  - The two real frictions — per-worktree install + dev port
  - Merging the work back and cleaning up
  - The cheap alternative when a full worktree is overkill
related:
  - "[[05-pnpm|pnpm]]"
  - "[[12-gh|gh (GitHub CLI)]]"
  - "[[04-git-github|Git & GitHub card]]"
---

## The problem

Two agents pointed at the **same checkout** (e.g. both in `~/dev/projects/kol-apparat/kol-labs-single`) stomp each other. One agent's `Edit` lands on top of the other's; or both touch shared chrome — `sidebars.config.js`, `EditorRail`, `EditorFooter`, a shared `registry.js` — and you get a broken merge or a silent overwrite.

Disjoint scope ("you do math, you do loops") papers over it right up until both need the same shared file, then you're stuck again. The fix isn't better manners, it's separate working trees.

## The fix — one worktree per agent

A **worktree** is a second checkout of the *same* repo (same git history, same `.git`) living in a different directory on a different branch. Two agents in two worktrees cannot edit the same file because they're not in the same files.

Run once, from the main repo:

```sh
git worktree add ../kol-labs-agent-b -b agent-b
```

That creates `../kol-labs-agent-b/` checked out to a new branch `agent-b`. Agent B works entirely in there; Agent A keeps the main directory on `main`. Same history, separate files, zero clash.

List / remove worktrees:

```sh
git worktree list
git worktree remove ../kol-labs-agent-b      # after the branch is merged
```

## Two frictions to expect

1. **Each worktree needs its own `pnpm install`.** Fast — pnpm hardlinks from the shared global store — but it's a step. `node_modules` is per-directory, not shared.
2. **Each needs its own dev port.** This repo has no `strictPort`, so a second `pnpm dev` auto-bumps to `5174`. Pin it so an agent never murders the other's server:
   ```sh
   pnpm dev --port 5174
   ```

## Merging back

When `agent-b`'s work is done, fold it into `main` from the main worktree:

```sh
git merge agent-b           # or: git cherry-pick <sha>  for just some commits
git worktree remove ../kol-labs-agent-b
git branch -d agent-b
```

## Cheap alternative (when a full worktree is overkill)

For *occasional* overlap, skip the second worktree: keep the agents' scopes disjoint and **commit after every logical unit** so the other can rebase on top. It works — until both need shared chrome at the same time, which worktrees kill outright. If clashes are frequent, just use worktrees.

## Quick reference

| Action | Command |
| --- | --- |
| New agent worktree + branch | `git worktree add ../<dir> -b <branch>` |
| List worktrees | `git worktree list` |
| Per-worktree deps | `pnpm install` (in the new dir) |
| Pin dev port | `pnpm dev --port 5174` |
| Merge back | `git merge <branch>` (from main) |
| Remove worktree | `git worktree remove ../<dir>` |
