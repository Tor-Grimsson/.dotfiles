---
title: NameChanger
type: reference
status: active
updated: 2026-06-04
description: macOS app for batch-renaming lists of files with live preview before applying.
aliases:
  - namechanger
tags:
  - domain/files
  - pattern/gui
  - integration/brew-cask
  - provider/mrr-software
links:
  website: https://mrrsoftware.com/namechanger/
  manual: https://mrrsoftware.com/namechanger/
  brew: https://formulae.brew.sh/cask/namechanger
covers:
  - Batch renaming of file lists on macOS
  - Find/replace, sequence numbering, and case changes
  - Live preview of new names before committing
related:
  - "[[04-marta|Marta]]"
---

## Summary

NameChanger is a macOS GUI app for renaming a list of files in bulk. You drop files in, choose a transformation (find-and-replace text, add a sequence number, change case, insert or remove characters), and it shows the resulting names live before you apply anything. It is built for the one-off "rename these 200 files consistently" task that Finder handles clumsily.

## Why installed

Renaming a batch of files to a consistent scheme — exports, downloads, scanned documents — is tedious in Finder and error-prone on the command line. NameChanger makes the transformation visible and reversible-by-preview before it touches a single file, which is the safe way to do bulk renames.

## Most common use case

Applying a find-and-replace or sequential numbering scheme across a dropped-in list of files, checking the preview, then committing.

## Biggest win

The live preview: every new name is shown before anything is renamed, so you catch a wrong pattern before it mangles a folder. It's a visual, low-risk alternative to a `for` loop with `mv`.

## How to use

- Launch NameChanger and drag the files to rename into the left list.
- Pick a renaming mode (e.g. "Replace First Occurrence", "Sequence", "Original Name + Text").
- Fill in the text/options; the right column shows the resulting names live.
- Confirm the preview, then click the rename button to apply.
- Settings let you control numbering start/padding, case, and where inserted text lands.

## Future use

NameChanger is GUI-only with no public API or CLI, so there is little to automate. The unexplored direction is scope: leaning on it for any recurring batch-rename job (media imports, document scans) instead of hand-writing shell rename loops, keeping renames previewable and consistent.
