---
title: zsh-completions
type: reference
status: active
updated: 2026-06-04
description: Extra tab-completion definitions for zsh covering tools the base shell does not ship.
aliases:
  - zsh-completions
tags:
  - domain/shell
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/zsh-users/zsh-completions
  repo: https://github.com/zsh-users/zsh-completions
  manual: https://github.com/zsh-users/zsh-completions/blob/master/README.md
  brew: https://formulae.brew.sh/formula/zsh-completions
covers:
  - Adding the completions to FPATH and running compinit
  - Fixing insecure-directory warnings
related:
  - "[[04-zsh-syntax-highlighting|zsh-syntax-highlighting]]"
  - "[[03-powerlevel10k|powerlevel10k]]"
---

## Summary
zsh-completions is a community collection of additional tab-completion definitions for zsh, covering many commands that the shell's built-in completion set does not include. Once on `FPATH` and loaded via `compinit`, those tools gain argument and flag completion.

## Why installed
It broadens what Tab completion knows about. The base zsh completion set is large but incomplete; this fills the gaps for common CLI tools so flags and subcommands autocomplete instead of being typed from memory.

## Most common use case
Pressing Tab to complete subcommands and flags for tools that otherwise had no completion — the benefit is invisible and constant once it is set up.

## Biggest win
Coverage. It is the single largest third-party completion bundle for zsh, so installing it once upgrades completion for a long tail of tools without per-tool setup.

## How to use
```sh
# Add to ~/.zshrc BEFORE compinit runs:
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# If completions don't appear, force a rebuild of the cache:
rm -f ~/.zcompdump; compinit

# If you get "zsh compinit: insecure directories" warnings:
chmod go-w '/usr/local/share'
chmod -R go-w '/usr/local/share/zsh'
```

## Future use
Dropping project-specific `_command` completion files into a personal directory added to `FPATH`, and tuning `zstyle` completion behavior (menu selection, fuzzy matching, grouping) to get the most out of the expanded definitions.
