---
title: Dotfiles sync
type: reference
status: active
updated: 2026-06-05
description: dot-sync.sh — two-machine repo sync, manual ritual + launchd daemon. Transport only, never authorship — pulls/pushes existing commits, never commits.
tags:
  - project/dotfiles
  - domain/scripts/sync
related:
  - "[[INDEX|Scripts index]]"
  - "[[dot-sync-explained|dot-sync, explained slowly]]"
---

# Dotfiles sync (`dot-`)

| Script | Does | Usage |
|--------|------|-------|
| `dot-sync.sh` | Sync `~/.dotfiles` with origin, both directions, no auto-commits | `dot-sync.sh [--auto]` — run `--help` |

The two-machine ritual (stash `-u` → pull --rebase → pop, per the 2026-06-05
sync session log) as one command, plus a launchd daemon that keeps committed
work flowing between the iMac and MBP on its own.

## Design: transport, never authorship

The daemon moves **existing commits only**. It never commits — your edits
propagate when *you* commit; the machines stop drifting on the pushed/pulled
half of the loop. This keeps the "user owns all git" contract intact: launchd
runs as you, and every commit is authored by you.

## Manual mode (`dot-sync.sh`)

fetch → stash `-u` (only if dirty *and* behind) → `pull --rebase` → stash pop →
push-if-ahead. Failure paths are restorative, never destructive:

- rebase conflicts → `rebase --abort`, stash popped back, tree as you left it
- stash-pop conflicts → stops with instructions (fix markers, `git stash drop`)

## Daemon mode (`--auto`)

`com.kolkrabbi.dot-sync` (in `macos/launchd/`, installed by `bootstrap.sh`)
runs every 30 min + at login:

| Tree state | Action |
|---|---|
| clean, behind | `pull --rebase`; conflicts → abort + notify |
| clean, ahead | `push` (committed-but-unpushed work) |
| dirty | **hands off** — one notification per new remote state, deduped via `~/.cache/dot-sync-notified` |
| offline / mid-rebase | silent no-op / notify + bail |

A dirty tree is never touched on purpose: a half-rebased repo symlinked into a
live home dir is worse than being 30 min stale.

Log: `~/Library/Logs/dot-sync.log`. Notifications via `osascript`.

## Auth

Origin is SSH; headless push needs the key without a prompt. `ssh/config` has a
`Host github.com` block (`AddKeysToAgent` + `UseKeychain`) so the agent loads
the key from the keychain on demand. One-time per machine if the key has a
passphrase not yet stored: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`.

## Install / remove

Installed by the `bootstrap.sh` launchd block (cp + `launchctl bootstrap` — the
plist is **copied**, not symlinked; launchd is unreliable with symlinked plists).
Manual load/unload:

```sh
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.kolkrabbi.dot-sync.plist
launchctl bootout   "gui/$(id -u)/com.kolkrabbi.dot-sync"
launchctl kickstart "gui/$(id -u)/com.kolkrabbi.dot-sync"   # run a cycle now
```

The plist is username-agnostic (`zsh -lc` expands `$HOME`) — same file works on
both machines despite the kolkrabbi/biskup split.
