---
title: Scripts at a glance
type: reference
status: active
updated: 2026-07-02
description: The bin/ scripts grouped by what they're for — image, video, audio, PDF, download, files, capture, sync, helpers. One-line each with the key flags; links to the full family doc for depth.
aliases:
  - scripts-glance
  - kol-scripts
tags:
  - project/dotfiles
  - domain/scripts
related:
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
  - "[[INDEX|Scripts index (full)]]"
---

# Scripts at a glance

Everything in `~/.dotfiles/bin` (symlinked to `~/bin`, on `PATH`). **Every script answers `-h` / `--help`** with purpose, args, and examples — so this is just the map; run `<script> -h` for the detail. Grouped by job below; the full per-family write-ups live in [docs/12-scripts](../12-scripts/INDEX.md).

| Group | Prefix | Jump |
|---|---|---|
| [Image](#image) · [Video](#video) · [Audio](#audio) · [PDF](#pdf) | `img- vid- au- pdf-` | the media transcoders |
| [Artwork](#artwork) · [Download](#download--torrents) · [Files & folders](#files--folders) | `art- dl- tor- fs- ss- batch-` | pipelines + plumbing |
| [Capture & calendar](#capture--calendar) · [Sync & drift](#sync--drift) · [Helpers](#helpers) | `tg- dot- bucket- qa-` | automation + glue |

---

## Image
Convert, resize, reframe, and web-export stills. Full doc: [Image / 2D](../12-scripts/03-image.md).

| Script | Does | Key usage |
|---|---|---|
| `img-convert.sh` | **any image / PDF → JPG or PNG** (the generic one) | `-f jpg\|png`, `-P` pick-format, `-r` geometry, `-e` force exact dims, `-c` colors (PNG quantize), `-d` dpi, `-a` all PDF pages |
| `img-canvas.sh` | fit an image into a **fixed social-aspect canvas** | presets `9:16…16:9` or raw `WxH`, `-s N` scale, `-m cover\|fit\|stretch`, `-g` gravity, `-c` colors (PNG quantize), `-P` pick |
| `img-from-psd.sh` | flatten a **PSD → image** | the Photoshop-only sibling of `img-convert` |
| `img-from-video.sh` | grab one **video frame → image** | `-t` frame # or timestamp, `-f jpg\|png`, `-r` geometry, `-e` force exact dims |
| `img-web*.sh` | web-export variants (`-aspect`, `-batch`, `-thumb`) | quick downsized JPGs for the web |
| `img-resize-1080.sh`, `img-crop-2000x2500*.sh` | fixed-size resize / crop presets | one-shot dimension recipes |

## Video
A codec ladder plus three flagships. Full doc: [Video](../12-scripts/02-video.md).

| Script | Does | Key usage |
|---|---|---|
| `vid-convert.sh` | **any aspect / resolution** convert (flagship) | longest-side res model; the everyday workhorse |
| `vid-archive.sh` | **shrink to archive** — 10-bit HEVC, constant-quality | `-s` height, `-q` CRF (def 20), `-g` grain; 10–30× smaller than ProRes |
| `vid-reframe.sh` | batch **reframe** a folder to 9:16 / 16:9 / 4:5 | `cd frame-9-16/` → run; no upscale, won't inflate files |
| `vid-remux-mp4.sh` | **no-encode** rewrap (MOV/MKV/… → MP4) | `-c:v copy`; lossless container swap |
| `vid-h265-*.sh`, `vid-h264-web.sh`, `vid-prores.sh`, `vid-webm2mp4.sh` | the **codec ladder** — explicit H.265/H.264/ProRes presets | pick by target (8/10-bit, small, web, pad, DV-PAL) |

## Audio
Transcode, tag, and transcribe. Full doc: [Audio](../12-scripts/01-audio.md).

| Script | Does | Key usage |
|---|---|---|
| `au-mp3.sh` | recursive **WAV/AIFF → MP3** (keeps source) | `-b 128\|160\|192\|320` (def 320), parallel |
| `au-flac.sh` | lossless **→ FLAC** | the inverse of `au-mp3` |
| `au-tag.sh` | sidecar-`.md` frontmatter → **ID3/Vorbis tags + cover** | reads `album.md`, embeds a downscaled cover (`-s`) |
| `au-transcribe.sh` | media **URL or file → markdown transcript** (whisper) | auto-fetches the model; `base` default |
| `au-transcribe-ss.sh` | …plus **key-frame screenshots** + optional AI visual overview | `-n` frame count, `-d` LLM overview |
| `au-transcribe-playlist.sh` | transcribe a **whole playlist** | batch wrapper over `au-transcribe` |

## PDF
Build, expand, annotate, rasterize. Full doc: [PDF](../12-scripts/04-pdf.md).

| Script | Does |
|---|---|
| `pdf-make.sh`, `pdf-make-16bit*.sh` | assemble PDFs (incl. forced 16-bit color) |
| `pdf-from-images.sh` | images → a single PDF |
| `pdf-to-png.sh` | PDF pages → PNGs |
| `pdf-expand.sh`, `pdf-notes.sh` | expand / annotate helpers |

---

## Artwork
The print/export pipeline. Full doc: [Artwork pipeline](../12-scripts/05-artwork.md).

| Script | Does | Key usage |
|---|---|---|
| `art-process.sh` | artwork **export pipeline** (flagship) | driven by `art-export.yml` (sizes/format manifest) |

## Download & torrents
Fetch media and find torrents. Full docs: [Download](../12-scripts/12-download.md) · [Torrent](../12-scripts/07-torrent.md).

| Script | Does | Key usage |
|---|---|---|
| `dl-yt.sh` | yt-dlp wrapper — **highest-quality fetch** | default best+best → MKV; `-a` audio-only (native codec), `-m` MP4 |
| `tor-search` | Jackett-backed **torrent search** | self-fetches the Jackett key from the vault |
| `tor-jackett` | launches the local Jackett server | symlink to the Jackett binary |

## Files & folders
Local plumbing — move, shoot, screenshot, select. Full docs: [Folder batch](../12-scripts/06-batch-folder.md) · [System & clipboard](../12-scripts/08-system.md) · [Finder selection](../12-scripts/09-finder.md).

| Script | Does | Key usage |
|---|---|---|
| `fs-shoot.sh` | clash-safe **move into a sibling folder** | the "shoot to _trash / _folder" mover |
| `fs-rm-folder-smart.sh` | safe folder removal | the gold-standard `--help` reference |
| `ss-save.sh` | **screenshot → file** in the current dir | `ss-save.sh shot` drops `shot.png` in `$PWD` |
| `batch-create-folder-move-*.sh` | make a folder and move the file/folder into it | two variants (file / folder) |
| `finder-select-alternate.sh` | select every other item in Finder | Quick Action: ⇧⌥⌃A / ⇧⌥⌃S |

---

## Capture & calendar
Frictionless inbox + calendar planning. Full docs: [Capture pipeline](../12-scripts/16-capture.md) · [Calendar](../12-scripts/15-calendar.md).

| Script | Does | Key usage |
|---|---|---|
| `tg-inbox.sh` | **Telegram bot → Todoist / Obsidian / calendar** | tags route it (`#t`→Todoist, `#e`→calendar, `#n`→vault); launchd every 120 s |
| `cplan` | calendar planning view that **hides recurring noise** | `--10d-n --30d-p` compose a date window; `-a` show all |

## Sync & drift
Keep machines and buckets honest. Full docs: [Dotfiles sync](../12-scripts/11-dot-sync.md) · [Bucket drift](../12-scripts/14-bucket-drift.md).

| Script | Does | Key usage |
|---|---|---|
| `dot-sync.sh` | the **dotfiles sync ritual** as one command | `--auto` = launchd daemon (pulls/pushes only a clean tree) |
| `bucket-drift.sh` | read-only **CDN drift** check vs a saved baseline | `bucket-drift.sh <remote> <baseline> [--update]` |

## Helpers
Small glue — mostly Quick Action backends. Full doc: [Quick Actions](../12-scripts/10-quick-actions.md).

| Script | Does |
|---|---|
| `qa-make.sh` | **stamp a new Finder Quick Action** from one line |
| `glow-open.sh`, `mpv-open.sh` | open-in-app backends (markdown via glow, media via mpv) for Quick Actions |

---

## Notes
- **Prefix = domain** (`img-`, `vid-`, …) so families sort together; non-prefixed by design: `cplan` (matches the `c*` calendar aliases) and `tor-search`.
- Superseded scripts are moved **out of the repo** to `~/_temp/`, never carried in `bin/`.
- This is the quick map — the authoritative, per-script detail (flags, gotchas, worked examples) is in [docs/12-scripts](../12-scripts/INDEX.md), one doc per family.
