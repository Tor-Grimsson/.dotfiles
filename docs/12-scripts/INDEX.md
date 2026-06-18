---
title: Scripts
type: index
status: active
updated: 2026-06-17
description: The bin/ helper scripts, grouped by domain prefix (au-/vid-/img-/pdf-/art-/batch-/tor-/fs-/ss-/finder-/qa-). One doc per family.
tags:
  - project/dotfiles
  - domain/scripts
related:
  - "[[INDEX|tooling catalog]]"
---

# Scripts (`bin/`)

CLI helpers in `~/.dotfiles/bin` (symlinked to `~/bin`, on PATH). Renamed 2026-06-04 to a **domain-prefix** scheme so related scripts sort together.

| Prefix | Family | Count | Hotkeys / Quick Actions |
|--------|--------|:--:|---|
| `au-`  | [[01-audio\|Audio]] | 4 | — |
| `vid-` | [[02-video\|Video]] | 13 | — |
| `img-` | [[03-image\|Image / 2D]] | 10 | PSD→JPG/PNG, any image/PDF→JPG/PNG, fixed-aspect canvas (Quick Actions) |
| `pdf-` | [[04-pdf\|PDF]] | 7 | — |
| `art-` | [[05-artwork\|Artwork pipeline]] | 2 | — |
| `batch-` | [[06-batch-folder\|Folder batch]] | 2 | — |
| `tor-` | [[07-torrent\|Torrent]] | 2 | — |
| `fs-` / `ss-` | [[08-system\|System & clipboard]] | 3 | — |
| `finder-` | [[09-finder\|Finder selection]] | 1 | ⇧⌥⌃A, ⇧⌥⌃S (Quick Actions) |
| `qa-` | [[10-quick-actions\|Quick Actions]] | 1 | generator — stamps new Quick Actions |
| `dot-` | [[11-dot-sync\|Dotfiles sync]] | 1 | launchd daemon — every 30 min |

Some scripts are also wired as **Finder Quick Actions** (`macos/services/`, symlinked by `bootstrap.sh`,
hotkeys in `macos/defaults.sh` §8): Open in glow, Open in mpv, Open in TextEdit (⇧⌥⌃E),
Select Every Other (⇧⌥⌃A / ⇧⌥⌃S), Shoot to _trash. New ones: one `qa-make.sh` line — see [[10-quick-actions|Quick Actions]].

## Conventions
- **Prefix = domain.** `vid-`, `img-`, `pdf-`, etc. **One doc per family**; a script needing depth gets a companion doc (e.g. [[ss-save]]).
- **Every script answers `--help` / `-h`** (universal pass 2026-06-05) — a `usage()` block with purpose, args, examples, gotchas. Scripts that read positional args still take them; only `-h`/`--help` is intercepted.
- Redundant/superseded scripts are **moved out of the repo** to `~/_temp/` (machine-local holding area), not carried in `bin/`. (The old in-repo `bin/_bak/` quarantine was relocated to `~/_temp/bin_bak/` on 2026-06-05.)
- Flagship general tools: `vid-convert.sh` (any aspect/res video), `vid-archive.sh` (shrink-to-archive, 10-bit CRF), `art-process.sh` (artwork export pipeline).
