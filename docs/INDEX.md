---
title: Tooling catalog
type: index
status: active
updated: 2026-06-09
description: One reference doc per installed tool (64 tools, 13 categories), each with verified links and a why/use/win/how/future write-up. Routes to every category.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[TOOLING|tooling audit & sync]]"
---

# Tooling catalog

One `reference` doc per tool in this setup — **64 tools across 13 categories**. Each doc carries verified links (website / repo / manual / brew) in frontmatter and a body covering *what it is, why it's installed, the common use case, the biggest win, how to use it, and future use*.

Folders group by **function**. Two cross-cutting axes live in **tags**, not folders, so you can slice either way:
- **Interface** — `pattern/cli` · `pattern/tui` · `pattern/gui` · `pattern/library`
- **Install method** — `integration/brew-formula` · `integration/brew-cask` · `integration/mac-app-store`
- **Vendor** (where clear) — `provider/<vendor>`

## Categories

| # | Category | Tools | What lives here |
|---|----------|:-----:|-----------------|
| 01 | [[01-shell-terminal/INDEX\|Shell & Terminal]] | 8 | terminal emulator, multiplexers, prompt, zsh plugins, clipboard, sysinfo |
| 02 | [[02-file-management/INDEX\|File Management]] | 11 | tree view, TUI/GUI managers, renamers, archiver + modern CLI core (eza/bat/fd/rg/fzf) |
| 03 | [[03-dedup-cleanup/INDEX\|Dedup & Cleanup]] | 6 | duplicate finders, app uninstallers, file recovery |
| 04 | [[04-dev-languages/INDEX\|Dev & Languages]] | 9 | editors, JS/Python runtimes & managers, jq, containers, LLM client |
| 05 | [[05-network-security/INDEX\|Network & Security]] | 8 | scanners, throughput, antivirus, password vault, SSH |
| 06 | [[06-media-av/INDEX\|Media & A/V]] | 6 | player, transcoders, torrents, speech-to-text, text-to-speech |
| 07 | [[07-pdf-images/INDEX\|PDF & Images]] | 4 | image toolkit, PDF↔image/SVG, clipboard PNG |
| 08 | [[08-screen-capture/INDEX\|Screen Capture]] | 3 | screen recorders, keystroke overlay |
| 09 | [[09-productivity-desktop/INDEX\|Productivity & Desktop]] | 4 | launcher, system monitor, notes, dev browser |
| 10 | [[10-fonts/INDEX\|Fonts]] | 2 | Nerd Font, font viewer |
| 11 | [[11-cloud-sync/INDEX\|Cloud & Sync]] | 1 | rclone |
| 12 | [[12-scripts/INDEX\|Scripts]] | 33 | `bin/` helpers: au/vid/img/pdf/art/batch/tor/fs |
| 13 | [[13-terminal-browsers/INDEX\|Terminal Browsers]] | 2 | Carbonyl (full Chromium via Docker), w3m (text-mode) |

## Related
- [[TOOLING|Tooling audit & sync]] — the drift audit, Brewfile reconciliation, cross-arch portability notes, and open items.

## Maintenance
- Source of truth for *what's installed* is the repo `Brewfile`. When a tool is added/removed there, add/remove its doc here.
- The catalog intentionally runs ahead of the `Brewfile`: `[[01-shell-terminal/06-pbcopy-pbpaste|pbcopy & pbpaste]]` is a macOS **built-in**, and a few CLIs (`[[06-media-av/06-edge-tts|edge-tts]]` via pipx, `[[04-dev-languages/09-llm|llm]]` via uv) are **not** Brewfile lines. Don't "fix" the 64 count against the Brewfile — those mismatches are expected.
- Removed 2026-06-04: **tmate** and **qlstephen** (brew was disabling both; uninstall locally with `brew uninstall tmate` and `brew uninstall --cask qlstephen`).
