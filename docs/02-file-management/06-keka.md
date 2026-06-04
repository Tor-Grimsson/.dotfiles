---
title: Keka
type: reference
status: active
updated: 2026-06-04
description: macOS file archiver that creates and extracts a wide range of compression formats.
aliases:
  - keka
tags:
  - domain/files
  - pattern/gui
  - integration/brew-cask
links:
  website: https://www.keka.io/
  repo: https://github.com/aonez/Keka
  manual: https://www.keka.io/
  brew: https://formulae.brew.sh/cask/keka
covers:
  - Creating archives (7z, zip, tar, gzip, and more)
  - Extracting RAR, 7z, and other formats macOS can't open natively
  - Password-protected and split archives
related:
  - "[[04-marta|Marta]]"
---

## Summary

Keka is a macOS file archiver that both creates and extracts a broad set of compression formats. It writes 7z, zip, tar, gzip, bzip2, and more, and it reads formats the system Archive Utility won't, including RAR. Archives can be password-protected and split into volumes.

## Why installed

macOS only handles zip well out of the box and can't open RAR or 7z at all. Keka covers the gaps: it extracts whatever someone sends and produces compact, optionally encrypted archives when you need to send something out. It's the one tool that makes "just unzip this" actually work regardless of the format.

## Most common use case

Double-clicking a `.rar`, `.7z`, or other non-zip archive to extract it, or dragging files onto Keka to compress them into 7z/zip.

## Biggest win

Format coverage plus encryption: it reads and writes formats the OS ignores (RAR extraction, 7z creation) and can produce strong AES-encrypted, password-protected, and multi-volume archives — none of which Finder's built-in compression offers.

## How to use

- Compress: drag files onto the Keka window or Dock icon, pick the format (7z, zip, tar, etc.) and an optional password, and it writes the archive next to the source.
- Extract: double-click an archive (set Keka as the default handler), or drag it onto Keka.
- Set defaults in Preferences: default format, compression level, "delete file after compression", and whether to exclude macOS resource forks.
- A command-line helper (`keka`) is also installed by the cask for scripted compression.

## Future use

The bundled `keka` CLI binary is unexplored — wiring it into scripts would let archive creation/extraction run headless (batch-compressing exports, encrypting backups) instead of only through drag-and-drop in the GUI.
