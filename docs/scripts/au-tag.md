---
title: Tag audio from a sidecar .md
type: playbook
status: active
updated: 2026-06-08
audience: internal
description: au-tag.sh — write album metadata + embedded cover art into a folder of mp3/flac from a sidecar markdown file's YAML frontmatter, using yq to parse and ffmpeg to embed.
providers:
  - yq
  - ffmpeg
tags:
  - project/dotfiles
  - domain/scripts/audio
  - pattern/frontmatter
aliases:
  - au-tag
related:
  - "[[01-audio|Audio scripts (au-)]]"
---

# Tag audio from a sidecar `.md` (`au-tag.sh`)

## Overview

Drop a markdown file with YAML frontmatter next to a folder of audio, and `au-tag.sh` writes those fields — plus an album cover — into every `*.mp3` / `*.flac` there. It parses the frontmatter with [`yq`](https://github.com/mikefarah/yq) (`--front-matter=extract`) and embeds with ffmpeg using `-c copy`, so the audio is never re-encoded — only the tag/metadata blocks change.

Pairs with `au-mp3.sh`: convert lossless → MP3, then tag the folder.

## 0. Prerequisites

- `yq` (mikefarah build) — `brew install yq`. Verify: `yq --version`.
- `ffmpeg` — already present (the `au-`/`vid-` scripts use it).
- `imagemagick` (`magick`) — already present; downscales the embedded cover (`-s`). `-s 0` skips it.

## 1. The metadata file

Any `.md` in the folder works (or point at one with `-m`). Only the YAML frontmatter is read; the markdown body is ignored, so the same file can double as liner notes.

```md
---
artist: Boards of Canada
album: Music Has the Right to Children
albumartist: Boards of Canada      # optional; defaults to artist
year: 1998
genre: Electronic
cover: cover.jpg                    # optional; see §3
tracklist:                         # optional; see §2
  - Wildlife Analysis
  - An Eagle in Your Mind
  - The Color of the Fire
---
(liner notes, anything — ignored by the tagger)
```

All fields are optional — only the ones present get written. Album fields apply to **every** file in the folder.

**Folder layout** — `album.md` sits with the audio; the cover goes beside it or in `_assets/`:

```
your-album/
├── album.md                     ← frontmatter = the tags (this file)
├── _assets/
│   └── cover.jpg                ← cover (au-tag checks here too)
├── 01 swerve.mp3
├── 02 no time, sometimes.mp3
└── …
```

au-tag looks for the cover **beside the tracks first** (`cover`/`folder`/`front`/`album`.jpg|png — the music-app convention), **then in `_assets/`**. A real, ready-to-copy example lives at **`_files/au-tag-example/`** — copy the folder, drop your audio in, run `au-tag.sh .`.

## 2. Track titles and numbers

Per-track title/number is resolved in this order:

1. **`tracklist:` array** — entry *i* (in folder sort order) becomes the title of the *i*-th file; track number = *i*+1. Name your files with zero-padded numbers (`01 …`, `02 …`) so the sort matches the list.
2. **Filename** — if there's no tracklist (or fewer entries than files), a leading number is parsed: `01 Wildlife Analysis.mp3` → track `1`, title `Wildlife Analysis`. Separators `space . _ -` are accepted.
3. **`-T`** — skip title/number entirely; existing titles are left untouched (album fields + cover still written).

## 3. Cover art

Resolved in this order: `-c COVER` flag → `cover:` in frontmatter (relative to the `.md`) → auto-detect `cover` / `folder` / `front` / `album` (`.jpg`/`.jpeg`/`.png`) **in the folder, then in `_assets/`**. No cover found is fine — metadata is still written.

The image is embedded as the front cover (mp3: APIC via `-id3v2_version 3`; flac: `-disposition:v attached_pic`), replacing any existing embedded image.

By default the embedded copy is **downscaled to 1000px on the longest side** (`-s`), re-encoded JPEG q88, so a 3500px / 1 MB cover isn't duplicated in full into every track. The shrink applies only to the embedded copy — **your source image is never modified**. `-s 0` embeds at full size; `-s 1500` for a larger embed. Needs imagemagick; if absent, falls back to full-size.

## 4. Run it

```sh
au-mp3.sh -b 320 ~/Music/boc-mhtrtc     # 1. lossless → MP3 (keeps sources)
au-tag.sh ~/Music/boc-mhtrtc            # 2. tag from the folder's .md + cover
```

Other forms:

```sh
au-tag.sh -m notes.md -c art.png .      # explicit metadata file + cover
au-tag.sh -T .                          # album fields + cover only, keep titles
```

Each file is re-muxed (`-c copy`) to a `.autag-tmp.<ext>` and moved over the original — no quality loss.

## 5. Verification

```sh
ffprobe -v error -show_entries format_tags=artist,album,date,genre,track,title \
  -of default=noprint_wrappers=1 "01 Wildlife Analysis.mp3"
# embedded cover present?
ffprobe -v error -select_streams v -show_entries stream=codec_name \
  -of default=noprint_wrappers=1 "01 Wildlife Analysis.mp3"      # → codec_name=mjpeg
```

## Notes & limits

- Non-recursive — tags the files directly in `dir`, not subfolders.
- `tracklist[]` is paired to files by **sort order**, not by matching names; zero-pad track numbers.
- Container support: mp3 + flac get cover art; other formats get metadata only (cover skipped).
- yq's `--front-matter=extract` reads the frontmatter as real YAML, so quoting, types, and arrays behave correctly — no fence-stripping hacks.
