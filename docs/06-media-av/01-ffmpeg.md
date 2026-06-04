---
title: FFmpeg
type: reference
status: active
updated: 2026-06-04
description: Command-line engine for decoding, encoding, transcoding, muxing, filtering, and streaming audio and video.
aliases:
  - ffmpeg
  - ffprobe
tags:
  - domain/media/transcoder
  - pattern/cli
  - integration/brew-formula
links:
  website: https://ffmpeg.org/
  repo: https://github.com/FFmpeg/FFmpeg
  manual: https://ffmpeg.org/documentation.html
  brew: https://formulae.brew.sh/formula/ffmpeg
covers:
  - Transcoding and container remuxing
  - Stream extraction, trimming, and concatenation
  - Filtergraphs (scale, crop, overlay, audio normalize)
  - Probing media with ffprobe
related:
  - "[[02-mpv|mpv]]"
  - "[[03-handbrake|HandBrake]]"
---

## Summary
FFmpeg is the universal command-line toolkit for working with audio and video. It reads almost any container or codec, applies filters, and writes back out to almost any target format. It ships the `ffmpeg` transcoder and the `ffprobe` inspector, and is the decode/encode backbone that countless other media tools link against.

## Why installed
It is the one media primitive that everything else leans on — `mpv` depends on it to decode, `yt-dlp` shells out to it for merging streams, and it is the go-to for any one-off "convert / trim / extract / fix this file" task that a GUI would make slower. Having it on the path means no media problem requires hunting for a single-purpose app.

## Most common use case
Transcoding or remuxing a single file — pulling audio out, changing container, or re-encoding to H.264/H.265 for compatibility.

## Biggest win
Total format coverage in one binary. There is essentially no audio/video container, codec, or stream operation it cannot perform, and it scripts cleanly — so a batch job over a folder of files is a one-line shell loop, not a manual GUI grind.

## How to use
```sh
# Inspect a file (streams, codecs, duration, bitrate)
ffprobe input.mkv

# Remux without re-encoding (fast, lossless container swap)
ffmpeg -i input.mkv -c copy output.mp4

# Re-encode to H.264 + AAC with a sane quality target
ffmpeg -i input.mov -c:v libx264 -crf 20 -preset slow -c:a aac -b:a 192k output.mp4

# Extract audio only
ffmpeg -i input.mp4 -vn -c:a copy audio.m4a

# Trim a clip without re-encoding (from 00:01:30, 45 seconds long)
ffmpeg -ss 00:01:30 -i input.mp4 -t 45 -c copy clip.mp4

# Scale to 720p height, keep aspect ratio
ffmpeg -i input.mp4 -vf "scale=-2:720" output.mp4

# Grab a single frame as a poster image
ffmpeg -ss 00:00:05 -i input.mp4 -frames:v 1 poster.jpg
```

## Future use
Worth adopting: hardware-accelerated encoding via VideoToolbox (`-c:v h264_videotoolbox` / `hevc_videotoolbox`) on Apple Silicon for much faster transcodes, and the `loudnorm` filter for broadcast-style audio loudness normalization in batch publication workflows.
