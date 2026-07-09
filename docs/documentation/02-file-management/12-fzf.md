---
title: fzf
type: reference
status: active
updated: 2026-07-09
description: Interactive fuzzy finder — filter any list by typing. Powers Ctrl-R history, Ctrl-T file-insert, Alt-C cd, and Tab completion (via fzf-tab). (atuin lives on Ctrl-P.)
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
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[10-fd|fd]]"
  - "[[11-ripgrep|ripgrep]]"
  - "[[08-eza|eza]]"
  - "[[13-zoxide|zoxide]]"
  - "[[23-stdin-pipes|stdin, stdout & pipes]]"
  - "[[25-atuin|atuin]]"
---

## Summary

Pipe any list in, type to fuzzy-filter, pick one. The spine of the shell setup here: wired to **Ctrl-R** (history), **Ctrl-T** (insert a file path), **Alt-C** (cd), and Tab completion (via the `fzf-tab` plugin). Fed by [[10-fd|fd]], previewed by [[09-bat|bat]] / [[08-eza|eza]]. [[25-atuin|atuin]]'s richer history search lives on **Ctrl-P** instead.

> Once open, **typing IS the search** — there's no search command. Arrow to move, Enter to pick, Esc to cancel.

## How to use

```sh
fzf                                   # pick a file under here (uses fd); type to filter, Enter prints it
vim "$(fzf)"                           # pick a file, open it
fd -e md | fzf                         # filter any custom list
fzf --preview 'bat --color=always {}'  # picker with a file preview
rg --line-number . | fzf --ansi        # fuzzy-filter content-search hits (live grep)
```

Keybindings (from `source <(fzf --zsh)` in `shell/.zshrc`): **Ctrl-R** history search · **Ctrl-T** insert file path · **Alt-C** cd into a dir. atuin is initialised with `--disable-ctrl-r` so fzf keeps **Ctrl-R**; atuin's own search is bound to **Ctrl-P** ([[25-atuin|atuin]]). Config lives in the fzf block of `shell/.zshrc` (`FZF_DEFAULT_OPTS`, `FZF_DEFAULT_COMMAND='fd …'`, the dir-aware preview, and the Alt-C/Ctrl-R preview opts).

**In-picker search syntax:**

| Type | Match |
|---|---|
| `foo` | fuzzy |
| `'foo` | exact |
| `^foo` / `foo$` | prefix / suffix |
| `!foo` | exclude |
| `a b` | both (AND) |

## Why installed

Turns "find the right file / command / branch" from remembering-and-retyping into type-a-few-letters-and-pick. `Ctrl-T`/`Alt-C` get used dozens of times a day; history search (once fzf's own biggest win) moved to [[25-atuin|atuin]] for the exit-code/cwd/host context and multi-machine sync it adds.

## Biggest win

`Ctrl-T` — insert a file path mid-command without breaking flow to `cd`/`ls` first.

## Future use

fzf-powered git pickers (branches/commits), `kill **<Tab>` process selection, custom `--bind` actions, and a saved `rg | fzf` live-grep function.
