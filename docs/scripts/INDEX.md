---
title: Scripts
type: index
status: active
updated: 2026-06-26
description: The bin/ helper scripts, grouped by domain prefix (au-/vid-/img-/pdf-/art-/batch-/tor-/fs-/ss-/finder-/qa-/dl-/dot-/tg-/kol-/os-/theme-). One doc per family.
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
| `au-`  | [[01-audio|Audio]] | 4 | — |
| `vid-` | [[02-video|Video]] | 13 | — |
| `img-` | [[03-image|Image / 2D]] | 11 | PSD/video-frame→JPG/PNG, any image/PDF→JPG/PNG, fixed-aspect canvas (Quick Actions) |
| `pdf-` | [[04-pdf|PDF]] | 8 | — |
| `art-` | [[05-artwork|Artwork pipeline]] | 2 | — |
| `batch-` | [[06-batch-folder|Folder batch]] | 2 | — |
| `tor-` | [[07-torrent|Torrent]] | 2 | — |
| `fs-` / `ss-` | [[08-system|System & clipboard]] | 4 | — |
| `finder-` | [[09-finder|Finder selection]] | 1 | ⇧⌥⌃A, ⇧⌥⌃S (Quick Actions) |
| `qa-` | [[10-quick-actions|Quick Actions]] | 1 | generator — stamps new Quick Actions |
| `dl-` | [[12-download|Download]] | 1 | yt-dlp wrapper — highest-quality fetch (MKV default) |
| `dot-` | [[11-dot-sync|Dotfiles sync]] | 1 | launchd daemon — every 30 min |
| `bucket-` | [[14-bucket-drift|Drift]] · [[operations/05-cdn-r2b2/INDEX|Tree snapshots]] | 2 | read-only CDN tooling — `bucket-drift.sh` (drift check) + `bucket-tree.sh` (tree snapshot → dotfiles → Obsidian) |
| `tg-` | [[16-capture|Capture pipeline]] | 1 | **Telegram bot → Todoist / Obsidian / calendar** — one frictionless inbox, phone or desktop, hands-free via a launchd timer |
| `kol-` | [[17-kol-dashboard-cli|Dashboard CLI]] | 2 | terminal twins of the Obsidian kol-dashboard — kanban (`kol-kb`, prints+moves) + surfaces (`kol-dash` links/growth/pinned/tracks/week) |
| `os-` / `theme-` | [[18-appearance|Appearance & wake automation]] | 2 | ⇧⌥⌘T toggle theme, ⇧⌥⌘A run wake-alarm test (Raycast) |
| _(none)_ | [[15-calendar|Calendar]] | 1 | `cplan` — hides recurring noise over a date window ([[14-gcalcli|gcalcli]] companion) |
| _(none)_ | [[19-keys|Keybind reference]] | 1 | `keys <tag>` — bat-print your own keybinds by tag (tmux/nvim/aerospace/git/…) |

`cplan` is **non-prefixed** (callable as `cplan`, matching the `c*` gcalcli aliases)
rather than `cal-…`. The other non-prefixed script is `tor-search`, under
[[07-torrent|Torrent]].

Repo automation that isn't a `bin/` script: [[13-docs-mirror|docs → vault mirror]] —
a git post-commit hook + rsync that keep `~/.dotfiles/docs/` readable in the kol-vault
(and on the iPad). Sibling of [[11-dot-sync|dot-sync]].

Some scripts are also wired as **Finder Quick Actions** (`macos/services/`, symlinked by `bootstrap.sh`,
hotkeys in `macos/defaults.sh` §8): Open in glow, Open in mpv, Open in TextEdit (⇧⌥⌃E),
Select Every Other (⇧⌥⌃A / ⇧⌥⌃S), Shoot to _trash. New ones: one `qa-make.sh` line — see [[10-quick-actions|Quick Actions]].

## Conventions
- **Prefix = domain.** `vid-`, `img-`, `pdf-`, etc. **One doc per family**; a script needing depth gets a companion doc (e.g. [[ss-save|ss-save]]).
- **Every script answers `--help` / `-h`** (universal pass 2026-06-05) — a `usage()` block with purpose, args, examples, gotchas. Scripts that read positional args still take them; only `-h`/`--help` is intercepted.
- Redundant/superseded scripts are **moved out of the repo** to `~/_temp/` (machine-local holding area), not carried in `bin/`. (The old in-repo `bin/_bak/` quarantine was relocated to `~/_temp/bin_bak/` on 2026-06-05.)
- Flagship general tools: `vid-convert.sh` (any aspect/res video), `vid-archive.sh` (shrink-to-archive, 10-bit CRF), `art-process.sh` (artwork export pipeline).
