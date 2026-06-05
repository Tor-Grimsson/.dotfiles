---
title: Quick Action generator
type: reference
status: active
updated: 2026-06-05
description: qa-make.sh — stamp a Finder Quick Action from a one-line shell command. The recipe behind Open in glow / Select Every Other, automated. Presets + worked examples.
tags:
  - project/dotfiles
  - domain/scripts/quick-actions
related:
  - "[[08-system|System & clipboard]]"
  - "[[09-finder|Finder selection]]"
---

# Quick Actions (`qa-`)

| Script | Does | Usage |
|--------|------|-------|
| `qa-make.sh` | Generate a Finder Quick Action that runs a shell command on the selection | `qa-make.sh [-t types] [-f] "<Name>" '<command>'` — run `--help` |

The recipe behind *Open in glow* / *Select Every Other*, automated. One terminal line →
a tracked `.workflow` in `macos/services/` + symlink in `~/Library/Services` → the action
appears under Finder right-click → **Quick Actions** / **Services**. No Automator clicking.

## How it works

- A Quick Action bundle is just two plists: `Info.plist` (service registration — Finder
  context, accepted file types) and `document.wflow` (one *Run Shell Script* action).
  `qa-make.sh` stamps both from the same template the hand-made actions use,
  `plutil -lint`s them, symlinks, and `pbs -flush`es the Services registry.
- Selected files/folders arrive as `"$@"` in `/bin/bash`. **Single-quote the command**
  so `$HOME` and `"$@"` survive until run time.
- `-t public.image` (comma-separable UTIs) restricts which selections offer the action.
  Default `public.item` = any file or folder.
- Bundles land in the repo → sync to the other machine; `bootstrap.sh` links every
  `*.workflow` in `macos/services/` (glob loop, 2026-06-05 — no per-file lines needed).

## Installed presets

| Quick Action | Command | Hotkey |
|---|---|---|
| Shoot to _trash | each selected item → a `_trash/` folder **next to it** (`fs-shoot.sh`) | — |

*Shoot to _trash* is the fake-trash: culling a folder shoots rejects into a local
`_trash/` you can review and delete later — the real Trash stays out of it.

## Making your own

```sh
# fixed destination: collect into one global staging folder
qa-make.sh "Shoot to Staging" '"$HOME/bin/fs-shoot.sh" "$HOME/_staging" "$@"'

# per-file destination: a folder next to each selected item
qa-make.sh "Shoot to _keep" 'for f in "$@"; do "$HOME/bin/fs-shoot.sh" "$(dirname "$f")/_keep" "$f"; done'

# images only, through the web-export pipeline
qa-make.sh -t public.image "Web export" '"$HOME/bin/img-web.sh" "$@"'
```

Moves go through [[08-system|fs-shoot.sh]] — clash-safe, creates the destination,
never overwrites.

## Hotkeys

Optional. System Settings → Keyboard → Keyboard Shortcuts → Services → General, or —
to make it bootstrap-able — add a `defaults write pbs NSServicesStatus` line to
`macos/defaults.sh` §Services. `qa-make.sh` prints the exact line on creation.

## Removing

Delete `macos/services/<Name>.workflow` and the `~/Library/Services/<Name>.workflow`
symlink, then `/System/Library/CoreServices/pbs -flush`.
