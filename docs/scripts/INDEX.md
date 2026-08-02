---
title: Scripts
type: index
status: active
updated: 2026-07-15
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
| `fs-` / `ss-` / `clip-` | [[08-system|System & clipboard]] | 5 | — |
| `finder-` | [[09-finder|Finder selection]] | 1 | ⇧⌥⌃A, ⇧⌥⌃S (Quick Actions) |
| `qa-` | [[10-quick-actions|Quick Actions]] | 1 | generator — stamps new Quick Actions |
| `dl-` | [[12-download|Download]] | 1 | yt-dlp wrapper — highest-quality fetch (MKV default) |
| `dot-` | [[11-dot-sync|Dotfiles sync]] | 1 | launchd daemon — every 30 min |
| `bucket-` | [[14-bucket-drift|Drift]] · [[operations/systems/cdn/INDEX|Tree snapshots]] | 2 | read-only CDN tooling — `bucket-drift.sh` (drift check) + `bucket-tree.sh` (tree snapshot → dotfiles → Obsidian) |
| `tg-` | [[16-capture|Capture pipeline]] | 1 | **Telegram bot → Todoist / Obsidian / calendar** — one frictionless inbox, phone or desktop, hands-free via a launchd timer |
| `kol-` | [[17-kol-dashboard-cli|Dashboard CLI]] | 2 | terminal twins of the Obsidian kol-dashboard — kanban (`kol-kb`, prints+moves) + surfaces (`kol-dash` links/growth/pinned/tracks/week) |
| `os-` / `theme-` | [[18-appearance|Appearance & wake automation]] | 2 | ⇧⌥⌘T toggle theme, ⇧⌥⌘A run wake-alarm test (Raycast) |
| _(none)_ | [[15-calendar|Calendar]] | 1 | `cplan` — hides recurring noise over a date window ([[14-gcalcli|gcalcli]] companion) |
| _(none)_ | [[20-files|Folder navigation]] | 1 | `files <word>` — glow-rendered folder tables by section word; `to <word>` jumps in (fzf when several) |
| _(none)_ | [[21-help-lint|--help lint]] | 1 | `help-lint` — flag any `bin/` script missing the `--help` convention (static, skips binaries; the kol-appliant enforcement arm) |
| _(none)_ | [[scripts/ref-system/INDEX|Reference cards]] | 1 | `ref [card] <word>` / `ref-<card>` — the reference-card system: tmux · nvim · git · explorer · grep · media · desk · terminal · shell · system · files; one engine, per-card renderer — own folder: [[scripts/ref-system/INDEX|ref-system]] |
| _(none)_ | [[operations/systems/repo-map/INDEX|repo map]] | 1 | `repo-map.sh` — walk ~/dev/projects read-only: live estate, drift vs the hand-kept map, `--card` regenerates `ref-repo` |
| _(none)_ | [[nvim-port|nvim-port]] | 1 | `nvim-port [path]` — open a path (or clipboard) as a new tab in the tmux session's running nvim via its socket; pairs with the zshrc `nvim()` wrapper + statusline badge |
| _(none)_ | [[aero-add\|aero-add]] | 1 | `aero-add` — state view over `aerospace.toml`'s window rules: every running app with its current rule + TOML preview, Enter to add/change/remove, reload, and move already-open windows (`prefix Ctrl+W` popup; `--list` / `--show` read-only) |
| _(none)_ | [[llm-pick\|llm-pick]] | 1 | `llm-pick` — fzf menu over the `llm` CLI in a popup: ask · continue · chat · pipe the clipboard · one-off model (`prefix Ctrl+L`) |
| _(none)_ | [[lobby\|lobby]] | 1 | `lobby` — sweep every registered lobby queue: `--counts`, `--paths`, or an fzf pick-and-read across all four (`prefix Ctrl+K`); read-only |
| _(none)_ | ubersicht-screen | 1 | `ubersicht-screen [main\|all]` — which screen Übersicht widgets draw on; `main` keeps them in step with the per-monitor aerospace gutter |
| _(none)_ | agent-drop | 1 | `agent-drop` — headless triage of `~/_inbox/agent/`: one `claude -p` run per dropped file, `.result.md` written beside it, input moved to `done/`. Creates only; edits nothing. Spec: [[operations/systems/headless-agents/INDEX\|headless-agents]] |

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
