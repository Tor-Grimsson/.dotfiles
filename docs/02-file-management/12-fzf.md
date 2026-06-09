---
title: fzf
type: reference
status: active
updated: 2026-06-09
description: Interactive fuzzy finder — filter any list by typing. Powers Ctrl-R history, Ctrl-T file-insert, Alt-C cd, and Tab completion (via fzf-tab).
aliases:
  - fzf
tags:
  - domain/files
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/junegunn/fzf
  repo: https://github.com/junegunn/fzf
  manual: https://github.com/junegunn/fzf/blob/master/README.md
  brew: https://formulae.brew.sh/formula/fzf
covers:
  - the picker model + in-picker search syntax
  - the Ctrl-R / Ctrl-T / Alt-C keybindings
  - how it's wired (fd source, bat/eza previews, fzf-tab)
related:
  - "[[10-fd|fd]]"
  - "[[11-ripgrep|ripgrep]]"
  - "[[08-eza|eza]]"
---

## Summary

Pipe any list in, type to fuzzy-filter, pick one. The spine of the shell setup here: wired to **Ctrl-R** (history), **Ctrl-T** (insert a file path), **Alt-C** (cd), and Tab completion (via the `fzf-tab` plugin). Fed by [[10-fd|fd]], previewed by [[09-bat|bat]] / [[08-eza|eza]].

> Once open, **typing IS the search** — there's no search command. Arrow to move, Enter to pick, Esc to cancel.

## How to use

```sh
fzf                                   # pick a file under here (uses fd); type to filter, Enter prints it
vim "$(fzf)"                           # pick a file, open it
fd -e md | fzf                         # filter any custom list
fzf --preview 'bat --color=always {}'  # picker with a file preview
rg --line-number . | fzf --ansi        # fuzzy-filter content-search hits (live grep)
```

Keybindings (from `source <(fzf --zsh)` in `shell/.zshrc`): **Ctrl-R** history · **Ctrl-T** insert file path · **Alt-C** cd into a dir. Config lives in the fzf block of `shell/.zshrc` (`FZF_DEFAULT_OPTS`, `FZF_DEFAULT_COMMAND='fd …'`, the dir-aware preview, and the Alt-C/Ctrl-R preview opts).

**In-picker search syntax:**

| Type | Match |
|---|---|
| `foo` | fuzzy |
| `'foo` | exact |
| `^foo` / `foo$` | prefix / suffix |
| `!foo` | exclude |
| `a b` | both (AND) |

## Why installed

Turns "find the right file / command / branch" from remembering-and-retyping into type-a-few-letters-and-pick. The keybindings — `Ctrl-R` especially — get used dozens of times a day.

## Biggest win

`Ctrl-R` fuzzy history search: no more scrolling `history` or retyping long commands. The single biggest daily time-saver in the shell.

## Future use

fzf-powered git pickers (branches/commits), `kill **<Tab>` process selection, custom `--bind` actions, and a saved `rg | fzf` live-grep function.
