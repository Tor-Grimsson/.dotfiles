---
title: Rewrap H.264/HEVC → MP4 without re-encoding
type: playbook
status: active
updated: 2026-06-08
audience: internal
description: vid-remux-mp4.sh — batch stream-copy footage that's already H.264/HEVC out of .mov/.mkv/.avi/… into an .mp4 container. Lossless, seconds per file; only incompatible audio (PCM/Opus/…) is re-encoded to AAC.
providers:
  - FFmpeg
tags:
  - project/dotfiles
  - domain/scripts/video
aliases:
  - mov-to-mp4
  - mov2mp4
  - rewrap-to-mp4
  - video-remux
related:
  - "[[02-video|Video scripts (vid-)]]"
  - "[[01-ffmpeg|ffmpeg reference]]"
---

# Rewrap to MP4 (`vid-remux-mp4.sh`)

## Overview

When footage is **already H.264 or HEVC** but lives in the wrong container — a
`.mov` from After Effects, a `.mkv` download, a camera `.ts` — you don't need to
transcode it to get an `.mp4`. The video stream is fine; only the wrapper is
wrong. `vid-remux-mp4.sh` **stream-copies** (`-c:v copy`) each clip into a fresh
`.mp4`: lossless, no quality hit, and seconds per file instead of the minutes-to-
hours a real encode costs.

It only re-encodes when it has to: an audio codec MP4 can't carry (PCM, Opus,
Vorbis, FLAC) is dropped to **AAC 256k** — the video still copies. A *video*
codec that can't sit in MP4 (ProRes, VP9, MPEG-2, DNxHD) is **skipped with a
reason**, not silently mangled — that case wants a real transcode
([[02-video|vid-h265-small-web.sh / vid-convert.sh]]).

The script is the source of truth (`~/.dotfiles/bin/vid-remux-mp4.sh`, symlinked
onto `PATH`); this doc is the reference.

## 0. Prerequisites

- [FFmpeg](https://ffmpeg.org) on `PATH` (provides both `ffmpeg` and `ffprobe`) — verify with `ffmpeg -version`. Install via [Homebrew](https://brew.sh): `brew install ffmpeg`. **No VideoToolbox needed** — nothing is encoded on the video side, so this works on any ffmpeg build.

## 1. Why remux, not re-encode

Re-encoding H.264 footage to "make an mp4" is the common mistake. The codec MP4
wants *is* H.264/HEVC — the bytes are already correct. Transcoding them:

- **loses quality** — every re-encode is generation loss, even at a high bitrate;
- **burns time + CPU** — minutes to hours vs. the disk-speed copy a remux runs at;
- can **downgrade reach** — e.g. the `vid-h265-*` family outputs HEVC, which isn't
  the universal-playback codec H.264 is.

A remux sidesteps all three: same stream, new box. Reach for a real encode only
when you actually need to *change* the video — shrink it, rescale it, or convert a
codec MP4 can't hold.

## 2. The core one-liner

```sh
# rewrap an H.264 .mov into .mp4, lossless, audio copied
ffmpeg -i input.mov -map 0:v:0 -map 0:a:0\? -c:v copy -c:a copy \
  -write_tmcd 0 -movflags +faststart output.mp4
```

- `-c:v copy` — the whole point: the video stream is *copied*, not decoded/re-encoded.
- `-map 0:v:0 -map 0:a:0?` — keep only the first video + (optional) first audio
  stream. AE `.mov` exports often carry a **data/timecode track** that a blind
  `-c copy` tries to copy into MP4 and chokes on (`Could not find tag for codec tmcd`).
- `-write_tmcd 0` — separately, the MP4 muxer will *auto-generate* a `tmcd` timecode
  track from the video stream's metadata; this stops it, so the output is truly
  video+audio only.
- `-movflags +faststart` — moves the `moov` atom to the front so the file streams
  from the first byte (web playback).
- For HEVC sources add `-tag:v hvc1` so QuickTime recognises the stream.

## 3. The script

The batch form lives at `bin/vid-remux-mp4.sh`. No arguments — `cd` into the
folder and run; it globs every non-mp4 container and writes a `.mp4` sibling.

```sh
cd ~/ae-export && vid-remux-mp4.sh
```

- **Globs** `*.mov *.mkv *.avi *.mxf *.ts` (case-insensitive, so `.MOV` matches).
  `.mp4` is intentionally **not** globbed — rewrapping mp4-into-mp4 is pointless.
- **Output** `<name>.mp4` next to each source. An existing `<name>.mp4` is **left
  untouched** (and APFS is case-insensitive, so `.MP4` counts as existing) — re-runs
  are safe and skip what's done.
- Per file it prints `→ <name>.mp4` on success, `skip: …` (already exists / can't
  copy), or `fail: …`.

## 4. The codec decision table

The script probes each file with `ffprobe` and branches:

| Stream | Codec found | Action |
|---|---|---|
| Video | `h264` | `-c:v copy` |
| Video | `hevc` | `-c:v copy -tag:v hvc1` |
| Video | anything else (prores, vp9, mpeg2, dnxhd…) | **skip file**, print reason |
| Audio | `aac` / `ac3` / `eac3` / `mp3` / `alac` / none | `-c:a copy` |
| Audio | anything else (`pcm_*`, opus, vorbis, flac…) | `-c:a aac -b:a 256k` |

So a PCM-audio `.mov` (common in masters) still **copies its video** and only pays
a cheap AAC pass on the audio — the file shrinks because PCM is bloated, not
because the picture was touched.

## 5. Verification

- CLI: in a folder of H.264 `.mov`s, `vid-remux-mp4.sh` prints one `→ <name>.mp4`
  per file; each output is within a few KB of its source (container overhead only —
  proof the video was copied, not re-encoded).
- Streams: `ffprobe -v error -show_entries stream=index,codec_type,codec_name -of compact <out>.mp4`
  shows exactly `video` (h264/hevc) + `audio` (aac) — **no `data` track**.
- PCM source: an input with `pcm_s16le`/`pcm_s24le` audio comes out smaller, with
  `codec_name=aac` on the audio stream and an unchanged video bitrate.
- Skip path: drop a ProRes/VP9 file in the folder → it prints
  `skip: … video is 'prores', can't stream-copy to mp4` and writes nothing.
- Idempotent: run it twice — the second run prints `skip: <name>.mp4 already exists`
  for every file and re-encodes nothing.
