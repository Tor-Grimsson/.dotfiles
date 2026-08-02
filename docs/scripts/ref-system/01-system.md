---
title: ref — system & engine
type: reference
status: active
updated: 2026-07-29
description: The desk-reference-card dispatcher — one engine (bin/ref) printing topical cards (tmux · nvim · git · explorer · grep · media · desk · terminal · shell · system · files), filtered by words in section titles; glow-rendered.
aliases:
  - ref
tags:
  - project/dotfiles
  - domain/shell
  - pattern/cli
related:
  - "[[INDEX|ref-system index]]"
  - "[[02-cards|02 — cards]]"
  - "[[20-files|files]]"
  - "[[20-files|files]]"
---

## Summary

`ref` is the parent of the reference-card family: flat, hand-kept, filterable markdown cards printed straight to the scrollback. Bare `ref` lists the cards; `ref <card> [word …]` prints one, filtered by words in its section titles.

## Commands

```sh
ref                     # list the cards
ref desk                # the whole out-of-terminal card
ref desk refresh        # just the widget refresh/debug section
ref-nvim insert         # hyphenated alias per card; words filter sections
ref-nvim plugins git    # all words must match the section title
ref keys tmux popover   # same as `keys tmux popover`
ref-pick                # interactive: pick a card, pick a section, read it
```

In tmux, **Prefix + Ctrl+F** opens `ref-pick` in a popup — fuzzy-pick at both levels, Enter drills in, Esc walks out.
`ref-<card> --help` prints the card's data path + live section list (pulled from the data file, never stale).

## The pipeline

| stage                                       | owner                                                    | doc                 |
| ------------------------------------------- | -------------------------------------------------------- | ------------------- |
| card data — one table-dialect file per card | `ref/*.md` · `files/folders.md`                          | [[02-cards\|02]]    |
| engine — registry, filter, renderer pick    | `bin/ref` (`card_def()` · awk section filter · `show()`) | this doc            |
| renderer — bat (highlight) or glow (render) | per-card field in `card_def()`                           | [[03-glow\|03]]     |
| theme — glow's style values                 | `ref/glow-style.json` (vendored, inert)                  | [[04-theme\|04]]    |
| screen — scrollback-only printing           | cat-pipe + `CLICOLOR_FORCE` in `show()`                  | [[05-terminal\|05]] |

## The engine, in three parts

`bin/ref` — quote what it explains, run the real thing:

- `card_def()` — the registry: card → `data-file|base-tag|renderer`. Every card owns its file since the keys dissolution (2026-07-29); the base-tag slot remains for future scoped views. All cards carry the `glow` renderer.
- the awk filter — keeps sections whose `## ` title contains ALL requested words, case-insensitive substring. Every card uses natural titles; the old tag words all survive in them ([[02-cards|02]]).
- `show()` — glow renders every card ([[03-glow|03]]; [[05-terminal|05]] for the pager/color mechanics); bat remains only as the no-glow fallback.

## Why it exists

The `keys` pattern (one concern, flat tagged data, zero prose) proved the most-used shell utility — worth systematising. One dispatcher owns the engine; each new reference costs a data file plus a registry line, not a new script.

## Adding a card

1. Drop a table-dialect `.md` in `ref/` — natural `## ` titles carrying the filter words, tables with NO per-row spacers, cells under 46 characters ([[02-cards|02]] for the rules; **`ref --lint` checks all of it**).
2. Add one `card_def()` line with the `glow` renderer field and a `usage()` line in `bin/ref`.
3. Add the matching `bin/ref-<card>` alias — three lines, copy any existing one.
