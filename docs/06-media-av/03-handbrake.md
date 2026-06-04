---
title: HandBrake
type: reference
status: active
updated: 2026-06-04
description: Open-source video transcoder with tuned presets, exposed on the command line as HandBrakeCLI.
aliases:
  - HandBrakeCLI
  - handbrake
tags:
  - domain/media/transcoder
  - pattern/cli
  - integration/brew-formula
links:
  website: https://handbrake.fr/
  repo: https://github.com/HandBrake/HandBrake
  manual: https://handbrake.fr/docs/en/latest/
  brew: https://formulae.brew.sh/formula/handbrake
covers:
  - Preset-driven video transcoding
  - Batch encoding of a folder of files
  - Device-targeted and resolution presets
  - Listing and applying built-in presets
related:
  - "[[01-ffmpeg|FFmpeg]]"
---

## Summary
HandBrake is a video transcoder built on top of the same encoders FFmpeg uses, but wrapped in carefully tuned presets that hide the codec-tweaking knobs. The brew formula installs `HandBrakeCLI`, the command-line build (no GUI). It is aimed at "make a good-looking, reasonably sized MP4/MKV" rather than at low-level stream surgery.

## Why installed
It complements `ffmpeg`: when the goal is a quality-balanced encode rather than precise control, HandBrake's presets get there in one flag instead of a dozen tuned parameters. `HandBrakeCLI` makes that scriptable, so an entire folder of source files can be transcoded to a consistent target with a shell loop.

## Most common use case
Transcoding a video to a well-balanced MP4 using a built-in preset — typically `Fast 1080p30` — without hand-tuning codec settings.

## Biggest win
Expert-tuned presets. The encoding decisions (CRF, profile, audio passthrough, denoise) are baked into named presets that reliably produce good size-to-quality results — so you get a sensible H.264/H.265 encode without needing to know what every encoder flag does.

## How to use
```sh
# List every built-in preset (grouped by category)
HandBrakeCLI --preset-list

# Transcode using a named preset
HandBrakeCLI -i input.mkv -o output.mp4 --preset "Fast 1080p30"

# Encode to H.265 / MKV with a quality target
HandBrakeCLI -i input.mkv -o output.mkv -e x265 -q 22

# Batch-encode every .mkv in the current folder
for f in *.mkv; do
  HandBrakeCLI -i "$f" -o "${f%.mkv}.mp4" --preset "Fast 1080p30"
done
```

## Future use
Worth adopting: custom presets exported as `.json` and version-controlled in the dotfiles so a house encoding profile is reproducible, and the device-targeted presets (`--preset-list` shows Apple/Android/etc. categories) for one-shot mobile-ready exports.
