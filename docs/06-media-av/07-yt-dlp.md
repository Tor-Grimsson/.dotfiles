---
title: yt-dlp
type: reference
status: active
updated: 2026-06-20
description: Download video/audio from YouTube, TikTok, and ~1800 other sites. `-x` rips audio-only — the feed for whisper transcription.
aliases:
  - yt-dlp
tags:
  - domain/media/download
  - pattern/cli
  - integration/brew-formula
links:
  website: https://github.com/yt-dlp/yt-dlp
  repo: https://github.com/yt-dlp/yt-dlp
  manual: https://github.com/yt-dlp/yt-dlp#usage-and-options
  brew: https://formulae.brew.sh/formula/yt-dlp
covers:
  - downloading video / audio-only / best quality
  - metadata + caption extraction (--print, --write-info-json, --write-subs)
  - the TikTok → whisper transcript pipeline
related:
  - "[[01-ffmpeg|FFmpeg]]"
  - "[[04-whisper-cpp|whisper.cpp]]"
  - "[[12-download|dl-yt.sh (download wrapper)]]"
---

## Summary
The maintained `youtube-dl` successor. Pulls video or audio from **YouTube, TikTok, and ~1800 sites** — same extractor for all of them, kept current by an active maintainer team (the reason the dozens of single-site scraper repos are dead ends).

One dependency worth stating head-on:

| For | Needs |
|---|---|
| download a single stream | yt-dlp alone |
| merge best video + best audio, or `-x` extract audio | [[01-ffmpeg\|FFmpeg]] (brew, already installed) |
| spoken-word transcript | `-x` audio → [[04-whisper-cpp\|whisper.cpp]] (`whisper-cli`) |

The posted **caption/metadata** (description, uploader, URL, date) comes straight from yt-dlp — no whisper needed. Only the *spoken* transcript needs the whisper hop.

## Use

```sh
yt-dlp <url>                                   # download best video+audio, merged
yt-dlp -x --audio-format mp3 <url>             # audio only → mp3
yt-dlp -f best <url>                           # single best pre-merged stream (no ffmpeg)
yt-dlp -F <url>                                # list available formats
yt-dlp --write-info-json --skip-download <url> # metadata only (caption, uploader, …)
yt-dlp --print "%(title)s — %(uploader)s" <url># pull specific fields to stdout
yt-dlp --write-subs --write-auto-subs <url>    # download subtitles/auto-captions if present
yt-dlp -o "%(title)s.%(ext)s" <url>            # name the output by title
```

## Flags

| Flag | Does |
|---|---|
| `-x` | extract audio only (post-process with ffmpeg) |
| `--audio-format` | mp3/m4a/opus/… for `-x` |
| `-f` / `-F` | pick format / list formats |
| `-o` | output filename template |
| `--write-info-json` | dump all metadata to `.info.json` |
| `--print` | print chosen metadata fields to stdout |
| `--write-subs` / `--write-auto-subs` | download subtitles / auto-captions |
| `--skip-download` | metadata/subs only, no media |
| `-S` | sort/select format quality (`-S "res:1080"`) |

## Why installed
Needed a reliable downloader for media work, and the seed of a **TikTok → markdown** pipeline. yt-dlp is the readymade answer — TikTok-specific tools are abandoned because sites change markup constantly and only yt-dlp keeps pace.

## Biggest win
One command, one tool, ~1800 sites — and `-x` drops straight into the [[04-whisper-cpp|whisper.cpp]] pipeline, the inverse of [[06-edge-tts|edge-tts]] (text→speech).

## Future use
Built: [[au-transcribe|au-transcribe.sh]] — `yt-dlp` grabs the caption + metadata (frontmatter) and the audio, `whisper-cli` transcribes it → a single `.md` note. This is the script that finally wired up [[04-whisper-cpp|whisper.cpp]].

Built: [[12-download|dl-yt.sh]] — a thin **keep-the-file** wrapper. Defaults to best video + best audio merged to **MKV**, because forcing `.mp4` caps audio to AAC and drops the Opus stream; `-a` rips best audio in its native codec, `-m` falls back to MP4 for portability.
