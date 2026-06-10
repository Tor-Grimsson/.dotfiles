---
title: Video scripts
type: reference
status: active
updated: 2026-06-10
description: vid-* — video transcode/scale/crop/remux helpers (ffmpeg).
tags:
  - project/dotfiles
  - domain/scripts/video
related:
  - "[[video-archive-pipeline|Video archive pipeline (workflow)]]"
  - "[[vid-archive|Archive to 10-bit H.265 (deep-dive)]]"
  - "[[vid-remux-mp4|Rewrap to MP4 (deep-dive)]]"
  - "[[vid-h264-web|H.264 web encode (deep-dive)]]"
  - "[[au-transcribe|Transcribe a video URL/file to markdown (deep-dive)]]"
---

# Video (`vid-`)

These re-encode/rewrap video. To turn a video **URL or file into a text transcript** (markdown), see [[au-transcribe|au-transcribe.sh]] in the audio family (yt-dlp + whisper).

All scripts shell out to `ffmpeg`. The `vid-h265*` encoders also need an `ffmpeg`
built with Apple **VideoToolbox** (macOS hardware HEVC); `vid-archive.sh`,
`vid-convert.sh`, `vid-prores.sh`, `vid-webm2mp4.sh` and `vid-h264-web.sh` are pure
software encodes; `vid-remux-mp4.sh` doesn't encode the video at all — it
stream-copies into a new container. Every script now answers `-h` / `--help` with a
full usage block.

**Archive vs. mezzanine vs. delivery.** Three jobs, three tools. `vid-archive.sh` is
the **archive** default: 10-bit HEVC at a constant *quality* (libx265 CRF), so the
file is small but band-free and the size follows the content — the keep-forever copy
that still plays everywhere. The `vid-h265-*` hardware encoders target a fixed
*bitrate* instead: `-10b`/`-8b` at ~200 Mbps are near-lossless **mezzanines** (barely
smaller than ProRes — edit intermediates, not archives), while `-small`/`-small-web`
are 8-bit ~12 Mbps **delivery** files. Reach for `vid-archive.sh` when gradients/banding
matter and you want one small 10-bit copy at any resolution; the HW path when encode
speed beats compression efficiency.

**HEVC vs H.264 for the web.** Two scripts target an `.mp4` for the browser, and
they are *not* interchangeable: `vid-h265-small-web.sh` emits **HEVC** (smaller, but
only Safari plays it on the web), `vid-h264-web.sh` emits **H.264** (a bit larger,
but plays in every browser and device). Reach for H.264 when "plays everywhere"
matters; HEVC when the audience is Apple and bytes are tight.

Two shapes:

- **Arg-takers** — `vid-convert.sh` (getopts) and `vid-webm2mp4.sh` (positional)
  operate on a named input file.
- **Batch globbers** — every `vid-h265*`, `vid-prores.sh`, `vid-remux-mp4.sh` and
  `vid-h264-web.sh` take **no positional arguments**; they glob the cwd and write a
  renamed sibling next to each source. `cd` into the folder, run, done. (The
  `vid-h265*`/`vid-prores`/`vid-h264-web` set globs `*.mov *.mp4 *.mxf *.avi`;
  `vid-remux-mp4.sh` deliberately **excludes** `.mp4` and adds `.mkv`/`.ts`, since
  rewrapping an mp4 into mp4 is pointless. `vid-h264-web.sh` *does* glob `.mp4` —
  its job is shrinking fat mp4s — but skips its own `*_web.mp4` output, and takes an
  optional `-q <crf>` quality flag.)

| Script | Does | Usage |
|--------|------|-------|
| `vid-convert.sh` | **Flagship.** Scale + crop one video to a target aspect/res/anchor (no letterbox), software H.265 | `vid-convert.sh -a <16:9\|5:3\|4:3\|1:1\|3:4\|3:5\|9:16> -r <1k\|2k\|4k> -o <left\|right\|center\|top\|bottom> -i <in> -p <outdir> [-n name]` |
| `vid-archive.sh` | **Archive default.** Batch SW H.265, **10-bit**, constant-quality **CRF** `.mp4` — small + band-free, any res; `-s` downscales (never upscales) | `vid-archive.sh [-s height] [-q crf] [-g]` |
| `vid-h265.sh` | Batch HW H.265, 10-bit, 80M (high-bitrate master) | `vid-h265.sh` |
| `vid-h265-8b.sh` | Batch HW H.265, 8-bit main, 200M master | `vid-h265-8b.sh` |
| `vid-h265-10b.sh` | Batch HW H.265, 10-bit main10, 200M master | `vid-h265-10b.sh` |
| `vid-h265-pad.sh` | Batch crop a thin border, rescale to 1080p, 10-bit HW H.265 (NOT padding — see below) | `vid-h265-pad.sh` |
| `vid-h265-dv-pal.sh` | Batch deinterlace + scale DV PAL SD → H.265 4M | `vid-h265-dv-pal.sh` |
| `vid-h265-small.sh` | Batch HW H.265 12M delivery `.mov` | `vid-h265-small.sh` |
| `vid-h265-small-web.sh` | Batch HW H.265 12M web `.mp4` (8-bit yuv420p) — Safari-only | `vid-h265-small-web.sh` |
| `vid-h264-web.sh` | Batch SW **H.264** web `.mp4` (libx264 CRF 23, yuv420p) — **plays everywhere** | `vid-h264-web.sh [-q crf]` |
| `vid-prores.sh` | Batch software transcode → ProRes 422 HQ mezzanine | `vid-prores.sh` |
| `vid-webm2mp4.sh` | WebM (canvas/screen recordings) → MP4 (H.264/AAC) | `vid-webm2mp4.sh <in.webm> [out.mp4]` |
| `vid-remux-mp4.sh` | Batch rewrap H.264/HEVC `.mov`/`.mkv`/… → `.mp4`, **no re-encode** (lossless, seconds); incompatible audio → AAC | `vid-remux-mp4.sh` |

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

### `vid-archive.sh`

- **Does** — batch software HEVC (`libx265`) at a constant **quality** (CRF, default
  20), **10-bit** `yuv420p10le`, in a `.mp4`. The archive default: small but band-free,
  size follows the content, plays everywhere. Optional `-s` downscales (never upscales);
  any source resolution in. Full write-up: [[vid-archive|deep-dive]].
- **Usage** — `vid-archive.sh [-s <height>] [-q <crf>] [-g]` (no positional args; globs the cwd).
- **Options** — `-s` max output height (downscale only, e.g. `1080`/`720`; omit = native
  res), `-q` CRF (default 20; 18 ≈ visually lossless, 23 = smaller), `-g` add `-tune grain`
  for noisy **live** footage (off for animation / clean sources).
- **Examples** — `cd ~/ae-export && vid-archive.sh` · `vid-archive.sh -s 1080` ·
  `vid-archive.sh -q 18` · `vid-archive.sh -g`.
- **Gotcha** — software `libx265` (`preset medium`), so it's **CPU-bound**, not the HW
  path the `vid-h265*` scripts use (minutes per 4K file). Globs `.mp4` too (shrinking a
  fat mp4 is valid) but skips its own `*_h265.mp4` / `*_h265_<H>p.mp4` outputs, and an
  existing output is left untouched — idempotent. Output `<name>_h265.mp4` (native) or
  `<name>_h265_<H>p.mp4` (downscaled), `hvc1`-tagged, `+faststart`, audio copied.

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
  browser (Safari); it is **not** the universal H.264 — reach for `vid-h264-web.sh`
  (the H.264 twin below) when you need to play everywhere.

### `vid-h264-web.sh`

- **Does** — the **universal-playback twin** of `-small-web`: re-encodes to **H.264**
  (`libx264`) in an `.mp4`, 8-bit `yuv420p`, AAC 128k. H.264 plays in every browser
  and on every device — the reach HEVC doesn't have. Quality is CRF-targeted, so an
  over-fat source (e.g. a 720p clip carrying a 16 Mbps stream) is shrunk to a sane
  delivery size automatically.
- **Usage** — `vid-h264-web.sh [-q <crf>]` (no positional args; globs the cwd).
- **Options** — `-q` x264 CRF, default **23** (lower = higher quality / bigger file;
  sane web range ~20–26).
- **Example** — `cd ~/footage && vid-h264-web.sh` · `vid-h264-web.sh -q 21`.
- **Gotcha** — software `libx264` (`preset medium`), so it's CPU-bound, not the HW
  path the `vid-h265*` scripts use. **Does not rescale** — native resolution is kept
  (use `vid-convert.sh` to change dimensions). Output `<name>_web.mp4`; an existing
  one is skipped (idempotent), and `*_web.mp4` inputs are skipped so a re-run never
  produces `*_web_web.mp4`.

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
- **Gotcha** — one of the two H.264 encoders in the family (with `vid-h264-web.sh`),
  but specialised for **webm sources**; CRF 18 is near-lossless, not small. To shrink
  *already-mp4/mov* footage to universal, delivery-sized H.264, use `vid-h264-web.sh`.

### `vid-remux-mp4.sh`

- **Does** — batch **rewrap** (not re-encode): for footage that's *already* H.264 or
  HEVC but trapped in a `.mov`/`.mkv`/`.avi`/`.mxf`/`.ts`, it stream-copies the video
  into an `.mp4`. Lossless and seconds-per-file — no quality loss, no CPU cost. The
  right tool when the codec is fine and only the container is wrong (e.g. After
  Effects `.mov` exports).
- **Usage** — `vid-remux-mp4.sh` (no args; globs the cwd).
- **Example** — `cd ~/ae-export && vid-remux-mp4.sh`.
- **Audio** — copied when mp4 can already carry it (`aac`/`ac3`/`eac3`/`mp3`/`alac`),
  otherwise re-encoded to **AAC 256k** (PCM, Opus, Vorbis, FLAC…). Only the audio is
  touched in that case; the video still stream-copies.
- **Gotcha** — **not a transcoder.** A non-H.264/HEVC video stream (ProRes, VP9,
  MPEG-2, DNxHD…) is **skipped with a printed reason** rather than producing a broken
  mp4 — reach for `vid-h265-small-web.sh` or `vid-convert.sh` there. Only the first
  video + first audio stream are kept; data/timecode tracks are dropped (`-write_tmcd 0`
  stops the muxer re-adding a `tmcd` track). `.mp4` sources aren't globbed, and an
  existing `<name>.mp4` is left untouched — so it's safe to re-run. Output `<name>.mp4`.

> Exact CRF/bitrate/preset flags live (and are now commented) in each script. The
> older `video2k-aspect.sh` / `video4k2k.sh` (byte-identical) and `video4k2ratio5x3.sh`
> are superseded by `vid-convert.sh` (now in `~/_temp/bin_bak/`).
