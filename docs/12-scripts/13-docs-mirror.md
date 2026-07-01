---
title: Docs → vault mirror
type: reference
status: active
updated: 2026-06-25
description: Mirror ~/.dotfiles/docs into the kol-vault so the iPad can read it. Two parallel mirrors (symlink + rsync) + a post-commit hook that refreshes the rsync copy on docs/ commits.
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
**kol-vault** wants to read it too, but copying it by hand goes stale. Two mirrors
live under `kol-vault/kol-library/`, kept side-by-side for evaluation:

| Mirror | Mechanism | In vault git? | Reaches |
|---|---|:--:|---|
| `kol-dotfiles-docs-sm/` | per-child **symlinks** | ignored | iMac + MBP only |
| `kol-dotfiles-docs-rs/` | **rsync** of real files | tracked | iMac + MBP **+ iPad** |

Both skip the repo's agent-state: `llm-context/`, `history.md`, `plan.md`, `.DS_Store`.

## Why two

A symlink is zero-copy and live (edit in `.dotfiles`, see it in Obsidian on reload)
— but git stores a symlink as the *link*, not its target, so off this Mac those
pointers are dangling. The **iPad has no `.dotfiles` folder**, so it needs the real
bytes. rsync writes those into a tracked folder that rides the vault's `git push`.

## The scripts (live in the vault, not `bin/`)

These populate vault folders, so they sit in the vault's plumbing, not `~/.dotfiles/bin`:

- `…/_kol-config/_files/_scripts/relink-dotfiles-docs-sm.sh` — rebuilds the `-sm`
  symlinks. Denylist, not allowlist: a new top-level `NN-*` upstream is linked
  automatically; the agent files never are. Re-run after the docs tree grows a folder.
- `…/_kol-config/_files/_scripts/sync-dotfiles-docs-rs.sh` — `rsync -a --delete`
  with the same excludes. One-way; **don't edit the `-rs` copy**, it's overwritten.

## The trigger (`git-hooks/post-commit`)

Tracked at `git-hooks/post-commit`, installed as `.git/hooks/post-commit` by
`bootstrap.sh`. After any commit that touches `docs/`, it runs the `-rs` sync so the
vault copy is fresh for the next vault push. No-op when `docs/` wasn't touched, or on
a machine without the vault (guards on the script being present + executable).

```sh
git diff-tree --no-commit-id --name-only -r HEAD -- docs/ | grep -q . || exit 0
# ↑ only fire when this commit changed something under docs/
```

`.git/hooks/` is untracked runtime state — the hook body is the tracked artifact, so
`bootstrap.sh` re-symlinks it on every machine. This is automation you install, not
the agent running git (ARCHITECTURE §N is about the *agent*, not installed hooks).

## Install / refresh

- **MBP:** run `bootstrap.sh` once → the hook symlink is created.
- **Manual `-rs` refresh** (no commit): `sync-dotfiles-docs-rs.sh`.
- **`-sm` after a new upstream folder:** `relink-dotfiles-docs-sm.sh`.
