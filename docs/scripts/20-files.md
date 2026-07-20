---
title: files
type: reference
status: active
updated: 2026-07-15
description: Print your own bookmarked folders in the shell, filtered by tag, via bat — and jump into one with `to`. A curated map of where things live (projects, configs) so navigation is one word, not a half-remembered cd.
aliases:
  - files
  - to
tags:
  - project/dotfiles
  - domain/shell
  - pattern/cli
related:
  - "[[INDEX|Scripts index]]"
  - "[[22-ref|ref]]"
  - "[[19-keys|keys — keybind reference]]"
  - "[[13-zoxide|zoxide]]"
  - "[[09-bat|bat]]"
---

## Summary
`files [tag …]` bat-prints a hand-kept list of your bookmarked folders, filtered by tag; `to [tag …]` jumps into one (single match cd's straight in, several fzf-pick). A curated map of where things live — projects, design-system repos, dotfiles configs — reachable in one word. Same skeleton as [[19-keys|keys]], plus the `cd` that keybind-printing doesn't need.

2026-07-15: `files` is now a thin alias of `ref files` — [[22-ref|ref]] owns the engine; data file and usage unchanged.

## Why it exists
`cd ~/dev/projects/kol-apps/kol-media-admin` is a lot of typing you only half-remember. zoxide ([[13-zoxide|z]]) helps once you've *been* somewhere, by frecency. `files`/`to` is the **curated** counterpart: you decide what's on the map and tag it, so `to kol` reaches the right place whether or not you've visited it lately.

## `files` vs `to`
| Command | Does |
|---|---|
| `files [tag …]` | **prints** the catalog, filtered by tag (a `bin/` script → `bat`) |
| `to [tag …]` | **jumps** — filter by tag; one match cd's in, several fzf-pick, no arg picks from all |

`to` is a **shell function**, not a `bin/` script — only the shell can change its own working directory; a child process can't. That's the one structural difference from `keys`.

## Deps
| Needs | For |
|---|---|
| `bat` | the highlighted print ([[09-bat|bat]]) |
| `fzf` | picking among several matches in `to` |
| `eza` | the folder preview in `to`'s picker |
| `files/folders.md` | the data — `~/.dotfiles/files/folders.md`, hand-maintained |

## How to use
```sh
files                 # every folder
files kol             # every #kol section
files kol apps        # sections tagged BOTH #kol and #apps
files config          # the #config section
to kol                # jump: filter to #kol, cd (one match) or fzf-pick (several)
to                    # fzf-pick from all folders, then cd
```
Tags match the `## #tag …` section headers (case-insensitive, all must match). No `#` when you type — `files kol`, not `files #kol` (the `#` is a shell comment).

## The data file
`files/folders.md` — plain markdown, one section per `## #tag [#tag …]` header, `path    description` lines below. **A hand-kept map**, so when a folder moves, edit this file too — and every path must be real, or `to` jumps to nothing. Add or fix entries with the `/files-add` skill (the sibling of `/keys-add`).

## Biggest win
`to kol` from anywhere beats remembering the full `~/dev/projects/…` path — and unlike zoxide it works *before* you've ever cd'd there, because it's curated, not frecency-learned.

## Future use
Tab-completion of the tag list; a `-p` "print path only" mode for scripting (`cd "$(files -p kol)"`); an inline `--add`. None built — the list + `to` cover the day-to-day.
