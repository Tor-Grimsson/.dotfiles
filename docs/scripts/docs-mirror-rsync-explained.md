---
title: Mirroring docs by rsync, explained slowly
type: guide
status: active
updated: 2026-07-08
description: Why the docs go into the vault by rsync, what rsync actually does here flag by flag, and why a symlink mirror couldn't do the job — in plain words.
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

`~/.dotfiles/docs/` is the catalog. The kol-vault wants to show it — including on the
iPad, which has no `.dotfiles` folder at all. That last part is the whole reason this
works the way it does.

## Why not just a symlink

A symlink is a signpost: a folder that doesn't *hold* the files, it points at
`~/.dotfiles/docs/documentation/04-dev-languages`. Edit the real folder, the signpost
shows the change instantly — zero copies, always current. Tempting.

The catch is **git**. When git commits a symlink it stores the *signpost text*, not
what it points at — a 40-byte file that says "go look at `/Users/biskup/.dotfiles/...`".
That path only exists on this Mac. On the iPad the signpost points at nothing. So a
symlink mirror is fine between the two Macs and useless past them — which is exactly
why the old `-sm` symlink mirror was retired: it never reached the device that needed
it most.

## The rsync way

rsync **copies the actual bytes** into `kol-dotfiles-docs-rs/`. Now the vault folder
holds real markdown — which git can commit, push, and the iPad can pull and read.
That's the whole point: it's the copy that survives leaving this machine.

What the command does, flag by flag:

```sh
rsync -a --delete \
  --exclude='.DS_Store' \
  --exclude='.obsidian/' \
  --exclude='kol-cli/' \
  "$HOME/.dotfiles/docs/" "…/kol-dotfiles-docs-rs/"
```

- `-a` — archive: recurse into subfolders, keep timestamps. The "copy a tree" default.
- `--delete` — make the destination *match* the source. Delete a doc upstream and the
  next sync deletes it in the vault too. Without this, removed files would linger.
- `--exclude` — skip macOS `.DS_Store`, the `.obsidian/` vault config (it's machine-local
  symlinks, not content), and `kol-cli/` (promoted separately to a vault-root estate).
- **trailing slash on the source** — `docs/` means "the *contents* of docs", not "a
  folder named docs". Drop the slash and you'd get `…-rs/docs/…`, nested one too deep.

**One-way.** Source of truth is `~/.dotfiles/docs/`. Don't edit the `-rs` copy — the
next sync overwrites it.

## Snapshot, so it needs a trigger

rsync gives you a *snapshot* — only as fresh as the last run. A snapshot is stale the
moment the source changes, so it can't be left to run by hand. A `post-commit` hook
([[13-docs-mirror|13-docs-mirror]]) runs the rsync whenever a commit touches `docs/`,
so the copy is fresh by the time you push the vault. Manual run any time:
`sync-dotfiles-docs-rs.sh`.
