---
title: Video frame → image (and Quick Action)
type: playbook
status: active
updated: 2026-07-02
audience: internal
description: img-from-video.sh — grab a single frame from a video by frame number or timestamp via ffmpeg, output JPG/PNG via ImageMagick, then wire it into a Finder right-click Quick Action.
providers:
  - ffmpeg
  - ImageMagick
  - Automator
tags:
  - project/dotfiles
  - domain/scripts/image
  - domain/macos
  - pattern/quick-action
aliases:
  - video-to-image
  - video-frame-grab
  - frame-from-video
related:
  - "[[03-image|Image scripts (img-)]]"
  - "[[img-convert|Any image → JPG/PNG (deep-dive + Quick Action)]]"
  - "[[img-from-psd|PSD → image (deep-dive + Quick Action)]]"
  - "[[10-quick-actions|Quick Actions (qa-)]]"
---

# Video frame → image (`img-from-video.sh`) + Quick Action

## Overview

Same shape as [[img-from-psd|img-from-psd.sh]] — a non-image source in, a JPG/PNG
out — but the source is a video, so the first step is a decode, not a read.
**ImageMagick's own video delegate is unreliable** (it shells out through a
fragile `ffmpeg → rawvideo` pipeline that errors on encode on this machine), so
this script calls **`ffmpeg` directly** to seek to a timestamp and decode exactly
one frame to a temp PNG, then hands that off to the same `magick` resize/format
pass every other `img-` script uses.

The script is the source of truth (`~/.dotfiles/bin/img-from-video.sh`,
symlinked onto `PATH`); this doc is the reference.

> Same Automator gotcha as every image action: it runs with a **bare PATH**, so
> neither `ffmpeg` nor `magick` is visible unless you export `PATH` inside the
> action (see §4).

## 0. Prerequisites

- [ffmpeg](https://ffmpeg.org) on `PATH` — verify with `ffmpeg -version`. Install via [Homebrew](https://brew.sh): `brew install ffmpeg`. (Already a dependency of the `vid-`/`au-` families — almost certainly already installed.)
- [ImageMagick](https://imagemagick.org) on `PATH` — verify with `magick -version`.
- macOS with **Automator** (built in) for the Quick Action.

## 1. The core two-step

```sh
# 1. decode one frame at a timestamp to a temp PNG
ffmpeg -ss 00:00:05 -i input.mp4 -vframes 1 /tmp/frame.png

# 2. resize/format it, same as any other img- script
magick /tmp/frame.png -resize 1600x2000 -background white -flatten \
  -quality 90 -colorspace sRGB -depth 8 output.jpg
```

`-ss` **before** `-i` is a fast seek (jumps to the nearest keyframe, then decodes
forward) — much quicker than seeking after `-i` on a long file. `-vframes 1`
stops after exactly one frame so ffmpeg doesn't decode the whole file.

## 2. The script

The reusable form lives at `bin/img-from-video.sh` — batch input, format/
timestamp/resize/quality/outdir flags, and `--help`. Run
`img-from-video.sh --help` for the full contract; catalog entry in
[[03-image|Image scripts]].

```sh
img-from-video.sh clip.mp4                      # → clip.jpg, frame 1, full size
img-from-video.sh -t 23 clip.mp4                # → clip.jpg, the 23rd frame
img-from-video.sh -t 00:00:05 clip.mp4          # → clip.jpg, frame at 5s
img-from-video.sh -f png -r 1600x2000 clip.mov  # → clip.png, resized
img-from-video.sh -o out -q 92 *.mp4            # batch into ./out at quality 92
```

**No frame given → frame 1.** `-t` defaults to `1`, so the plain one-arg form
always grabs the first frame.

## 3. Frame number vs. timestamp, and resize

`-t` accepts **two different forms**, auto-detected by shape:

| Form | Meaning | Mechanism |
|---|---|---|
| bare integer (`23`) | frame **number**, 1-based | ffmpeg `select=eq(n\,N-1)` — decodes from the start counting frames. Exact, but slower deep into a long video (no keyframe jump). |
| `HH:MM:SS` or decimal (`5.5`) | **timestamp** | ffmpeg `-ss` — fast-seeks to the nearest keyframe first, then decodes forward. Quick, but can land on the nearest keyframe rather than the exact frame for that instant. |

Pick frame-number mode when you need an exact, specific frame (e.g. a
Remotion/After Effects export where you know the frame index); pick timestamp
mode for "somewhere around N seconds in" on a longer file, where the speed of
a keyframe-seek matters more than frame-exactness.

`-r` takes the same ImageMagick geometry every other `img-` script uses — see
[[img-convert|img-convert.sh]] §3 for the full table (fit / fill / force-exact
/ shrink-only).

```sh
img-from-video.sh -t 23 clip.mp4          # the 23rd frame, exactly
img-from-video.sh -t 90 clip.mp4          # WRONG if you meant 90 seconds — bare
                                           # integers are always a frame number
img-from-video.sh -t 00:01:30 clip.mp4    # 90 seconds in, HH:MM:SS form
img-from-video.sh -t 90.0 clip.mp4        # 90 seconds in — the decimal point
                                           # is what makes it a timestamp
img-from-video.sh -r 1920x1080^ clip.mp4  # cover-fill 1920×1080 (may crop)
```

**Plain `-r WxH` doesn't guarantee exact output dimensions** — it's fit-inside,
so a video whose aspect ratio doesn't exactly match the target can land short
on one axis (a 9:16 phone clip into `1600x2000` lands at 1125×2000, way under
on width, since the video is much narrower than 4:5). Pass **`-e`** to force
the literal `WxH` you asked for, center-crop/pad as needed:

```sh
img-from-video.sh -r 1600x2000 -e clip.mp4   # exactly 1600x2000, guaranteed
```

Same mechanism as [[img-convert|img-convert.sh]]'s `-e` — see its §3 for the
full explanation of why fit-inside can miss the target and what `-e` does
about it.

## 4. Wire it into a Finder Quick Action

The generic recipe (and `qa-make.sh` to stamp one from a single line) is in
[[10-quick-actions|Quick Actions]]. The PATH export lists **both** brew prefixes
so the action works on the Intel iMac (`/usr/local`) *and* the Apple-Silicon
MBP (`/opt/homebrew`) — the absent one is just an ignored PATH entry.

```sh
qa-make.sh -t public.movie "Grab first frame → JPG" \
  'export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"; "$HOME/.dotfiles/bin/img-from-video.sh" "$@"'
```

## 5. Verification

- CLI: `img-from-video.sh clip.mp4` prints `clip.mp4 [1] -> clip.jpg`, and `magick identify clip.jpg` reports a real frame's dimensions.
- Frame number: `img-from-video.sh -t 23 clip.mp4` prints `clip.mp4 [23] -> clip.jpg`, visibly different content than frame 1 (spot-check by opening both).
- Timestamp: `img-from-video.sh -t 00:00:05 clip.mp4` decodes visibly different content than the frame-1 default (spot-check by opening both).
- Out-of-range: `img-from-video.sh -t 999999 clip.mp4` on a short clip prints a clear `error: no frame at 999999 in … (past end of video?)` instead of a cryptic ImageMagick failure.
- Exact dimensions: `img-from-video.sh -r 1600x2000 -e clip.mp4`; `magick identify -format "%wx%h" clip.jpg` reports exactly `1600x2000` regardless of the source's native aspect ratio.
- PATH sanity: if the Quick Action silently does nothing, run the same body in Terminal — `ffmpeg: command not found` or `magick: command not found` confirms the PATH export (§4) is missing.

## Don't quantize the output

A video frame is photographic — gradients, sensor noise, compression
artifacts. [[img-convert|img-convert.sh]]'s `-c` palette quantization is built
for flat graphics/illustrations; run it on a video frame and you'll get visible
banding. If the frame needs to shrink further, use `img-convert.sh -q` (jpg) or
just `-r` a smaller size — not `-c`.
