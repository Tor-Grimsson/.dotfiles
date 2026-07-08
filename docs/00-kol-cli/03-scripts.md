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

Everything in `~/.dotfiles/bin` (symlinked to `~/bin`, on `PATH`). **Every script answers `-h` / `--help`** with purpose, args, and examples — so this is just the map; run `<script> -h` for the detail. Grouped by job below; the full per-family write-ups live in [[12-scripts/INDEX|docs/12-scripts]].

| Group | Prefix | Jump |
|---|---|---|
| [[03-scripts#Image|Image]] · [[03-scripts#Video|Video]] · [[03-scripts#Audio|Audio]] · [[03-scripts#PDF|PDF]] | `img- vid- au- pdf-` | the media transcoders |
| [[03-scripts#Artwork|Artwork]] · [[03-scripts#Download & torrents|Download]] · [[03-scripts#Files & folders|Files & folders]] | `art- dl- tor- fs- ss- batch-` | pipelines + plumbing |
| [[03-scripts#Capture & calendar|Capture & calendar]] · [[03-scripts#Sync & drift|Sync & drift]] · [[03-scripts#Helpers|Helpers]] | `tg- dot- bucket- qa-` | automation + glue |

---

## Image
Convert, resize, reframe, and web-export stills. Full doc: [[03-image|Image / 2D]].

| Script | Does | Key usage |
|---|---|---|
| `img-convert.sh` | **any image / PDF → JPG or PNG** (the generic one) | `-f jpg\|png`, `-P` pick-format, `-r` geometry, `-e` force exact dims, `-c` colors (PNG quantize), `-d` dpi, `-a` all PDF pages |
| `img-canvas.sh` | fit an image into a **fixed social-aspect canvas** | presets `9:16…16:9` or raw `WxH`, `-s N` scale, `-m cover\|fit\|stretch`, `-g` gravity, `-c` colors (PNG quantize), `-P` pick |
| `img-from-psd.sh` | flatten a **PSD → image** | the Photoshop-only sibling of `img-convert` |
| `img-from-video.sh` | grab one **video frame → image** | `-t` frame # or timestamp, `-f jpg\|png`, `-r` geometry, `-e` force exact dims |
| `img-web*.sh` | web-export variants (`-aspect`, `-batch`, `-thumb`) | quick downsized JPGs for the web |
| `img-resize-1080.sh`, `img-crop-2000x2500*.sh` | fixed-size resize / crop presets | one-shot dimension recipes |

## Video
A codec ladder plus three flagships. Full doc: [[02-video|Video]].

| Script | Does | Key usage |
|---|---|---|
| `vid-convert.sh` | **any aspect / resolution** convert (flagship) | longest-side res model; the everyday workhorse |
| `vid-archive.sh` | **shrink to archive** — 10-bit HEVC, constant-quality | `-s` height, `-q` CRF (def 20), `-g` grain; 10–30× smaller than ProRes |
| `vid-reframe.sh` | batch **reframe** a folder to 9:16 / 16:9 / 4:5 | `cd frame-9-16/` → run; no upscale, won't inflate files |
| `vid-remux-mp4.sh` | **no-encode** rewrap (MOV/MKV/… → MP4) | `-c:v copy`; lossless container swap |
| `vid-h265-*.sh`, `vid-h264-web.sh`, `vid-prores.sh`, `vid-webm2mp4.sh` | the **codec ladder** — explicit H.265/H.264/ProRes presets | pick by target (8/10-bit, small, web, pad, DV-PAL) |

## Audio
Transcode, tag, and transcribe. Full doc: [[01-audio|Audio]].

| Script | Does | Key usage |
|---|---|---|
| `au-mp3.sh` | recursive **WAV/AIFF → MP3** (keeps source) | `-b 128\|160\|192\|320` (def 320), parallel |
| `au-flac.sh` | lossless **→ FLAC** | the inverse of `au-mp3` |
| `au-tag.sh` | sidecar-`.md` frontmatter → **ID3/Vorbis tags + cover** | reads `album.md`, embeds a downscaled cover (`-s`) |
| `au-transcribe.sh` | media **URL or file → markdown transcript** (whisper) | auto-fetches the model; `base` default |
| `au-transcribe-ss.sh` | …plus **key-frame screenshots** + optional AI visual overview | `-n` frame count, `-d` LLM overview |
| `au-transcribe-playlist.sh` | transcribe a **whole playlist** | batch wrapper over `au-transcribe` |

## PDF
Build, expand, annotate, rasterize. Full doc: [[04-pdf|PDF]].

| Script | Does |
|---|---|
| `pdf-make.sh`, `pdf-make-16bit*.sh` | assemble PDFs (incl. forced 16-bit color) |
| `pdf-from-images.sh` | images → a single PDF |
| `pdf-to-png.sh` | PDF pages → PNGs |
| `pdf-expand.sh`, `pdf-notes.sh` | expand / annotate helpers |

---

## Artwork
The print/export pipeline. Full doc: [[05-artwork|Artwork pipeline]].

| Script | Does | Key usage |
|---|---|---|
| `art-process.sh` | artwork **export pipeline** (flagship) | driven by `art-export.yml` (sizes/format manifest) |

## Download & torrents
Fetch media and find torrents. Full docs: [[12-download|Download]] · [[07-torrent|Torrent]].

| Script | Does | Key usage |
|---|---|---|
| `dl-yt.sh` | yt-dlp wrapper — **highest-quality fetch** | default best+best → MKV; `-a` audio-only (native codec), `-m` MP4 |
| `tor-search` | Jackett-backed **torrent search** | self-fetches the Jackett key from the vault |
| `tor-jackett` | launches the local Jackett server | symlink to the Jackett binary |

## Files & folders
Local plumbing — move, shoot, screenshot, select. Full docs: [[06-batch-folder|Folder batch]] · [[08-system|System & clipboard]] · [[09-finder|Finder selection]].

| Script | Does | Key usage |
|---|---|---|
| `fs-shoot.sh` | clash-safe **move into a sibling folder** | the "shoot to _trash / _folder" mover |
| `fs-rm-folder-smart.sh` | safe folder removal | the gold-standard `--help` reference |
| `ss-save.sh` | **screenshot → file** in the current dir | `ss-save.sh shot` drops `shot.png` in `$PWD` |
| `batch-create-folder-move-*.sh` | make a folder and move the file/folder into it | two variants (file / folder) |
| `finder-select-alternate.sh` | select every other item in Finder | Quick Action: ⇧⌥⌃A / ⇧⌥⌃S |

---

## Capture & calendar
Frictionless inbox + calendar planning. Full docs: [[16-capture|Capture pipeline]] · [[15-calendar|Calendar]].

| Script | Does | Key usage |
|---|---|---|
| `tg-inbox.sh` | **Telegram bot → Todoist / Obsidian / calendar** | tags route it (`#t`→Todoist, `#e`→calendar, `#n`→vault); launchd every 120 s |
| `cplan` | calendar planning view that **hides recurring noise** | `--10d-n --30d-p` compose a date window; `-a` show all |

## Sync & drift
Keep machines and buckets honest. Full docs: [[11-dot-sync|Dotfiles sync]] · [[14-bucket-drift|Bucket drift]].

| Script | Does | Key usage |
|---|---|---|
| `dot-sync.sh` | the **dotfiles sync ritual** as one command | `--auto` = launchd daemon (pulls/pushes only a clean tree) |
| `bucket-drift.sh` | read-only **CDN drift** check vs a saved baseline | `bucket-drift.sh <remote> <baseline> [--update]` |

## Appearance & wake
Theme control + a real clock-time wake-up bundle. Full doc: [[../12-scripts/18-appearance|Appearance & wake automation]].

| Script | Does | Key usage |
|---|---|---|
| `os-mode.sh` | toggle/set macOS Light/Dark, or flip after a **relative** delay | `-d`/`-n` set; `-t 3h30m` delayed flip; no flag = toggle |
| `theme-alarm.sh` | a real **clock-time** alarm: theme + Focus + Spotify + Telegram, via `launchd` | `--time HH:MM …` writes the schedule; `--run`/`--test` fires it now |

## Helpers
Small glue — mostly Quick Action backends. Full doc: [[10-quick-actions|Quick Actions]].

| Script | Does |
|---|---|
| `qa-make.sh` | **stamp a new Finder Quick Action** from one line |
| `glow-open.sh`, `mpv-open.sh` | open-in-app backends (markdown via glow, media via mpv) for Quick Actions |

---

## Notes
- **Prefix = domain** (`img-`, `vid-`, …) so families sort together; non-prefixed by design: `cplan` (matches the `c*` calendar aliases) and `tor-search`.
- Superseded scripts are moved **out of the repo** to `~/_temp/`, never carried in `bin/`.
- This is the quick map — the authoritative, per-script detail (flags, gotchas, worked examples) is in [[12-scripts/INDEX|docs/12-scripts]], one doc per family.
