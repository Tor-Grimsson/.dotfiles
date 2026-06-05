---
title: Audio scripts
type: reference
status: active
updated: 2026-06-05
description: au-* — audio conversion helpers.
tags:
  - project/dotfiles
  - domain/scripts/audio
---

# Audio (`au-`)

| Script | Does | Usage |
|--------|------|-------|
| `au-flac.sh` | Recursively convert `*.wav` / `*.aif` / `*.aiff` → FLAC (compression 8), parallel (`-P 6`), **deletes source** on success | `au-flac.sh [dir]` (default `.`) |

> Supersedes the older `aiff2flac.sh` (aiff-only) and `convert-flac.sh` (wav-only) — `au-flac.sh` covers all three formats (both now in `~/_temp/bin_bak/`).

## `au-flac.sh`

Recursively transcodes WAV/AIF/AIFF to lossless FLAC via ffmpeg, then removes each source once its FLAC is written. Has a `-h`/`--help` usage block; the optional `[dir]` positional is untouched by it.

**Usage** — `au-flac.sh [dir]`; `dir` defaults to `.` (the current directory) and is searched recursively.

**Args**
- `[dir]` — root to walk; matches `*.wav`/`*.aif`/`*.aiff` case-insensitively (`-iname`).
- `-h`, `--help` — print usage and exit; does not consume the `[dir]` arg.

**What it does**
- Encodes `foo.wav` → sibling `foo.flac` with `-c:a flac -compression_level 8` (max compression, lossless).
- Runs up to 6 jobs at once (`xargs -P 6`); `-nostdin` keeps parallel ffmpeg jobs from fighting over the terminal.
- **Destructive**: `&& rm "$1"` deletes the source only on a clean ffmpeg exit; a same-named `.flac` is overwritten without prompting.

**Example** — `au-flac.sh ~/Music/recordings` converts every WAV/AIF/AIFF under that tree to FLAC and deletes the originals.

**Dependency** — `ffmpeg` (with its default FLAC encoder).
