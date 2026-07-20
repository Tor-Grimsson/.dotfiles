---
title: ref
type: reference
status: active
updated: 2026-07-15
description: The desk-reference-card dispatcher — one engine that bat-prints flat tagged cards (keys · tmux · files · widgets · system · nvim · nnow) filtered by tag; each one is a ref-<name> script printing its ref/<name>.md list.
aliases:
  - ref
tags:
  - project/dotfiles
  - domain/shell
  - pattern/cli
related:
  - "[[INDEX|Scripts index]]"
  - "[[19-keys|keys]]"
  - "[[20-files|files]]"
---

## Summary
`ref` is the parent of the reference-card family: flat, hand-kept, tag-filterable markdown cards printed via bat. Bare `ref` lists the cards; `ref <card> [tag …]` prints one. Every card also answers as a hyphenated command — `ref-keys`, `ref-tmux`, `ref-files`, `ref-widgets`, `ref-system`, `ref-nvim`, `ref-nnow` — so `ref-<TAB>` lists the family; bare `keys`/`files` remain as the short daily aliases.

## Why it exists
The `keys` pattern (one concern, flat tagged data, zero prose) proved to be the most-used shell utility — worth systematising. Instead of copying the awk engine per tool, one dispatcher owns it and each new reference is just a data file plus a `card_file` line.

## Deps
| Needs | For |
|---|---|
| `bat` | the highlighted print |
| `keys/keybinds.md` | the `keys` card — keybinds; also the `tmux` card (same data **scoped to `#tmux`** — a card can be a file + base tag, so domain views cost one line, no duplicate data) |
| `files/folders.md` | the `files` card — curated folder map (`to <tag>` jumps) |
| `ref/widgets.md` | the `widgets` card — desk-widget stack (simple-bar · bookmarks · notes · Übersicht) |
| `ref/system.md` | the `system` card — system-level hotkeys & setup; `#theme` sections (⇧⌥⌘T toggle, kol-theme selector, gotchas) |
| `ref/nvim.md` | the `nvim` card — the DAILY config (tree · flash · substitute · lsp · git · oil/harpoon since the 2026-07-20 nmix merge) |
| `ref/nnow.md` | the `nnow` card — the from-scratch build, modes as tags (oil · harpoon · lsp) |

## How to use
```sh
ref                     # list the cards
ref widgets             # the whole desk-widget card
ref widgets refresh     # just the refresh/debug section
ref-widgets gotcha      # the burn-marks (hyphenated aliases work for every card)
ref-system theme        # the theme sections (hotkeys, kol-theme, gotchas)
ref-nvim harpoon        # harpoon binds in nnow
ref keys tmux popover   # same as `keys tmux popover`
```
Tags match the `## #tag …` section headers (case-insensitive, all must match).
`ref-<card> --help` prints card-specific help — its data path and live section list (pulled from the data file, so it never goes stale); bare `ref --help` keeps the family overview.

## Adding a card
Drop a flat tagged `.md` in `ref/` (sections = `## #tag [#tag …]`, terse `thing    fact` lines), add one line to `card_file()` in `bin/ref`, and list it in `usage()`. Add the matching `bin/ref-<card>` alias (three lines — copy any existing one).

## Biggest win
One command shape for every "just show me the facts" lookup — and new cards cost a data file, not a new script.
