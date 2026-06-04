---
title: Tooling catalog
type: index
status: active
updated: 2026-06-04
description: One reference doc per installed tool (54 tools, 11 categories), each with verified links and a why/use/win/how/future write-up. Routes to every category.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[TOOLING|tooling audit & sync]]"
---

# Tooling catalog

One `reference` doc per tool in this setup — **52 tools across 11 categories**. Each doc carries verified links (website / repo / manual / brew) in frontmatter and a body covering *what it is, why it's installed, the common use case, the biggest win, how to use it, and future use*.

Folders group by **function**. Two cross-cutting axes live in **tags**, not folders, so you can slice either way:
- **Interface** — `pattern/cli` · `pattern/tui` · `pattern/gui` · `pattern/library`
- **Install method** — `integration/brew-formula` · `integration/brew-cask` · `integration/mac-app-store`
- **Vendor** (where clear) — `provider/<vendor>`

## Categories

| # | Category | Tools | What lives here |
|---|----------|:-----:|-----------------|
| 01 | [[01-shell-terminal/INDEX\|Shell & Terminal]] | 6 | terminal emulator, multiplexers, prompt, zsh plugins, sysinfo |
| 02 | [[02-file-management/INDEX\|File Management]] | 6 | tree view, TUI managers, GUI managers, renamers, QuickLook, archiver |
| 03 | [[03-dedup-cleanup/INDEX\|Dedup & Cleanup]] | 6 | duplicate finders, app uninstallers, file recovery |
| 04 | [[04-dev-languages/INDEX\|Dev & Languages]] | 8 | editors, JS/Python runtimes & managers, jq, containers |
| 05 | [[05-network-security/INDEX\|Network & Security]] | 7 | scanners, throughput, antivirus, password vault, SSH |
| 06 | [[06-media-av/INDEX\|Media & A/V]] | 5 | player, transcoders, torrents, speech-to-text |
| 07 | [[07-pdf-images/INDEX\|PDF & Images]] | 4 | image toolkit, PDF↔image/SVG, clipboard PNG |
| 08 | [[08-screen-capture/INDEX\|Screen Capture]] | 3 | screen recorders, keystroke overlay |
| 09 | [[09-productivity-desktop/INDEX\|Productivity & Desktop]] | 4 | launcher, system monitor, notes, dev browser |
| 10 | [[10-fonts/INDEX\|Fonts]] | 2 | Nerd Font, font viewer |
| 11 | [[11-cloud-sync/INDEX\|Cloud & Sync]] | 1 | rclone |
| 12 | [[12-scripts/INDEX\|Scripts]] | 33 | `bin/` helpers: au/vid/img/pdf/art/batch/tor/fs |

## Related
- [[TOOLING|Tooling audit & sync]] — the drift audit, Brewfile reconciliation, cross-arch portability notes, and open items.

## Maintenance
- Source of truth for *what's installed* is the repo `Brewfile`. When a tool is added/removed there, add/remove its doc here.
- Removed 2026-06-04: **tmate** and **qlstephen** (brew was disabling both; uninstall locally with `brew uninstall tmate` and `brew uninstall --cask qlstephen`).
