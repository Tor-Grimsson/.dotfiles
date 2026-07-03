---
title: System & clipboard scripts
type: reference
status: active
updated: 2026-07-03
description: fs-* filesystem + ss-* clipboard helpers.
tags:
  - project/dotfiles
  - domain/scripts/system
---

# System & clipboard (`fs-` / `ss-`)

| Script | Does | Usage |
|--------|------|-------|
| `fs-rm-folder-smart.sh` | **Flatten** nested folders: move files out, delete emptied folders (clash-safe) | `fs-rm-folder-smart.sh [-w] [-d N] [-n]` — run `--help` |
| `fs-shoot.sh` | **Shoot** files/folders into a destination folder (created if missing, clash-safe) | `fs-shoot.sh [-n] <dest> <files…>` — run `--help` |
| `ss-save.sh` | Save clipboard image → file via `pngpaste` | `ss-save.sh [name] [dir]` — run `--help`; full path rules in [ss-save.md](ss-save.md) |
| `fs-reveal.sh` | Open Finder at PATH; `-f` = new **floating** window on the current AeroSpace workspace | `fs-reveal.sh [-f] [path]` — run `--help`; the `-f` bypass in [fs-reveal.md](fs-reveal.md) |

> `fs-rm-folder-smart.sh` renamed from `rm-fold-smart.sh` (fold → folder). Older `rm-folder*` variants were relocated to `~/_temp/bin_bak/` (out of the repo) on 2026-06-05.

### `fs-rm-folder-smart.sh` flags
Run it **inside** the folder you want flattened. `--help` documents all of it.

| Flag | Effect |
|---|---|
| (none) | Flatten fully; each file moves up one level, emptied folders removed |
| `-w`, `--working-dir` | Pull every file to the current dir (full collapse), not just up one level |
| `-d N`, `--depth N` | Only unpack folders up to N levels deep — `-d 1` = immediate subfolders only |
| `-n`, `--dry-run` | Print the MOVE/RMDIR actions, change nothing |

Clashes auto-resolve (`file.ext` → `file-bak1.ext`). Depth-first + rmdir-only, so it never deletes a folder
that still holds un-flattened deeper content (fixed a `rm -rf` data-loss bug present in the old version, 2026-06-05).

### `fs-shoot.sh`
Move anything into a destination folder — created if missing, never overwrites: clashes auto-resolve
(`file.ext` → `file-bak1.ext`, folders → `folder-bak1`). Skips missing sources and anything already in the
destination; refuses to move the destination into itself. `-n` previews. Workhorse behind the "Shoot to …"
Finder Quick Actions — see [Quick Actions](10-quick-actions.md) for stamping those out.

### `fs-reveal.sh`
`reveal` in the shell. Plain mode is macOS `open`; `-f` opens a **new floating** Finder window on the
**current** AeroSpace workspace, bypassing the blanket Finder→W rule per-window — it lets the rule fire,
then overrides that one window by its `window-id`. Full mechanism: [fs-reveal.md](fs-reveal.md).

Finder selection Quick Actions (`finder-select-alternate.sh`) moved to their own family doc: [Finder](09-finder.md).
