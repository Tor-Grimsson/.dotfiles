---
title: zsh vi-mode — complete guide
type: index
status: active
updated: 2026-07-09
description: A read-me-start-to-finish guide to using vi-mode on the zsh command line — the on/off switch, the three modes, every motion and edit worth drilling, the power features, and exactly how it's wired into your shell. Companion to the catalog reference.
aliases:
  - vi-mode guide
  - zsh vi-mode guide
tags:
  - domain/shell
related:
  - "[[28-zsh-vi-mode|zsh-vi-mode (catalog reference)]]"
  - "[[11-neovim-cheatsheet|Neovim cheatsheet]]"
---

# zsh vi-mode — complete guide

Everything you need to *use* modal editing on the command line, in reading order. The catalog page [[28-zsh-vi-mode|zsh-vi-mode]] covers what it is and how it's installed; **this folder is the how-to.**

## Read in this order

Chapters 1–2 get you working; 3–8 go deep; 9 is the fix-it desk. Learners: read 1, 2, then use 9 as needed. Tinkering with config: 4, then 5.

| # | Chapter | What you'll learn |
| --- | --- | --- |
| 1 | [[01-basics|Basics — modes, cursor & the off-switch]] | the three modes, how to switch, the cursor tells, and how to turn it off in one line |
| 2 | [[02-motions-and-editing|Motions & editing]] | move by word/char/line, the verb+object grammar, text objects, undo/repeat/yank — the core |
| 3 | [[03-power-and-setup|Power features & your exact setup]] | surround/`vv`/`gx`/clipboard at a glance, plus what's wired in your `.zshrc` and what changed on disk |
| 4 | [[04-configuration|Configuration reference]] | where config lives, the four hook functions, and every `ZVM_*` option with defaults |
| 5 | [[05-configs-compared|Real configs compared]] | eight real GitHub dotfiles tabulated against ours — escape key, cursor, fzf, init mode |
| 6 | [[06-visual-mode|Visual mode & selections]] | select by char/line, extend with motions, act on the highlight |
| 7 | [[07-surround|Surround — the full grammar]] | add/change/delete surrounding quotes, brackets, tags with `ys`/`cs`/`ds` |
| 8 | [[08-search-and-history|Search & history in normal mode]] | `k`/`j`/`/`/`n` history, and how it coexists with fzf/atuin/the Up-Down tiers |
| 9 | [[09-troubleshooting-faq|Troubleshooting & FAQ]] | escape lag, cursor-in-tmux, lost keybinds, autosuggestions, `cat -v` debugging |

## The off-switch (read this first)

You committed to vi-mode as a forcing function, but it is **not** a one-way door:

```zsh
# in shell/.zshrc
VI_MODE=false     # then run: exec zsh
```

That flips you straight back to emacs mode. Nothing else to undo. Details in [[01-basics|chapter 1]].

## One-screen quick reference

The 15 you'll use hourly (full tables in [[02-motions-and-editing|chapter 2]]):

| Key | Does |
| --- | --- |
| `Esc` | leave insert → **normal mode** (block cursor) |
| `i` `a` `A` `o` | insert: here / after cursor / end of line / new line |
| `w` `b` | next / previous word |
| `0` `$` | start / end of line |
| `f<c>` | jump to next `<c>` on the line |
| `x` | delete a char |
| `dd` `dw` | delete line / word |
| `ciw` | change the word you're on |
| `ci"` | change what's inside the quotes |
| `u` `Ctrl-r` | undo / redo |
| `.` | repeat the last change |
| `ysiw"` | wrap the word in quotes (surround) |
| `vv` | open the line in nvim, save to run |

## Also handy

- Type a prefix then **Up** to walk only matching history (that's the [[25-atuin|history]] tiers, not vi-mode) — the two work together.
- `keys vimode` prints the drill list any time; `keys vi` shows vi-mode **and** the nvim motions together.
