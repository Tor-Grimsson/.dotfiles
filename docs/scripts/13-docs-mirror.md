---
title: Docs → vault mirror
type: reference
status: active
updated: 2026-07-08
description: Mirror ~/.dotfiles/docs into the kol-vault so the iPad can read it — one rsync copy of real files, plus a post-commit hook that refreshes it on docs/ commits.
aliases:
  - docs-mirror
tags:
  - project/dotfiles
  - domain/scripts/sync
related:
  - "[[INDEX|Scripts index]]"
  - "[[11-dot-sync|Dotfiles sync]]"
  - "[[docs-mirror-rsync-explained|Mirroring docs by rsync, explained slowly]]"
---

# Docs → vault mirror

`~/.dotfiles/docs/` is the source of truth for the tooling catalog. The Obsidian
**kol-vault** wants to read it too, but copying it by hand goes stale. One mirror
lives under `kol-vault/kol-library/`:

| Mirror | Mechanism | In vault git? | Reaches |
|---|---|:--:|---|
| `kol-dotfiles-docs-rs/` | **rsync** of real files | tracked | iMac + MBP **+ iPad** |

> A second, symlink-based mirror (`-sm`) ran alongside this for a while and was
> **retired 2026-07-08** — git stores a symlink as the dangling *pointer*, not the
> bytes, so it never reached the iPad and only duplicated what `-rs` already does.

The mirror skips vault config and macOS cruft: `.obsidian/`, `.DS_Store`. The
**`kol-cli/`** cheat-card set is excluded here because it's promoted separately to a
vault-root estate (below).

## Why rsync (not a symlink)

The **iPad has no `.dotfiles` folder**, so it needs the real bytes, not a pointer into
a path that doesn't exist there. rsync copies actual markdown into a *tracked* vault
folder that rides the vault's `git push`, so the iPad gets it on pull. Plain-words
walkthrough: [[docs-mirror-rsync-explained|explained slowly]].

## The script (lives in the vault, not `bin/`)

It populates a vault folder, so it sits in the vault's plumbing, not `~/.dotfiles/bin`:

- `…/_kol-config/_files/_scripts/sync-dotfiles-docs-rs.sh` — `rsync -a --delete` of
  `docs/` → `kol-dotfiles-docs-rs/` (excludes `.DS_Store`, `.obsidian/`, `kol-cli/`),
  then a second `rsync` promotes `docs/kol-cli/` → the vault-root `kol-cli/` estate.
  One-way; **don't edit the mirror copies**, they're overwritten on the next run.

## The trigger (`git-hooks/post-commit`)

Tracked at `git-hooks/post-commit`, installed as `.git/hooks/post-commit` by
`bootstrap.sh`. After any commit that touches `docs/`, it runs the sync so the vault
copy is fresh for the next vault push. No-op when `docs/` wasn't touched, or on a
machine without the vault (guards on the script being present + executable).

```sh
git diff-tree --no-commit-id --name-only -r HEAD -- docs/ | grep -q . || exit 0
# ↑ only fire when this commit changed something under docs/
```

`.git/hooks/` is untracked runtime state — the hook body is the tracked artifact, so
`bootstrap.sh` re-symlinks it on every machine. This is automation you install, not
the agent running git (ARCHITECTURE §N is about the *agent*, not installed hooks).

## Install / refresh

- **MBP:** run `bootstrap.sh` once → the hook symlink is created.
- **Manual refresh** (no commit): `sync-dotfiles-docs-rs.sh`.
