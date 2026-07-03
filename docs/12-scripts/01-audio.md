---
title: Audio scripts
type: reference
status: active
updated: 2026-06-10
description: au-* — audio conversion, tagging + transcription helpers.
tags:
  - project/dotfiles
  - domain/scripts/audio
related:
  - "[[au-tag|Tag audio from a sidecar .md (deep-dive)]]"
  - "[[au-transcribe|Transcribe media to markdown (deep-dive)]]"
---

# Audio (`au-`)

| Script | Does | Usage |
|--------|------|-------|
| `au-flac.sh` | Recursively convert `*.wav` / `*.aif` / `*.aiff` → FLAC (compression 8), parallel (`-P 6`), **deletes source** on success | `au-flac.sh [dir]` (default `.`) |
| `au-mp3.sh` | Recursively convert `*.wav` / `*.aif` / `*.aiff` → MP3 (CBR `-b` 128/160/192/320, default 320), parallel, **keeps source** | `au-mp3.sh [-b 320] [dir]` (default `.`) |
| `au-tag.sh` | Write album metadata + cover art into `*.mp3` / `*.flac` from a sidecar `.md` frontmatter (yq); embeds a lean downscaled cover | `au-tag.sh [-m md] [-c cover] [-s px] [-T] [dir]` |
| `au-transcribe.sh` | Video/audio **URL** (yt-dlp) or local media → markdown note: caption + metadata frontmatter, whisper transcript body | `au-transcribe.sh [-m model] [-l lang] [-o dir] [-k] <url\|file>…` |

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

## `au-mp3.sh`

Recursively transcodes WAV/AIF/AIFF to MP3 via ffmpeg + libmp3lame at a constant bitrate. Mirrors `au-flac.sh` but **keeps the source** — MP3 is lossy, so deleting the lossless original would be data loss.

**Usage** — `au-mp3.sh [-b 128|160|192|320] [dir]`; bitrate defaults to 320, `dir` to `.` (recursive).

**Args**
- `-b` — CBR bitrate in kbps: 128 / 160 / 192 / 320 (default 320).
- `[dir]` — root to walk; `*.wav`/`*.aif`/`*.aiff` case-insensitive.
- `-h`, `--help`.

**What it does**
- `foo.wav` → sibling `foo.mp3` (`-c:a libmp3lame -b:a Nk`); up to 6 jobs (`xargs -P 6`, `-nostdin`); overwrites a same-named mp3 (`-y`); **source untouched**.

**Example** — `au-mp3.sh -b 192 ~/Music/album` writes 192 kbps MP3s beside the originals.

**Dependency** — `ffmpeg` (libmp3lame, the default build). **Next:** `au-tag.sh` for tags + cover art.

## `au-tag.sh`

Writes album metadata + an embedded front cover into every `*.mp3` / `*.flac` in a folder, read from a sidecar `.md`'s YAML frontmatter (via `yq`) and applied with ffmpeg (`-c copy`, no re-encode). Per-track titles come from a `tracklist:` array, else the filename. **Full frontmatter contract + workflow: [the deep-dive](au-tag.md).**

**Usage** — `au-tag.sh [-m FILE.md] [-c COVER] [-T] [dir]`; default `.md` is the first in the folder, default `dir` is `.`.

**Args**
- `-m` — metadata `.md` (default: first `*.md` in the folder).
- `-c` — cover image (default: `cover:` in frontmatter, else `cover`/`folder`/`front`/`album`.{jpg,png} in the folder or its `_assets/`).
- `-s` — downscale the embedded cover to N px longest side (default 1000; `0` = embed as-is). Source file untouched.
- `-T` — don't set per-track title/number (leave existing titles).
- `-h`, `--help`.

**Dependencies** — `yq` (frontmatter) + `ffmpeg` (tagging/embedding) + `imagemagick` (cover downscale; only when `-s` > 0).

## `au-transcribe.sh`

Fetches a video/audio **URL** with [yt-dlp](../06-media-av/07-yt-dlp.md) (YouTube, TikTok + ~1800 sites) or reads a **local media file**, extracts 16 kHz mono audio with ffmpeg, transcribes it with [whisper.cpp](../06-media-av/04-whisper-cpp.md) (`whisper-cli`), and writes one `<slug>.md` per input — YAML frontmatter (title, source, uploader, published, duration, model) + the posted caption + the spoken transcript. The unusual member of the family: it takes a URL or single file, not a folder, and emits markdown rather than audio. **Full write-up: [the deep-dive](au-transcribe.md).**

**Usage** — `au-transcribe.sh [-m MODEL] [-l LANG] [-o OUTDIR] [-k] <url|file>…`.

**Args**
- `-m` — whisper model (default `base`; `tiny`/`small`/`medium`/`large-v3`, `.en` for English-only). Downloaded once to `~/.cache/whisper`.
- `-l` — spoken-language hint (default `auto`); e.g. `-l en`, `-l is`.
- `-o` — output directory for the `.md` (default `.`).
- `-k` — keep the extracted `.wav` beside the note.
- `-h`, `--help`.

**Dependencies** — `ffmpeg` + `whisper-cli` (`whisper-cpp`) + `jq`, plus `yt-dlp` for URLs. The caption is read from yt-dlp metadata (no ASR); only the spoken audio runs through whisper.
