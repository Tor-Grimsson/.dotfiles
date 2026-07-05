---
title: iTerm2
type: reference
status: active
updated: 2026-07-05
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
  - Color theme (the tracked "coolnight" preset)
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
- Colors / theme: the Default profile ships the **coolnight** palette (deep navy `#011423` + neon teal/green accents — josean-dev's theme; this is what drives the look of yazi, the prompt, tmux, since they inherit the 16 ANSI slots). Preset tracked at `iterm/coolnight.itermcolors`; re-apply via Settings -> Profiles -> Colors -> Color Presets -> **coolnight**.
- **The tracked `iterm/com.googlecode.iterm2.plist` is a point-in-time export — the live app does NOT read from it.** Settings -> General -> Settings -> "Load preferences from a custom folder or URL" is deliberately **OFF**. Turning it on makes iTerm load whatever's in that file over live state, silently reverting any profile setting (font, colors, keybindings) that's drifted since the file was last exported — it broke live custom colors on 2026-07-05 (reverted same day). Don't re-enable this without a full diff of the active profile, not a spot-check.
- Split panes: Cmd+D (vertical), Cmd+Shift+D (horizontal); navigate with Cmd+Opt+Arrow.
- Search scrollback: Cmd+F.
- Hotkey window: Settings -> Keys -> Hotkey, "Create a Dedicated Hotkey Window".
- **Clipboard access (needed for tmux/OSC 52 copy from a remote box):** Settings -> General -> Selection tab -> check "Applications in terminal may access clipboard", set "Allow sending of clipboard contents?" to **Always Allow** (not "Ask Each Time" — iTerm can get stuck silently denying instead of prompting once a deny has been recorded). Without this, remote `y` yanks never reach the local clipboard, no error shown. Verified 2026-07-05, see [remote dev workflow §3](../22-remote-machine/02-remote-dev-workflow.md#3-clipboard-over-ssh--tmux).

## Future use
Triggers (regex-driven actions on output), the Python API for scripting window layouts, and tmux integration mode (`tmux -CC`) which turns tmux windows into native iTerm2 tabs — all unexplored here and worth adopting for session automation.
