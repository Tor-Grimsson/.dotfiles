---
title: Git
type: index
status: active
updated: 2026-07-08
description: Git and its terminal tooling in one place — git itself, the GitHub CLI (gh), the lazygit TUI, and the parallel-agent worktree workflow.
tags:
  - domain/dev
related:
  - "[[documentation/INDEX|documentation]]"
  - "[[04-git-github|Git & GitHub cheat card]]"
---

# Git

Everything git — the tool, its GitHub layer, its TUI, and the worktree workflow. The daily-driver *printable* summary lives at [[04-git-github|the Git & GitHub cheat card]] (in kol-cli); these are the fuller per-tool references.

| # | Doc | What it covers |
|---|-----|----------------|
| 01 | [[01-git|git]] | The tool itself — everyday commands by task, branching, undo/reflog, stash, tags + semver + `npm version`, `.gitignore`, and the commands that lose work. |
| 02 | [[02-gh|gh (GitHub CLI)]] | GitHub from the terminal — PRs, issues, releases, CI runs, and the full GitHub API (`gh api`). |
| 03 | [[03-lazygit|lazygit]] | Keyboard-driven git TUI — stage hunks, commit, branch, rebase, stash, resolve conflicts; opens as a tmux popup on `prefix C-g`. |
| 04 | [[04-git-worktrees|Git worktrees]] | Run parallel coding agents on one repo without clashing — a worktree per agent, own branch + directory, with the install/port frictions and merge-back steps. |

## Related
- [[04-git-github|Git & GitHub cheat card]] — the one-page printable daily-driver version
- [[01-repo-model|Repo model]] — how *this* repo's own git works (skip-worktree, foreign-box drift) — machinery, under operations
