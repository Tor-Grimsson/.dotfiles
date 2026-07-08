---
title: FontGoggles
type: reference
status: active
updated: 2026-06-04
description: macOS font viewer and inspector for many font formats.
aliases:
  - fontgoggles
tags:
  - domain/fonts
  - pattern/gui
  - integration/brew-cask
links:
  website: https://fontgoggles.org/
  repo: https://github.com/justvanrossum/fontgoggles
  brew: https://formulae.brew.sh/cask/fontgoggles
covers:
  - Previewing TTF/OTF/variable/web font files
  - Variable-font axes and OpenType feature inspection
  - Multi-font comparison
related:
  - "[[01-font-meslo-lg-nerd-font|MesloLG Nerd Font]]"
---

## Summary
FontGoggles is a macOS application for viewing and inspecting font files without installing them. It opens TTF, OTF, variable, and web font formats and renders custom sample text with full shaping. Multiple fonts can be loaded side by side for direct comparison.

## Why installed
It is the inspection bench for fonts — including the Nerd Font and any candidate typefaces — letting you preview glyph coverage, variable axes, and OpenType features before committing a font to the terminal or editor config. No system install needed to evaluate a file.

## Most common use case
Drag a font file onto the window and type sample text to check how it renders, then drag in a second font to compare them in the same view.

## Biggest win
Deep, install-free inspection. It exposes variable-font axes with live sliders and lets you toggle OpenType features, which the macOS Font Book preview does not do — ideal for verifying a font's icon and feature coverage.

## How to use
- Launch FontGoggles and drag one or more font files into the window.
- Edit the sample text to test specific glyphs (e.g. powerline or icon ranges).
- Drag variable-font axis sliders to preview weights and widths.
- Use the feature panel to enable/disable OpenType features per font.

## Future use
Its scriptable text-shaping view could be used to audit the Nerd Font's icon ranges, confirming every glyph a prompt theme expects is present before rolling out a font change.
