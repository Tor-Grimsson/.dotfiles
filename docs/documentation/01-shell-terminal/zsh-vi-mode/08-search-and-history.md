---
title: Search & history in normal mode
type: guide
status: active
updated: 2026-07-09
description: Navigating and searching command history from vi normal mode (k/j, /, ?, n, N) and how vi-mode coexists with the existing finder stack — fzf Ctrl-R, atuin, and the Up/Down prefix-search tiers — without stepping on each other.
tags:
  - domain/shell
related:
  - "[[INDEX|zsh vi-mode — complete guide]]"
  - "[[25-atuin|atuin]]"
  - "[[12-fzf|fzf]]"
  - "[[03-power-and-setup|Power features & your setup]]"
---

# Search & history in normal mode

vi-mode adds *another* way to move through history — the vim way — on top of the finder stack you already built. They don't conflict; they're layered. This chapter is which one to reach for.

## History from normal mode

Press `Esc` first, then:

| Key | Does |
| --- | --- |
| `k` | previous command (older) |
| `j` | next command (newer) |
| `/<text>` | search **backward** through history for `<text>`, `Enter` to accept |
| `?<text>` | search **forward** |
| `n` | jump to the next match of the last `/` search |
| `N` | previous match |

So `k`/`j` are the normal-mode twins of the arrow keys, and `/` is a vim-native history search that lands you in a recalled command you can then edit with motions.

## How it coexists with your finder stack

You have several history tools; vi-mode is additive. Here's the whole picture:

| Trigger | Tool | Best for |
| --- | --- | --- |
| `k` / `j` (normal mode) | vi-mode | quick step to the last few commands, then edit with motions |
| `Up` / `Down` | zsh prefix search | type a prefix (`git`), walk only matching history inline |
| `/` `?` `n` `N` (normal mode) | vi-mode | vim-style in-history search when you're already in normal mode |
| `Ctrl-R` | [[12-fzf|fzf]] | fuzzy-filter *all* history in a picker |
| `Ctrl-P` | [[25-atuin|atuin]] | rich search — scoped (dir/host/session), with exit code & timing |
| `Shift-Up` | atuin | atuin scoped to the current directory, seeded with the typed prefix |

**Rule of thumb:** `Up` for "the command I just ran with this prefix," `Ctrl-R`/`Ctrl-P` for "somewhere in my history," `k`/`/` when you're already in normal mode and don't want to leave it.

## Why they don't collide

`Ctrl-R`, `Ctrl-T`, `Alt-C`, `Ctrl-P` and the `Up`/`Down` tiers are all **insert/main-keymap** bindings, re-applied in `zvm_after_init` after the plugin's keymap reset (see [[04-configuration|configuration]]). `k`/`j`/`/`/`n` live in the **vicmd (normal)** keymap, which is a separate table. Different keymaps, no overlap — pressing `k` in insert mode types a "k"; it only means "previous command" in normal mode.

## A note on muscle memory

Because `Ctrl-R` still works *in insert mode* (it's preserved), you rarely need the vim `/` search — you'll reach for fzf/atuin reflexively. That's fine. The vim history keys are there for the moments you're already in normal mode editing and want to swap in a nearby command without switching tools.

Next: [[09-troubleshooting-faq|Troubleshooting & FAQ]].
