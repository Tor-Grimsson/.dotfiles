---
title: Marta
type: reference
status: active
updated: 2026-06-04
description: Extensible two-pane (orthodox) file manager for macOS with full keyboard control.
aliases:
  - marta
tags:
  - domain/files
  - pattern/gui
  - integration/brew-cask
links:
  website: https://marta.sh/
  brew: https://formulae.brew.sh/cask/marta
covers:
  - Dual-pane copy/move workflow on macOS
  - Keyboard-driven navigation and file operations
  - Acting as a Finder replacement for bulk work
related:
  - "[[02-yazi|yazi]]"
  - "[[06-keka|Keka]]"
---

## Summary

Marta is a dual-pane ("orthodox", Norton Commander-style) file manager for macOS. Two directory panes sit side by side so copying and moving between locations is a single keystroke rather than a drag across windows. It is built around the keyboard and is configurable and extensible.

## Why installed

Finder is awkward for the core file-shuffling task — moving files between two known locations. Marta's two panes make that the default motion, and its keyboard focus means whole batches get organized without touching the mouse. It is the GUI counterpart to the terminal managers when a visual, mouse-optional workflow is wanted.

## Most common use case

Copying or moving files between two directories using the side-by-side panes, driven entirely from the keyboard.

## Biggest win

The two-pane layout: source on one side, destination on the other, with copy/move as one keypress. This beats Finder's single-window, drag-or-cut-paste model for any task that involves shuffling files between two specific places.

## How to use

- Launch Marta from Spotlight or `open -a Marta`.
- `Tab` switches the active pane; navigate the active pane to the source, the other to the destination.
- `F5` copies the selection to the other pane; `F6` moves it.
- `Enter` opens a folder or file; `Backspace` goes up a level.
- `F7` makes a new folder; `F8` / `Delete` removes the selection.
- First-run: open Preferences to set the default panes, theme, and key bindings; grant Full Disk Access in System Settings if you need to manage protected locations.

## Future use

Marta's configuration and action extensibility is unexplored here — defining custom file operations, openers, and key bindings (and pinning frequently used destination folders) would tune it into a bespoke organizing console rather than a stock two-pane viewer.
