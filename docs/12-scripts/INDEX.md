---
title: Scripts
type: index
status: active
updated: 2026-06-04
description: The bin/ helper scripts, grouped by domain prefix (au-/vid-/img-/pdf-/art-/batch-/tor-/fs-/ss-). One doc per family.
tags:
  - project/dotfiles
  - domain/scripts
related:
  - "[[INDEX|tooling catalog]]"
---

# Scripts (`bin/`)

CLI helpers in `~/.dotfiles/bin` (symlinked to `~/bin`, on PATH). Renamed 2026-06-04 to a **domain-prefix** scheme so related scripts sort together.

| Prefix | Family | Count |
|--------|--------|:--:|
| `au-`  | [[01-audio\|Audio]] | 1 |
| `vid-` | [[02-video\|Video]] | 10 |
| `img-` | [[03-image\|Image / 2D]] | 7 |
| `pdf-` | [[04-pdf\|PDF]] | 7 |
| `art-` | [[05-artwork\|Artwork pipeline]] | 2 |
| `batch-` | [[06-batch-folder\|Folder batch]] | 2 |
| `tor-` | [[07-torrent\|Torrent]] | 2 |
| `fs-` / `ss-` | [[08-system\|System & clipboard]] | 2 |

## Conventions
- **Prefix = domain.** `vid-`, `img-`, `pdf-`, etc.
- Redundant/superseded scripts are **quarantined** in `bin/_bak/`, never deleted.
- Flagship general tools: `vid-convert.sh` (any aspect/res video), `art-process.sh` (artwork export pipeline).
