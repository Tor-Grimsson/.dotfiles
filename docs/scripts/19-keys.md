---
title: keys
type: reference
status: active
updated: 2026-07-08
description: Print your own keybinds in the shell, filtered by tag, via bat — a fast read-and-throw reference for tmux / nvim / aerospace / git / gh / ssh keys you're still burning into memory.
aliases:
  - keys
tags:
  - project/dotfiles
  - domain/shell
  - pattern/cli
related:
  - "[[INDEX|Scripts index]]"
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[02-tmux|tmux]]"
  - "[[09-bat|bat]]"
---

## Summary
`keys [tag …]` bat-prints a hand-kept list of your own keybinds, filtered by tag. Fast, shell-local, throw-away — the thing you reach for while a bind isn't muscle-memory yet. Curated and terse, unlike the prose docs; a deliberate second copy, not generated from them.

## Why it exists
The keybinds live in configs and are explained in the docs, but neither gives a dense, greppable `key → action` list you can pull up in one word. This does. It's the always-a-shell-in-front reference `tldr` is for standard commands — but for *your* keys.

## Deps
| Needs | For |
|---|---|
| `bat` | the highlighted print ([[09-bat|bat]]) |
| `keys/keybinds.md` | the data — `~/.dotfiles/keys/keybinds.md`, hand-maintained |

## How to use
```sh
keys                    # everything
keys tmux               # every #tmux section
keys tmux popover       # sections tagged BOTH #tmux and #popover
keys bookmark           # the #bookmark section
keys aerospace focus    # aerospace focus keys
keys nvim edit          # nvim edit grammar
```
Tags match the `## #tag …` section headers (case-insensitive, all must match). No `#` when you type — `keys tmux`, not `keys #tmux` (the `#` is a shell comment).

## The data file
`keys/keybinds.md` — plain markdown, one section per `## #tag [#tag …]` header, `key    action` lines below. Seeded from the live tmux / aerospace / nvim configs. **It's a hand-kept copy**, so when you rebind something, edit this file too (same discipline as the docs). Add a section by dropping a new `## #tags` block in.

## Biggest win
One word, the right keys, no context switch — `keys tmux layout` beats opening Obsidian or scrolling `tmux lsk`'s 275 lines.

## Future use
A `-l`/live mode could wrap `tmux list-keys` for the definitive running binds; and a completion for the tag list. Neither built — the flat list covers the day-to-day.
