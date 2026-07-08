---
title: Openscreen
type: reference
status: active
updated: 2026-06-04
description: macOS screen recorder and lightweight video editor, installed from a third-party Homebrew tap.
aliases:
  - openscreen
tags:
  - domain/screen-capture
  - pattern/gui
  - integration/brew-cask
links:
  website: https://github.com/siddharthvaddem/openscreen
  repo: https://github.com/siddharthvaddem/openscreen
  manual: https://github.com/siddharthvaddem/openscreen#readme
  brew: https://github.com/siddharthvaddem/homebrew-openscreen
covers:
  - Screen recording with built-in editing
  - Installation from a third-party tap
  - An alternative to Kap for longer captures
related:
  - "[[01-kap|Kap]]"
  - "[[02-keycastr|KeyCastr]]"
---

## Summary
Openscreen is a macOS screen recorder that also bundles a lightweight video editor, so a capture can be trimmed and tidied without a separate application. It sits between a bare recorder like Kap and a full editing suite.

## Why installed
It covers the cases where Kap stops short: longer recordings that need a quick edit pass before sharing. Having recording and basic editing in one app avoids exporting to a heavier editor for simple cuts.

## Most common use case
Recording a screen session and trimming or lightly editing it in the same app before exporting.

## Biggest win
Record-and-edit in one place. Where Kap focuses on fast region-to-GIF, Openscreen keeps an editing step inside the same tool, which suits longer-form captures.

## How to use
This cask is **not** in homebrew-core — it ships from the third-party tap `siddharthvaddem/openscreen`. Install and update it via that tap:

```sh
brew tap siddharthvaddem/openscreen
brew install --cask openscreen
brew upgrade --cask openscreen
```

- Launch Openscreen.app and grant Screen Recording permission when macOS prompts (System Settings > Privacy & Security > Screen Recording).
- Choose a capture target, record, then trim/edit in the built-in editor.
- Export to a video file when finished.

## Future use
As a tap-distributed app it updates outside the homebrew-core cadence, so keep an eye on the tap repo for releases. If its editor proves strong enough it could absorb the lightweight-edit role entirely, leaving Kap for quick GIFs and Openscreen for anything that needs a cut.
