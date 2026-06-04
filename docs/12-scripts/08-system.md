---
title: System & clipboard scripts
type: reference
status: active
updated: 2026-06-04
description: fs-* filesystem + ss-* clipboard helpers.
tags:
  - project/dotfiles
  - domain/scripts/system
---

# System & clipboard (`fs-` / `ss-`)

| Script | Does | Usage |
|--------|------|-------|
| `fs-rm-folder-smart.sh` | Smart folder removal (guarded `find -exec` cleanup) | `fs-rm-folder-smart.sh` — read the in-script INSTRUCTIONS block first |
| `ss-save.sh` | Save clipboard image → file via `pngpaste` | `ss-save.sh [name] [dir]` — full path rules in [[ss-save\|ss-save.md]] |

> `fs-rm-folder-smart.sh` renamed from `rm-fold-smart.sh` (fold → folder). Older `rm-folder*` variants live in `bin/_bak/`.
