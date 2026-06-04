---
title: Neovim
type: reference
status: active
updated: 2026-06-04
description: Ambitious Vim fork focused on extensibility, with Lua scripting, a built-in LSP client, and Tree-sitter parsing.
aliases:
  - nvim
tags:
  - domain/dev/editor
  - pattern/tui
  - integration/brew-formula
links:
  website: https://neovim.io/
  repo: https://github.com/neovim/neovim
  manual: https://neovim.io/doc/
  brew: https://formulae.brew.sh/formula/neovim
covers:
  - What Neovim adds over Vim and where config lives
  - Launching, editing, and the core modal workflow
related:
  - "[[02-visual-studio-code|VS Code]]"
---

## Summary
Neovim is a modal terminal text editor, a fork of Vim that modernises the internals. It adds a built-in Language Server Protocol client, Tree-sitter syntax parsing, an embedded Lua runtime for configuration and plugins, and a clean API for embedding in other tools.

## Why installed
It is the fast, terminal-resident editor — open instantly inside any shell or SSH session to edit a config file, write a commit message, or make a quick change without leaving the terminal. It fills the role VS Code can't: zero startup cost and no window switch.

## Most common use case
Quick edits in the terminal: opening a single file (`nvim file`), making changes with modal keystrokes, and saving — plus serving as the `$EDITOR` for Git commit messages and other CLI prompts.

## Biggest win
Modal editing speed combined with a first-class Lua config and built-in LSP. Once the motions are muscle memory, editing is faster than any mouse-driven editor, and the LSP client brings completion and diagnostics into the terminal that previously required a full IDE.

## How to use
```sh
# Open a file (or a directory / empty buffer)
nvim file.txt
nvim .

# Inside Neovim (normal mode is the default):
# i        enter insert mode      Esc   back to normal
# :w       save                   :q    quit        :wq  save and quit
# dd       delete line            yy    yank line   p    paste
# /text    search                 :%s/a/b/g  replace all

# Config lives at:  ~/.config/nvim/init.lua
```

## Future use
A structured plugin setup via `lazy.nvim`, language servers wired through `nvim-lspconfig` and `mason`, and Tree-sitter-driven highlighting and text objects — turning the quick-edit tool into a full terminal IDE that overlaps more with VS Code's project work.
