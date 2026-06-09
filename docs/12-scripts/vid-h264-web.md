---
title: Encode to universal H.264 MP4 for the web
type: playbook
status: active
updated: 2026-06-09
audience: internal
description: vid-h264-web.sh — batch re-encode cwd videos to H.264 (libx264, CRF 23) in an .mp4 that plays in every browser. The universal-playback lane of the vid- family; the H.264 twin of the HEVC vid-h265-small-web.sh.
providers:
  - FFmpeg
tags:
  - project/dotfiles
  - domain/scripts/video
aliases:
  - h264-web
  - mp4-for-web
  - web-encode
  - plays-everywhere
related:
  - "[[02-video|Video scripts (vid-)]]"
  - "[[vid-remux-mp4|Rewrap to MP4 (deep-dive)]]"
  - "[[01-ffmpeg|ffmpeg reference]]"
---

# H.264 web encode (`vid-h264-web.sh`)

## Overview

When you need a video to **play in every browser** — Chrome, Firefox, Safari, on
desktop and mobile — the codec is **H.264**. It's the universal baseline; HEVC is
smaller but still only plays on Apple/Safari on the web. `vid-h264-web.sh`
batch-re-encodes the cwd's clips to H.264 (`libx264`) in an `.mp4` with the moov
atom up front, ready to stream.

It is the **H.264 twin of [[02-video|vid-h265-small-web.sh]]**: same goal (a small,
web-ready `.mp4`), different reach/size trade. Pick H.264 here when "plays
everywhere" matters; pick the HEVC script when the audience is Apple and you want
the smallest file.

Quality is **CRF-targeted, not a fixed bitrate** — so a source that's needlessly
fat (a 720p clip carrying a 16 Mbps stream is a real example) is shrunk to a sane
delivery size automatically, while a lean source isn't bloated. It does **not**
rescale; native resolution is kept (reach for [[02-video|vid-convert.sh]] to change
dimensions).

The script is the source of truth (`~/.dotfiles/bin/vid-h264-web.sh`, symlinked
onto `PATH`); this doc is the reference.

## 0. Prerequisites

- [FFmpeg](https://ffmpeg.org) on `PATH` — verify with `ffmpeg -version`. Install via [Homebrew](https://brew.sh): `brew install ffmpeg`. **No VideoToolbox needed** — `libx264` is a software encoder, so this works on any ffmpeg build (unlike the hardware `vid-h265*` scripts).

## 1. Why H.264, not HEVC

The `vid-h265-*` family outputs HEVC: great compression, hardware-accelerated on
the Mac, but on the **web** only Safari plays it. Ship an HEVC `.mp4` to a Chrome
or Firefox user and they get a blank player. H.264:

- **plays everywhere** — every browser, every phone, every embed, going back years;
- is the safe default for `<video>` on a public page;
- costs ~20–30% more bytes than HEVC at the same quality — the price of reach.

So the rule of thumb: **public/unknown audience → H.264** (`vid-h264-web.sh`);
**Apple-only audience, bytes tight → HEVC** ([[02-video|vid-h265-small-web.sh]]).

## 2. Why CRF, not a target bitrate

The HEVC web/delivery scripts pin a bitrate (`-b:v 12M`). This one uses **CRF
(Constant Rate Factor)** instead: you ask for a *quality level* and x264 spends
exactly the bits that quality needs, frame by frame.

- A bloated source shrinks hard (the bits were wasted); a complex source keeps the
  bits it genuinely needs. Either way you get consistent *quality*, not a fixed size.
- **CRF 23** is the libx264 default and a solid web baseline. Lower = better/bigger,
  higher = smaller/worse; sane web range is ~20–26. Override with `-q`.

```sh
vid-h264-web.sh         # CRF 23
vid-h264-web.sh -q 21   # a touch more quality, larger files
vid-h264-web.sh -q 26   # smaller, for bandwidth-sensitive delivery
```

## 3. The core one-liner

```sh
# re-encode any source to universal, web-ready H.264 .mp4
ffmpeg -i input.mp4 \
  -c:v libx264 -crf 23 -preset medium -pix_fmt yuv420p \
  -movflags +faststart \
  -c:a aac -b:a 128k \
  input_web.mp4
```

- `-c:v libx264` — the universal H.264 encoder (vs the family's HEVC).
- `-crf 23` — quality target; shrinks an over-fat source to a sane delivery size.
- `-preset medium` — speed/efficiency balance for a one-time delivery encode
  (slower presets = smaller files for more CPU; `medium` is the sweet spot here).
- `-pix_fmt yuv420p` — 8-bit 4:2:0, the chroma format every player accepts. Sources
  in 4:2:2/4:4:4 or 10-bit would otherwise produce a file some browsers refuse.
- `-movflags +faststart` — moves the `moov` atom to the front so the file streams
  from the first byte instead of needing a full download to start.
- `-c:a aac -b:a 128k` — re-encode audio to web-sized AAC stereo.

## 4. The script

The batch form lives at `bin/vid-h264-web.sh`. No positional arguments — `cd` into
the folder and run; it globs the clips and writes a `_web.mp4` sibling for each.

```sh
cd ~/footage && vid-h264-web.sh
```

- **Globs** `*.mov *.mp4 *.mxf *.avi` (case-insensitive, so `.MOV`/`.MP4` match).
  Unlike `vid-remux-mp4.sh`, it **does** glob `.mp4` — its whole job is shrinking fat
  mp4s — but it **skips any input named `*_web.mp4`** so a re-run never produces
  `*_web_web.mp4`.
- **Output** `<name>_web.mp4` next to each source. An existing `<name>_web.mp4` is
  **left untouched** (APFS is case-insensitive, so `.MP4` counts) — re-runs are safe
  and skip what's done.
- **`-q <crf>`** overrides the CRF for the whole batch.
- Per file it prints the ffmpeg progress, or `skip: <name>_web.mp4 already exists`.

## 5. Verification

- CLI: in a folder of clips, `vid-h264-web.sh` writes one `<name>_web.mp4` per
  source; a fat source comes out dramatically smaller (the CRF shrink), a lean one
  stays close.
- Streams: `ffprobe -v error -show_entries stream=index,codec_type,codec_name,pix_fmt -of compact <out>_web.mp4`
  shows `video` `h264` `yuv420p` + `audio` `aac`.
- Faststart: `ffprobe -v trace <out>_web.mp4 2>&1 | grep -m1 moov` appears before the
  `mdat` data — proof the moov atom is at the front for streaming.
- Idempotent: run it twice — the second run prints
  `skip: <name>_web.mp4 already exists` for every file and re-encodes nothing.
- Self-output guard: with a `<name>_web.mp4` already present, the glob picks it up but
  the `*_web.mp4` skip means no `<name>_web_web.mp4` is ever produced.
