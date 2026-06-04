---
title: MesloLG Nerd Font
type: reference
status: active
updated: 2026-06-04
description: Meslo LG patched with Nerd Fonts glyphs for terminal and editor use.
aliases:
  - MesloLG Nerd Font
tags:
  - domain/fonts
  - pattern/library
  - integration/brew-cask
links:
  website: https://github.com/ryanoasis/nerd-fonts
  repo: https://github.com/ryanoasis/nerd-fonts
  manual: https://www.nerdfonts.com/
  brew: https://formulae.brew.sh/cask/font-meslo-lg-nerd-font
covers:
  - Meslo LG base patched with Nerd Fonts icon glyphs
  - Mono / Propo / standard and S/M/L/DZ variants
  - Use in terminal and editor configs
related:
  - "[[02-fontgoggles|FontGoggles]]"
---

## Summary
This cask installs the Meslo LG family patched by the Nerd Fonts project, which adds thousands of developer and powerline icon glyphs on top of the base typeface. Meslo LG is a customized Menlo derivative tuned for terminal legibility. The package ships standard, Mono, and Propo width variants across the S/M/L line-gap and DZ (dotted-zero) cuts.

## Why installed
It is the terminal and editor typeface for this setup. Prompt themes and TUI tools rely on Nerd Font glyphs — git status icons, powerline separators, file-type symbols — and Meslo LG is the patched font that renders them without tofu boxes.

## Most common use case
Set as the monospace font in the terminal emulator and code editor so prompts, status lines, and file-tree icons render correctly.

## Biggest win
Glyph coverage. The Nerd Fonts patch bundles Powerline, Devicons, Font Awesome, and more into one file, so a single font choice satisfies every icon-dependent prompt and TUI instead of juggling fallback fonts.

## How to use
- Installed font files land under the Caskroom and are registered with macOS Font Book automatically.
- In the terminal, set the font to a `MesloLG ... Nerd Font` variant; pick a `Mono` cut for fixed-cell alignment in TUIs.
- For editors, choose the matching Nerd Font family as the monospace font.
- The `DZ` variants use a dotted zero; pick `S`, `M`, or `L` for tighter or looser line spacing.

## Future use
The same Nerd Fonts patcher can apply glyphs to other base typefaces; if a different terminal face is ever preferred, the patched-font approach carries over without losing icon coverage.
