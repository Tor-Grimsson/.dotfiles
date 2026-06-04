---
title: KeyCastr
type: reference
status: active
updated: 2026-06-04
description: Open-source macOS keystroke visualizer that shows pressed keys on screen for recordings and demos.
aliases:
  - keycastr
tags:
  - domain/screen-capture
  - pattern/gui
  - integration/brew-cask
links:
  website: https://github.com/keycastr/keycastr
  repo: https://github.com/keycastr/keycastr
  manual: https://github.com/keycastr/keycastr#readme
  brew: https://formulae.brew.sh/cask/keycastr
covers:
  - On-screen display of pressed keys and shortcuts
  - Visualizer styling and position
  - Pairing with a screen recorder for demos
related:
  - "[[01-kap|Kap]]"
  - "[[03-openscreen|Openscreen]]"
---

## Summary
KeyCastr is an open-source keystroke visualizer for macOS. It overlays the keys and shortcuts you press onto the screen, so viewers of a recording or live demo can see exactly what was typed.

## Why installed
It is the companion to the screen recorders here. A screencast that demonstrates shortcuts or a TUI workflow is far clearer when the keystrokes are visible, and KeyCastr supplies that overlay without any editing afterward.

## Most common use case
Running it alongside Kap or Openscreen while recording a demo, so every keyboard shortcut shows up on screen as it happens.

## Biggest win
Zero-effort keystroke overlay. It captures input system-wide and renders it live, which means the recording already contains the key callouts — no post-production annotation required.

## How to use
- Launch KeyCastr; grant Accessibility permission when macOS prompts (System Settings > Privacy & Security > Accessibility).
- Toggle the visualizer on/off from the menu bar item.
- Open Preferences to pick the display style (default bezel or "svelte"), font size, and screen position.
- Choose whether to show only modifier-key combinations or every keystroke.
- Start your recorder; the overlay is captured as part of the video.

## Future use
Tuning the visualizer to show only command/modifier chords keeps tutorial recordings clean — surfacing the shortcuts that matter while hiding the noise of ordinary typing.
