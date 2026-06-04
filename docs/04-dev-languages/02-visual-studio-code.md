---
title: Visual Studio Code
type: reference
status: active
updated: 2026-06-04
description: Microsoft's open-source code editor with a large extension ecosystem, integrated terminal, and built-in Git.
aliases:
  - vscode
  - code
tags:
  - domain/dev
  - pattern/gui
  - integration/brew-cask
  - provider/microsoft
links:
  website: https://code.visualstudio.com/
  repo: https://github.com/microsoft/vscode
  manual: https://code.visualstudio.com/docs
  brew: https://formulae.brew.sh/cask/visual-studio-code
covers:
  - First-run setup and the `code` shell command
  - Extensions, integrated terminal, and Git workflow
related:
  - "[[03-neovim|neovim]]"
---

## Summary
Visual Studio Code is a free, cross-platform code editor from Microsoft built on Electron. It combines a fast editor with an integrated terminal, built-in Git, a debugger, and a huge extension marketplace that covers nearly every language and framework.

## Why installed
It is the primary graphical editor for this setup — the place for multi-file project work, debugging, and source control with a visual diff. It complements the terminal-first tools: where neovim handles quick edits inside a shell, VS Code handles sustained project work with a file tree, search, and extensions.

## Most common use case
Opening a project folder (`code .`), editing across many files with IntelliSense and inline diagnostics, and using the integrated terminal and Git panel without leaving the window.

## Biggest win
The extension ecosystem. Language servers, formatters, linters, remote-development, and AI assistants all install in a click, turning one editor into a tuned environment for any stack — something a bare editor can't match without manual config.

## How to use
- First run: open the app once, then install the `code` shell command via the Command Palette (Cmd+Shift+P -> "Shell Command: Install 'code' command in PATH").
- Open a project from the terminal: `code .` or `code path/to/folder`.
- Command Palette: Cmd+Shift+P — the entry point for almost every action.
- Integrated terminal: Ctrl+` (backtick).
- Extensions: Cmd+Shift+X to browse and install.
- Global search: Cmd+Shift+F; quick file open: Cmd+P.

## Future use
Settings Sync (sign in to mirror extensions and keybindings across machines), workspace-level `.vscode/` configs checked into repos for consistent formatting, and Remote-SSH / Dev Containers to edit code running inside the OrbStack VMs directly.
