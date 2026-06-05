---
title: System & clipboard scripts
type: reference
status: active
updated: 2026-06-05
description: fs-* filesystem + ss-* clipboard helpers.
tags:
  - project/dotfiles
  - domain/scripts/system
---

# System & clipboard (`fs-` / `ss-`)

| Script | Does | Usage |
|--------|------|-------|
| `fs-rm-folder-smart.sh` | **Flatten** nested folders: move files out, delete emptied folders (clash-safe) | `fs-rm-folder-smart.sh [-w] [-d N] [-n]` — run `--help` |
| `ss-save.sh` | Save clipboard image → file via `pngpaste` | `ss-save.sh [name] [dir]` — run `--help`; full path rules in [[ss-save\|ss-save.md]] |

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

Finder selection Quick Actions (`finder-select-alternate.sh`) moved to their own family doc: [[09-finder|Finder]].
