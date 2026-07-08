---
title: zsh-syntax-highlighting
type: reference
status: active
updated: 2026-06-04
description: Fish-style syntax highlighting for the zsh command line as you type.
aliases:
  - zsh-syntax-highlighting
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/zsh-users/zsh-syntax-highlighting
  repo: https://github.com/zsh-users/zsh-syntax-highlighting
  manual: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
  brew: https://formulae.brew.sh/formula/zsh-syntax-highlighting
covers:
  - Activating highlighting in .zshrc
  - What gets highlighted and why it matters
related:
  - "[[05-zsh-completions|zsh-completions]]"
  - "[[03-powerlevel10k|powerlevel10k]]"
---

## Summary
zsh-syntax-highlighting colors the zsh command line live as you type, in the style of the fish shell. Valid commands, options, paths, quotes, and strings get distinct colors, and unknown commands or unbalanced quotes turn red before you ever hit Enter.

## Why installed
It is a cheap, high-value safety net. Seeing a command name go green (found on PATH) or red (typo / not found) catches mistakes before execution, and the path/quote highlighting flags broken arguments at a glance.

## Most common use case
Passive, continuous feedback while typing any command — the green/red command coloring alone prevents a steady stream of "command not found" runs.

## Biggest win
Catching errors before execution. Unbalanced quotes, mistyped command names, and nonexistent paths are visually flagged in real time, which no plain prompt does.

## How to use
```sh
# Add to the END of ~/.zshrc (it must load after most other config):
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# If you see "highlighters directory not found", add to ~/.zshenv:
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters
```
Load it last in `.zshrc` (after completions and other plugins) — it wraps the line editor and expects to be the final hook.

## Future use
Enabling extra highlighters beyond the default `main` — `brackets` (match/mismatch coloring), `pattern` (flag dangerous commands like `rm -rf`), and `cursor`/`regexp` — plus custom `ZSH_HIGHLIGHT_STYLES` to tune the color scheme.
