---
title: Raycast
type: reference
status: active
updated: 2026-06-04
description: Keyboard-driven launcher and command palette for macOS.
aliases:
  - raycast
tags:
  - domain/productivity
  - pattern/gui
  - integration/brew-cask
links:
  website: https://raycast.com/
  manual: https://manual.raycast.com/
  brew: https://formulae.brew.sh/cask/raycast
covers:
  - Launcher hotkey and root search
  - Extensions, snippets, clipboard history, window management
  - First-run setup on macOS
related:
  - "[[02-obsidian|Obsidian]]"
---

## Summary
Raycast is a keyboard-first launcher for macOS that replaces Spotlight with a fast command palette. Beyond launching apps it runs extensions, manages windows, expands snippets, and keeps a searchable clipboard history. Everything is reachable from a single hotkey without touching the mouse.

## Why installed
It is the central command surface for the machine — one hotkey to launch apps, switch windows, run scripts, and trigger extensions. Replacing Spotlight with Raycast keeps hands on the keyboard and consolidates a dozen small utilities into one tool.

## Most common use case
Hit the hotkey, type a few letters of an app or command, press Enter. The fuzzy root search covers apps, system commands, and installed extensions in one box.

## Biggest win
The extension store and built-in window management. It absorbs the jobs that would otherwise need separate menu-bar apps (clipboard manager, window tiler, snippet expander) into one launcher with no per-tool config sprawl.

## How to use
- Set the launcher hotkey on first run (commonly remapped over Spotlight's `Cmd+Space`).
- Type to fuzzy-search apps, files, and commands from the root search.
- Browse the Store from within Raycast to add extensions; manage them under Extensions in Settings.
- Define text snippets and enable Clipboard History in Settings for everyday reuse.
- Use window-management commands (halves, thirds, maximize) bound to your own shortcuts.

## Future use
Script Commands and custom extensions can turn Raycast into a front-end for the dotfiles tooling — wrapping `rclone` syncs, font installs, or project scripts behind a typed command instead of a terminal invocation.
