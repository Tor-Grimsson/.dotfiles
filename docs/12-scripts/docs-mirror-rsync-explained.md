---
title: Mirroring docs by rsync, explained slowly
type: guide
status: active
updated: 2026-06-25
description: Why the docs go into the vault by rsync, what rsync actually does here, and how it differs from the symlink mirror — in plain words.
aliases:
  - docs-mirror-rsync-explained
audience: internal
tags:
  - project/dotfiles
  - domain/scripts/sync
related:
  - "[[13-docs-mirror|Docs → vault mirror]]"
---

# Mirroring docs by rsync, explained slowly

`~/.dotfiles/docs/` is the catalog. The kol-vault wants to show it. There are two
ways to put it there, and they fail in different places — so we run both and compare.

## The symlink way (`-sm`)

A symlink is a signpost: `kol-dotfiles-docs-sm/04-dev-languages` doesn't *hold* the
files, it points at `~/.dotfiles/docs/04-dev-languages`. Edit the real folder, the
signpost shows the change instantly. Zero copies, always current.

The catch is **git**. When git commits a symlink it stores the *signpost text*, not
what it points at — a 40-byte file that says "go look at `/Users/biskup/.dotfiles/...`".
That path only exists on this Mac. On the iPad (no `.dotfiles` folder) the signpost
points at nothing. So `-sm` is great between the two Macs and useless past them. It
stays **gitignored** for that reason.

## The rsync way (`-rs`)

rsync **copies the actual bytes** into `kol-dotfiles-docs-rs/`. Now the vault folder
holds real markdown — which git can commit, push, and the iPad can pull and read.
That's the whole reason rsync exists in this setup: it's the only one of the two that
survives leaving this machine.

What the command does, flag by flag:

```sh
rsync -a --delete \
  --exclude='llm-context/' --exclude='history.md' \
  --exclude='plan.md' --exclude='.DS_Store' \
  "$HOME/.dotfiles/docs/" "…/kol-dotfiles-docs-rs/"
```

- `-a` — archive: recurse into subfolders, keep timestamps. The "copy a tree" default.
- `--delete` — make the destination *match* the source. Delete a doc upstream and the
  next sync deletes it in the vault too. Without this, removed files would linger.
- `--exclude` — skip the repo's agent-state (`llm-context/`, `history.md`, `plan.md`)
  and macOS `.DS_Store`. Same denylist the symlink script uses.
- **trailing slash on the source** — `docs/` means "the *contents* of docs", not "a
  folder named docs". Drop the slash and you'd get `…-rs/docs/…`, nested one too deep.

**One-way.** Source of truth is `~/.dotfiles/docs/`. Don't edit the `-rs` copy — the
next sync overwrites it. (The symlink copy is the opposite: editing it edits the real
file, because it *is* the real file.)

## Live vs. snapshot

| | symlink (`-sm`) | rsync (`-rs`) |
|---|---|---|
| Freshness | live, instant | a snapshot — only as fresh as the last run |
| Cost | zero copy | a real second copy on disk |
| Edit direction | two-way (it's the file) | one-way (overwritten) |
| Leaves this Mac? | no (dangling pointers) | **yes** — real bytes in git |

A snapshot is stale the moment the source changes, which is why `-rs` needs a trigger.

## What runs the sync

You never have to remember. A `post-commit` hook ([[13-docs-mirror]]) runs the rsync
whenever a commit touches `docs/`, so the `-rs` copy is fresh by the time you push the
vault. Manual run any time: `sync-dotfiles-docs-rs.sh`.
