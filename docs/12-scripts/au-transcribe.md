---
title: Transcribe media to a markdown note
type: playbook
status: active
updated: 2026-06-10
audience: internal
description: au-transcribe.sh — fetch a video/audio URL (yt-dlp) or read a local media file, extract 16 kHz audio with ffmpeg, transcribe with whisper.cpp, and write a markdown note (metadata + caption frontmatter, spoken transcript body).
providers:
  - yt-dlp
  - ffmpeg
  - whisper-cli
  - jq
tags:
  - project/dotfiles
  - domain/scripts/audio
  - pattern/pipeline
aliases:
  - au-transcribe
related:
  - "[[01-audio|Audio scripts (au-)]]"
  - "[[02-video|Video scripts (vid-)]]"
  - "[[07-yt-dlp|yt-dlp]]"
  - "[[04-whisper-cpp|whisper.cpp]]"
---

# Transcribe media to a markdown note (`au-transcribe.sh`)

## Overview

Hand it a TikTok/YouTube URL (or any of yt-dlp's ~1800 sites), or a local media file, and it writes a single markdown note: the posted **caption + metadata as frontmatter**, the **spoken transcript as the body**. It is the wiring that finally puts [whisper.cpp](../06-media-av/04-whisper-cpp.md) to work.

The pipeline is four hops, each a tool already in the `Brewfile`:

```
URL ──yt-dlp──▶ audio + .info.json ──ffmpeg──▶ 16 kHz mono wav ──whisper-cli──▶ text ──▶ <slug>.md
        (local file skips yt-dlp; ffmpeg reads it directly)
```

The **caption** comes straight from yt-dlp metadata — no speech recognition. Only the **spoken transcript** runs through whisper, so the cheap text (title, uploader, description) is always exact and only the expensive part is ASR.

## 0. Prerequisites

- `ffmpeg`, `jq`, `whisper-cli` (the `whisper-cpp` formula) — already in the `Brewfile`.
- `yt-dlp` — only for URL inputs; a local file doesn't need it.
- A whisper **model file** — fetched automatically on first run (see §3); no manual step.

## 1. What it produces

One `<slug>.md` per input, named from a kebab-cased title (clobber-safe — a second run appends `-2`, `-3`). A real run on a 28-second TikTok — full file at [_files/au-transcribe-example.md](_files/au-transcribe-example.md):

```md
---
title: "DISTORTION EFFECT w Three.js #webdesign #webdevelopment #3d"
source: https://www.tiktok.com/@malik.code/video/7637871728068185366?lang=en
platform: TikTok
uploader: "malik.code"
published: 2026-05-09
duration: 28
transcribed: 2026-06-10
model: ggml-base
tags:
  - transcript
---

# DISTORTION EFFECT w Three.js #webdesign #webdevelopment #3d

## Transcript

how to create a text distortion effect with 3JS. Text gets drawn onto a hidden
canvas. That canvas becomes a flat surface, your shader can manipulate. …
```

When the **caption differs from the title** (most YouTube videos), a `## Caption` section is inserted before the transcript with the posted description. Local-file inputs have no `source`/`platform`/`uploader`/`published`/caption — just the title (the filename), `transcribed`, `model`, and the transcript.

## 2. Run it

```sh
au-transcribe.sh https://www.tiktok.com/@user/video/123          # TikTok → ./how-to-….md
au-transcribe.sh https://youtu.be/dQw4w9WgXcQ                    # YouTube
au-transcribe.sh -o ~/Notes/transcripts talk.mp4                 # local file → a notes folder
au-transcribe.sh https://youtu.be/a https://youtu.be/b           # batch; one .md each
au-transcribe.sh -k lecture.m4a                                  # also keep the extracted .wav
```

Options: `-m MODEL` · `-l LANG` · `-o OUTDIR` · `-k` keep the wav · `-h` help. Each input that fails (dead URL, unreadable file) is reported and **skipped**; the rest still run, and the exit status is non-zero if any skipped.

## 3. Choosing a model (`-m`)

whisper.cpp models are GGML `.bin` files. The first time a given model is used, the script downloads it once to `$WHISPER_MODEL_DIR` (default `~/.cache/whisper`) — no manual fetch.

| Model | Size | Notes |
|---|---|---|
| `tiny` | ~75 MB | fastest, roughest |
| `base` *(default)* | ~142 MB | fast, multilingual — fine for notes |
| `small` | ~466 MB | noticeably better |
| `medium` | ~1.5 GB | better still, slower |
| `large-v3` | ~3 GB | best, slowest |
| `*.en` | — | English-only variants (e.g. `base.en`) — faster/better *if* the audio is English |

```sh
au-transcribe.sh -m small.en https://youtu.be/…    # English lecture, better accuracy
```

Override the download host with `$WHISPER_MODEL_URL_BASE` if Hugging Face is blocked.

## 4. Language (`-l`)

Default `auto` lets whisper detect the spoken language. Pin it for accuracy (and to skip detection): `-l en`, `-l is` (Icelandic), etc. A `*.en` model ignores `-l` — it's English-only.

## 5. Verification

```sh
say "the quick brown fox" -o /tmp/t.aiff          # make a tiny test clip (macOS)
au-transcribe.sh -m tiny -o /tmp /tmp/t.aiff       # transcribe it
cat /tmp/the-quick-brown-fox.md                    # frontmatter + transcript present?
```

A real URL run: confirm the `.md` lands in `-o` (or cwd), the frontmatter carries `source`/`uploader`/`published`, and the `## Transcript` body is non-empty.

## Notes & limits

- **Audio quality caps accuracy.** Music, heavy effects, or crosstalk degrade the transcript — whisper is speech-tuned. Bump `-m` before assuming a bug.
- **The first run is slow.** Model download (once) + whisper's ~10 s Metal warm-up. Subsequent runs reuse the cached model.
- **Caption vs. transcript are independent.** A silent clip still gets its caption/metadata note (transcript body shows `_(no speech detected)_`).
- **The `## Caption` block is omitted when the caption is identical to the title** — common on TikTok, where the caption *is* the title, so the note doesn't repeat it.
- **Backend noise on stderr** (`ggml_metal_…`, `load_backend…`) is whisper.cpp starting up, not an error — the script keeps it off stdout.
- yt-dlp uses `-f bestaudio/best`, so sites without an audio-only stream (TikTok, Instagram) download the video and ffmpeg pulls the audio out.
