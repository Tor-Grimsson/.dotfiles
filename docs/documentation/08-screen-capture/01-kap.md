---
title: Kap
type: reference
status: active
updated: 2026-06-04
description: Open-source macOS screen recorder that exports to GIF, MP4, WebM, and APNG with a lightweight overlay UI.
aliases:
  - kap
tags:
  - domain/screen-capture
  - pattern/gui
  - integration/brew-cask
links:
  website: https://getkap.co/
  repo: https://github.com/wulkano/Kap
  manual: https://github.com/wulkano/Kap#readme
  brew: https://formulae.brew.sh/cask/kap
covers:
  - Recording a screen region or window to video/GIF
  - Trimming and choosing export format and FPS
  - Plugin-based export targets
related:
  - "[[02-keycastr|KeyCastr]]"
  - "[[03-openscreen|Openscreen]]"
---

## Summary
Kap is an open-source screen recorder for macOS built on web technology. You draw a capture region or pick a window, record, then trim and export to GIF, MP4, WebM, or APNG. It is deliberately small and fast rather than a full editor.

## Why installed
It is the go-to for quick screen recordings — bug repros, demo clips, and animated GIFs for docs or chat. The region selector and one-click GIF export make it faster than QuickTime plus a separate conversion step.

## Most common use case
Recording a small region of the screen and exporting it as a GIF or MP4 to share in an issue, a pull request, or a message.

## Biggest win
Direct, high-quality GIF export with FPS and trim control built in. There is no round-trip through a converter — record the region, trim the ends, pick the format, and the file is ready to drop anywhere.

## How to use
- Launch Kap from the menu bar; click the icon to start a capture.
- Drag to select a region, or pick a window/full screen.
- Set FPS and audio options in the recording bar before hitting record.
- Stop from the menu bar, then trim the clip in the preview window.
- Choose the export format (GIF / MP4 / WebM / APNG) and save or copy.
- Manage export plugins under Preferences to add targets like a CDN or hosting service.

## Future use
Kap's plugin system can wire exports straight into an upload destination, so a recording could land on a CDN or paste a shareable link automatically — turning record-and-share into a single action without a manual upload step.
