---
title: Video scripts
type: reference
status: active
updated: 2026-06-05
description: vid-* — video transcode/scale/crop helpers (ffmpeg).
tags:
  - project/dotfiles
  - domain/scripts/video
---

# Video (`vid-`)

All scripts shell out to `ffmpeg`. The `-h*` encoders also need an `ffmpeg` built
with Apple **VideoToolbox** (macOS hardware HEVC); `vid-convert.sh`, `vid-prores.sh`
and `vid-webm2mp4.sh` are pure software encodes. Every script now answers `-h` /
`--help` with a full usage block.

Two shapes:

- **Arg-takers** — `vid-convert.sh` (getopts) and `vid-webm2mp4.sh` (positional)
  operate on a named input file.
- **Batch globbers** — every `vid-h265*` and `vid-prores.sh` take **no arguments**;
  they glob `*.mov *.mp4 *.mxf *.avi` in the current directory and write a renamed
  sibling next to each source. `cd` into the folder, run, done.

| Script | Does | Usage |
|--------|------|-------|
| `vid-convert.sh` | **Flagship.** Scale + crop one video to a target aspect/res/anchor (no letterbox), software H.265 | `vid-convert.sh -a <16:9\|5:3\|4:3\|1:1\|3:4\|3:5\|9:16> -r <1k\|2k\|4k> -o <left\|right\|center\|top\|bottom> -i <in> -p <outdir> [-n name]` |
| `vid-h265.sh` | Batch HW H.265, 10-bit, 80M (high-bitrate master) | `vid-h265.sh` |
| `vid-h265-8b.sh` | Batch HW H.265, 8-bit main, 200M master | `vid-h265-8b.sh` |
| `vid-h265-10b.sh` | Batch HW H.265, 10-bit main10, 200M master | `vid-h265-10b.sh` |
| `vid-h265-pad.sh` | Batch crop a thin border, rescale to 1080p, 10-bit HW H.265 (NOT padding — see below) | `vid-h265-pad.sh` |
| `vid-h265-dv-pal.sh` | Batch deinterlace + scale DV PAL SD → H.265 4M | `vid-h265-dv-pal.sh` |
| `vid-h265-small.sh` | Batch HW H.265 12M delivery `.mov` | `vid-h265-small.sh` |
| `vid-h265-small-web.sh` | Batch HW H.265 12M web `.mp4` (8-bit yuv420p) | `vid-h265-small-web.sh` |
| `vid-prores.sh` | Batch software transcode → ProRes 422 HQ mezzanine | `vid-prores.sh` |
| `vid-webm2mp4.sh` | WebM (canvas/screen recordings) → MP4 (H.264/AAC) | `vid-webm2mp4.sh <in.webm> [out.mp4]` |

## Per-script

### `vid-convert.sh`

- **Does** — scales the source to FILL the target box (longest side = chosen res),
  then crops the overflow to the exact aspect at the chosen anchor. No letterbox.
- **Usage** — `vid-convert.sh -a <aspect> -r <res> -o <origin> -i <input> -p <outdir> [-n <name>]`.
- **Options** — `-a` aspect, `-r` res (`1k`=1920 / `2k`=2560 / `4k`=3840 on the longest
  side), `-o` crop anchor (default `center`), `-i` input, `-p` outdir, `-n` filename
  override. Missing `-a/-r/-i/-p` (or any bad flag) prints usage and exits non-zero.
- **Examples** — `vid-convert.sh -a 3:5 -r 2k -o center -i clip.mp4 -p .` ·
  `vid-convert.sh -a 9:16 -r 1k -o left -i wide.mp4 -p ~/out -n reel.mov`.
- **Gotcha** — software **libx265** (CRF 20, `medium`), so it's CPU-bound, not the HW
  path the `-h265*` scripts use. Output dims are rounded to even for yuv420p/HEVC;
  default name is `<stem>_<aspect>_<res>_<origin>.mov`, audio stream-copied.

### `vid-h265.sh`

- **Does** — batch HW HEVC, 10-bit `main10`/`p010le` at ~80 Mbps; the `scale=iw:ih`
  filter is a no-op that just forces the lanczos path. A high-bitrate master.
- **Usage** — `vid-h265.sh` (no args; globs the cwd).
- **Example** — `cd ~/footage && vid-h265.sh`.
- **Output** — `<name>_h265_80m.mov`; audio copied.

### `vid-h265-8b.sh`

- **Does** — batch HW HEVC, 8-bit `main`/`yuv420p` at ~200 Mbps. Near-mastering.
- **Usage** — `vid-h265-8b.sh` (no args).
- **Example** — `cd ~/footage && vid-h265-8b.sh`.
- **Output** — `<name>_h265_8bit.mov`, `hvc1`-tagged.

### `vid-h265-10b.sh`

- **Does** — batch HW HEVC, 10-bit `main10`/`yuv420p10le` at ~200 Mbps. Same idea as
  `-8b` but 10-bit colour.
- **Usage** — `vid-h265-10b.sh` (no args).
- **Example** — `cd ~/footage && vid-h265-10b.sh`.
- **Output** — `<name>_h265_200m.mov`, `hvc1`-tagged.

### `vid-h265-pad.sh`

- **Does** — despite the name it **crops, doesn't pad**: `crop=1888:1062:16:9` trims a
  16px/9px inset (dirty edges) off a 1920x1080 frame, then `scale=1920:1080` rescales
  back to full HD. 10-bit HW HEVC at ~80 Mbps.
- **Usage** — `vid-h265-pad.sh` (no args).
- **Example** — `cd ~/footage && vid-h265-pad.sh`.
- **Gotcha** — crop geometry is **hard-coded for ~1920x1080 sources**; other input
  resolutions crop/scale wrong. Output `<name>_h265_1080.mov`, `hvc1`-tagged.

### `vid-h265-dv-pal.sh`

- **Does** — built for old DV PAL captures: `yadif` deinterlace → `scale=768:576` →
  `setsar=1` (square-pixel PAL SD), then HW HEVC at ~4 Mbps.
- **Usage** — `vid-h265-dv-pal.sh` (no args).
- **Example** — `cd ~/dv-captures && vid-h265-dv-pal.sh`.
- **Gotcha** — output `<name>_h265_small.mov`, `hvc1`-tagged, audio **re-encoded** to
  AAC 160k. Same suffix as `vid-h265-small.sh` (different folders in practice).

### `vid-h265-small.sh`

- **Does** — batch HW HEVC at a delivery-sized ~12 Mbps, no resize, AAC 192k audio.
  Sharable files at source resolution.
- **Usage** — `vid-h265-small.sh` (no args).
- **Example** — `cd ~/footage && vid-h265-small.sh`.
- **Gotcha** — output `<name>_h265_small.mov`, `hvc1`-tagged. Settings are identical
  to `vid-h265-small-web.sh` except that one writes `.mp4` + forces `yuv420p`.

### `vid-h265-small-web.sh`

- **Does** — web-targeted twin of `-small`: forces 8-bit `yuv420p` (broadest player
  support) and an `.mp4` container, ~12 Mbps, AAC 192k.
- **Usage** — `vid-h265-small-web.sh` (no args).
- **Example** — `cd ~/footage && vid-h265-small-web.sh`.
- **Gotcha** — output `<name>_h265_small.mp4`. HEVC-in-MP4 still needs an HEVC-capable
  browser (Safari); it is **not** the universal H.264 — use `vid-webm2mp4.sh` semantics
  (libx264) when you need to play everywhere.

### `vid-prores.sh`

- **Does** — batch **software** transcode to ProRes 422 HQ (`prores_ks` profile 3,
  10-bit 4:2:2) with uncompressed 24-bit PCM audio. An edit mezzanine, not delivery.
- **Usage** — `vid-prores.sh` (no args).
- **Example** — `cd ~/footage && vid-prores.sh`.
- **Gotcha** — CPU-bound (no VideoToolbox); files are large. Output
  `<name>_prores422hq.mov`.

### `vid-webm2mp4.sh`

- **Does** — single-file software transcode of a canvas/screen `.webm` (VP8/9 + Opus)
  to H.264 (`libx264` CRF 18, `medium`) + AAC 192k `.mp4`.
- **Usage** — `vid-webm2mp4.sh <input.webm> [output.mp4]`.
- **Args** — `input.webm` required; `output.mp4` optional, defaults to the input path
  with `.webm` → `.mp4`. No input prints usage and exits non-zero.
- **Examples** — `vid-webm2mp4.sh ~/Downloads/kol-realtime.webm` ·
  `vid-webm2mp4.sh in.webm ~/Videos/out.mp4`.
- **Gotcha** — the only H.264 encoder in the family, so this is the "plays anywhere"
  option. CRF 18 is near-lossless, not small.

> Exact CRF/bitrate/preset flags live (and are now commented) in each script. The
> older `video2k-aspect.sh` / `video4k2k.sh` (byte-identical) and `video4k2ratio5x3.sh`
> are superseded by `vid-convert.sh` (now in `~/_temp/bin_bak/`).
