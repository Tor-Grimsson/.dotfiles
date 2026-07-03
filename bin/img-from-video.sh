#!/usr/bin/env bash
# img-from-video.sh — grab a single frame from a video as JPG or PNG.

usage() {
  cat <<'EOF'
img-from-video.sh — grab a single frame from a video as JPG or PNG.

Picks one frame via -t and decodes exactly it. JPG flattens onto white (no
real alpha in video anyway); PNG for a lossless intermediate you'll resize/
quantize further with img-convert.sh. Writes one output per source — beside
it, or into -o DIR.

USAGE
  img-from-video.sh [-F] [-f jpg|png] [-t FRAME|TIMESTAMP] [-r GEOMETRY] [-e] [-q QUALITY] [-o OUTDIR] FILE...

OPTIONS
  -F  force overwrite if output already exists (default: skip with warning)
  -f  output format: jpg (default) or png
  -t  which frame to grab (default 1 — the first frame). Two forms:
        a bare integer  = frame NUMBER, 1-based (-t 23 = the 23rd frame)
        HH:MM:SS or a decimal = TIMESTAMP, ffmpeg's own seek (-t 00:00:05,
        -t 5.5). Frame-number mode decodes from the start to count frames
        (exact, but slower deep into a long video); timestamp mode fast-
        seeks to the nearest keyframe first (quick, but frame-approximate).
  -r  resize geometry — 1920x1080 (fit) | 1920x1080^ (fill) | 50% | 2000x | x1080
      (default: full frame size, no resize)
  -e  exact: force the final canvas to literally match -r's WxH (see
      img-convert.sh -h for the full explanation). Plain -r is fit-inside —
      can land a pixel short on one axis from aspect-ratio rounding. -e
      crops/pads with a center-gravity extent pass so you always get exactly
      the WxH you asked for. Requires -r to be a literal WxH. Pair with your
      /export-specs standard sizes for a guaranteed-clean standardized export.
  -q  jpg quality 1-100 (default 90; ignored for png)
  -o  output directory (default: alongside each source)
  -h  show this help

EXAMPLES
  img-from-video.sh clip.mp4                    # → clip.jpg, frame 1, full size
  img-from-video.sh -t 23 clip.mp4              # → clip.jpg, the 23rd frame
  img-from-video.sh -t 00:00:05 clip.mp4        # → clip.jpg, frame at 5s
  img-from-video.sh -f png -r 1600x2000 clip.mov  # → clip.png, resized
  img-from-video.sh -r 1080x1350 -e clip.mov    # 4:5 @1x (export-specs), exact, guaranteed
  img-from-video.sh -o out -q 92 *.mp4          # batch into ./out at quality 92

NOTES
  - Dep: ffmpeg (frame decode), imagemagick (magick, for resize/format).
  - PNG output from a real photo/video frame is typically NOT a good -c
    quantize candidate (see img-convert.sh) — that's for flat graphics, and
    a video frame has gradients/noise that'll band under quantization.
  - Wired into a Finder Quick Action — see docs/12-scripts/img-from-video.md.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

format=jpg; frame_spec="1"; resize=""; exact=false; quality=90; outdir=""; force=0

while getopts "f:t:r:eq:o:Fh" opt; do
  case "$opt" in
    f) format="$OPTARG" ;;
    t) frame_spec="$OPTARG" ;;
    r) resize="$OPTARG" ;;
    e) exact=true ;;
    q) quality="$OPTARG" ;;
    o) outdir="$OPTARG" ;;
    F) force=1 ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

[ $# -gt 0 ] || { echo "error: no input files" >&2; usage >&2; exit 1; }
case "$format" in jpeg) format=jpg ;; jpg|png) ;; *) echo "error: -f must be jpg or png" >&2; exit 1 ;; esac
extent_wh=""
if [ "$exact" = true ]; then
  if [[ "$resize" =~ ^([0-9]+)x([0-9]+) ]]; then
    extent_wh="${BASH_REMATCH[1]}x${BASH_REMATCH[2]}"
  else
    echo "error: -e requires -r to be a literal WxH (e.g. -r 1600x2000), got: '$resize'" >&2
    exit 1
  fi
fi
[ -z "$outdir" ] || mkdir -p "$outdir"

for src in "$@"; do
  [ -f "$src" ] || { echo "skip (not found): $src" >&2; continue; }
  base="$(basename "${src%.*}")"
  dir="${outdir:-$(dirname "$src")}"
  dst="$dir/$base.$format"
  [[ $force -eq 0 && -f "$dst" ]] && { echo "skip (exists): $dst — use -F to overwrite"; continue; }

  tmp="$(mktemp -t img-from-video).png"
  if [[ "$frame_spec" =~ ^[0-9]+$ ]]; then
    # bare integer = 1-based frame number → 0-based ffmpeg select index
    ffmpeg -y -loglevel error -i "$src" -vf "select=eq(n\,$((frame_spec - 1)))" -vframes 1 "$tmp"
  else
    # HH:MM:SS or decimal seconds = timestamp
    ffmpeg -y -loglevel error -ss "$frame_spec" -i "$src" -vframes 1 "$tmp"
  fi
  [ -s "$tmp" ] || { echo "error: no frame at $frame_spec in $src (past end of video?)" >&2; rm -f "$tmp"; continue; }

  args=("$tmp")
  [ -n "$resize" ] && args+=(-resize "$resize")
  if [ "$format" = png ]; then
    args+=(-background none)
    [ -n "$extent_wh" ] && args+=(-gravity center -extent "$extent_wh")
  else
    args+=(-background white -flatten)
    [ -n "$extent_wh" ] && args+=(-gravity center -extent "$extent_wh")
  fi
  args+=(-quality "$quality" -colorspace sRGB -depth 8 "$dst")

  magick "${args[@]}"
  rm -f "$tmp"
  echo "$src [$frame_spec] -> $dst"
done
