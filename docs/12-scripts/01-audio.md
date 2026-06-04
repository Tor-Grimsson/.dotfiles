---
title: Audio scripts
type: reference
status: active
updated: 2026-06-04
description: au-* — audio conversion helpers.
tags:
  - project/dotfiles
  - domain/scripts/audio
---

# Audio (`au-`)

| Script | Does | Usage |
|--------|------|-------|
| `au-flac.sh` | Recursively convert `*.wav` / `*.aif` / `*.aiff` → FLAC (compression 8), parallel (`-P 6`), **deletes source** on success | `au-flac.sh [dir]` (default `.`) |

> Supersedes the quarantined `aiff2flac.sh` (aiff-only) and `convert-flac.sh` (wav-only) — `au-flac.sh` covers all three formats.
