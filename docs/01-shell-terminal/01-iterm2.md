---
title: iTerm2
type: reference
status: active
updated: 2026-06-04
description: macOS terminal emulator that replaces Apple's Terminal.app with split panes, search, and deep customization.
aliases:
  - iterm
tags:
  - domain/shell
  - pattern/gui
  - integration/brew-cask
links:
  website: https://iterm2.com/
  repo: https://github.com/gnachman/iTerm2
  manual: https://iterm2.com/documentation.html
  brew: https://formulae.brew.sh/cask/iterm2
covers:
  - First-run setup and where the important settings live
  - Split panes, search, and the features that beat Terminal.app
related:
  - "[[02-tmux|tmux]]"
  - "[[03-powerlevel10k|powerlevel10k]]"
---

## Summary
iTerm2 is a feature-rich terminal emulator for macOS, built as a drop-in replacement for the stock Terminal.app. It adds split panes, a searchable scrollback, GPU-accelerated rendering, profiles, and extensive keyboard and trigger customization.

## Why installed
It is the host window everything else in this category runs inside. The shell prompt (powerlevel10k), the multiplexer (tmux), and the highlighters all render through iTerm2, so the emulator's color, font, and rendering quality set the ceiling for the whole terminal experience.

## Most common use case
Being the everyday terminal: opening a window, splitting it into panes, and running shell sessions with a Nerd Font and 24-bit color so prompt glyphs and syntax highlighting display correctly.

## Biggest win
Native split panes plus instant scrollback search (Cmd+F) and the hotkey window — a global shortcut that drops a terminal down over any app. That combination is the main reason to use it over Apple's Terminal.

## How to use
- First run: macOS will prompt to grant the app permissions; allow it, then set iTerm2 as the default terminal if desired (Preferences if offered, or just keep launching it directly).
- Set a Nerd Font: Settings -> Profiles -> Text -> Font, pick a patched Nerd Font so powerlevel10k glyphs render.
- Enable true color: Settings -> Profiles -> Terminal, report terminal type `xterm-256color`.
- Split panes: Cmd+D (vertical), Cmd+Shift+D (horizontal); navigate with Cmd+Opt+Arrow.
- Search scrollback: Cmd+F.
- Hotkey window: Settings -> Keys -> Hotkey, "Create a Dedicated Hotkey Window".

## Future use
Triggers (regex-driven actions on output), the Python API for scripting window layouts, and tmux integration mode (`tmux -CC`) which turns tmux windows into native iTerm2 tabs — all unexplored here and worth adopting for session automation.
