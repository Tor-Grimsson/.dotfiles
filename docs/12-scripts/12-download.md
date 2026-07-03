---
title: Download scripts
type: reference
status: active
updated: 2026-06-20
description: dl-* — fetch media from a URL at highest quality (yt-dlp). Keeps the best audio by defaulting to MKV instead of capping it to AAC in MP4.
tags:
  - project/dotfiles
  - domain/scripts/download
related:
  - "[[07-yt-dlp|yt-dlp]]"
  - "[[01-audio|Audio scripts (au-)]]"
  - "[[02-video|Video scripts (vid-)]]"
  - "[[au-transcribe|Transcribe a URL/file to markdown (deep-dive)]]"
---

# Download (`dl-`)

These **fetch** media from a URL — the counterpart to the `au-`/`vid-` families,
which *process* files you already have. The engine is [yt-dlp](../06-media-av/07-yt-dlp.md)
(YouTube, TikTok + ~1800 sites); `ffmpeg` does the merge/extract.

Not to be confused with [au-transcribe.sh](au-transcribe.md), which also pulls a URL
but only to throw audio at whisper — it keeps no media. `dl-` is for **keeping** the file.

## `dl-yt.sh` — download at highest quality

```sh
dl-yt.sh https://youtu.be/dQw4w9WgXcQ            # best video + best audio → .mkv
dl-yt.sh -a https://youtu.be/dQw4w9WgXcQ         # best audio only (Opus/m4a, no transcode)
dl-yt.sh -m https://youtu.be/dQw4w9WgXcQ         # best MP4 (audio capped to AAC)
dl-yt.sh -o ~/Desktop https://a https://b        # batch, into a directory
dl-yt.sh -c firefox https://youtu.be/gated        # login/age-gated → browser cookies
```

### The MKV default is deliberate — it's how you keep the best audio

YouTube's top audio stream is **Opus ~160k**, and **MP4 cannot hold Opus**. Forcing
`.mp4` silently drops audio to the best AAC stream (m4a, ~128k). So the default
container is **MKV** (`bv*+ba/b` → `--merge-output-format mkv`), which accepts the
genuine best audio and best video (vp9/av1/h264) with no re-encode. MKV plays in
mpv/VLC; reach for `-m` only when a target player can't handle it.

| Mode | Flag | Selector | Audio you get |
|---|---|---|---|
| Video *(default)* | — | `bv*+ba/b` → MKV | best available (Opus survives) |
| MP4 | `-m` | `-S res,ext:mp4:m4a` → MP4 | best **AAC** (m4a) — portable, not highest |
| Audio only | `-a` | `bestaudio/best -x --audio-quality 0` | best stream, **native codec, no transcode** |

`-a` overrides `-m` (audio-only has no video container to choose). For full control,
`-f` passes a raw yt-dlp format selector straight through, keeping the mode's container
(e.g. `dl-yt.sh -f "bv*[height<=720]+ba" <url>`).

### Options

`-a` audio only · `-m` MP4 instead of MKV · `-o DIR` output dir (default cwd) ·
`-f FMT` raw yt-dlp `-f` passthrough · `-c BROWSER` cookies for gated URLs · `-h` help.

Filenames come from `%(title)s`; `--no-overwrites` makes re-runs idempotent, and
`--no-playlist` means a "watch?v=…&list=…" URL grabs the one video, not the playlist.

## 0. Prerequisites

- `yt-dlp` + `ffmpeg` — both in the `Brewfile`. ffmpeg does the merge (video mode) and
  the audio extract (`-a`); yt-dlp alone can't mux the separate best streams.

## Verification

```sh
dl-yt.sh -a -o /tmp "https://youtu.be/<id>"        # pull best audio
ffprobe -v error -select_streams a:0 \
  -show_entries stream=codec_name,sample_rate \
  -of default=noprint_wrappers=1 /tmp/*.opus        # → codec_name=opus, sample_rate=48000
```

A real `-a` run on a YouTube music video resolved format **251 (Opus, 48 kHz)** and
extracted it with no transcode — confirming the highest-audio path.

## Notes & limits

- **Highest audio ≠ MP4.** Keep the MKV default for archival/listening; `-m` is the
  compatibility escape hatch, and it *does* cost audio quality. Stated loudly because
  it's the whole reason this script exists over a bare `yt-dlp <url>`.
- **No re-encode anywhere.** Video mode merges streams as-is; `-a` keeps the native
  codec. Nothing here transcodes — for that, hand the output to the `vid-`/`au-` families.
- Sites without a separate audio stream (some TikTok/IG) just download the muxed file;
  `-a` then extracts its audio.
