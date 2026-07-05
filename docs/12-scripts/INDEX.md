---
title: Scripts
type: index
status: active
updated: 2026-06-26
description: The bin/ helper scripts, grouped by domain prefix (au-/vid-/img-/pdf-/art-/batch-/tor-/fs-/ss-/finder-/qa-/dl-/dot-/tg-/kol-). One doc per family.
tags:
  - project/dotfiles
  - domain/scripts
related:
  - "[[INDEX|tooling catalog]]"
  - "[[03-scripts|Scripts at a glance (grouped)]]"
---

# Scripts (`bin/`)

CLI helpers in `~/.dotfiles/bin` (symlinked to `~/bin`, on PATH). Renamed 2026-06-04 to a **domain-prefix** scheme so related scripts sort together.

| Prefix | Family | Count | Hotkeys / Quick Actions |
|--------|--------|:--:|---|
| `au-`  | [Audio](01-audio.md) | 4 | — |
| `vid-` | [Video](02-video.md) | 13 | — |
| `img-` | [Image / 2D](03-image.md) | 11 | PSD/video-frame→JPG/PNG, any image/PDF→JPG/PNG, fixed-aspect canvas (Quick Actions) |
| `pdf-` | [PDF](04-pdf.md) | 8 | — |
| `art-` | [Artwork pipeline](05-artwork.md) | 2 | — |
| `batch-` | [Folder batch](06-batch-folder.md) | 2 | — |
| `tor-` | [Torrent](07-torrent.md) | 2 | — |
| `fs-` / `ss-` | [System & clipboard](08-system.md) | 4 | — |
| `finder-` | [Finder selection](09-finder.md) | 1 | ⇧⌥⌃A, ⇧⌥⌃S (Quick Actions) |
| `qa-` | [Quick Actions](10-quick-actions.md) | 1 | generator — stamps new Quick Actions |
| `dl-` | [Download](12-download.md) | 1 | yt-dlp wrapper — highest-quality fetch (MKV default) |
| `dot-` | [Dotfiles sync](11-dot-sync.md) | 1 | launchd daemon — every 30 min |
| `bucket-` | [Drift](14-bucket-drift.md) · [Tree snapshots](../18-cdn-r2b2/INDEX.md) | 2 | read-only CDN tooling — `bucket-drift.sh` (drift check) + `bucket-tree.sh` (tree snapshot → dotfiles → Obsidian) |
| `tg-` | [Capture pipeline](16-capture.md) | 1 | **Telegram bot → Todoist / Obsidian / calendar** — one frictionless inbox, phone or desktop, hands-free via a launchd timer |
| `kol-` | [Dashboard CLI](17-kol-dashboard-cli.md) | 2 | terminal twins of the Obsidian kol-dashboard — kanban (`kol-kb`, prints+moves) + surfaces (`kol-dash` links/growth/pinned/tracks/week) |
| _(none)_ | [Calendar](15-calendar.md) | 1 | `cplan` — hides recurring noise over a date window ([gcalcli](../01-shell-terminal/14-gcalcli.md) companion) |

`cplan` is **non-prefixed** (callable as `cplan`, matching the `c*` gcalcli aliases)
rather than `cal-…`. The other non-prefixed script is `tor-search`, under
[Torrent](07-torrent.md).

Repo automation that isn't a `bin/` script: [docs → vault mirror](13-docs-mirror.md) —
a git post-commit hook + rsync that keep `~/.dotfiles/docs/` readable in the kol-vault
(and on the iPad). Sibling of [dot-sync](11-dot-sync.md).

Some scripts are also wired as **Finder Quick Actions** (`macos/services/`, symlinked by `bootstrap.sh`,
hotkeys in `macos/defaults.sh` §8): Open in glow, Open in mpv, Open in TextEdit (⇧⌥⌃E),
Select Every Other (⇧⌥⌃A / ⇧⌥⌃S), Shoot to _trash. New ones: one `qa-make.sh` line — see [Quick Actions](10-quick-actions.md).

## Conventions
- **Prefix = domain.** `vid-`, `img-`, `pdf-`, etc. **One doc per family**; a script needing depth gets a companion doc (e.g. [ss-save](ss-save.md)).
- **Every script answers `--help` / `-h`** (universal pass 2026-06-05) — a `usage()` block with purpose, args, examples, gotchas. Scripts that read positional args still take them; only `-h`/`--help` is intercepted.
- Redundant/superseded scripts are **moved out of the repo** to `~/_temp/` (machine-local holding area), not carried in `bin/`. (The old in-repo `bin/_bak/` quarantine was relocated to `~/_temp/bin_bak/` on 2026-06-05.)
- Flagship general tools: `vid-convert.sh` (any aspect/res video), `vid-archive.sh` (shrink-to-archive, 10-bit CRF), `art-process.sh` (artwork export pipeline).
