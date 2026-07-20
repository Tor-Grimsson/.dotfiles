#!/bin/bash
# vid-h264-web.sh — batch transcode cwd videos to universal H.264 .mp4 for the web.

usage() {
  cat <<'EOF'
vid-h264-web.sh — batch transcode cwd videos to a universal, web-ready H.264 .mp4.

The "plays everywhere" lane of the vid- family. Where vid-h265-small-web.sh emits
HEVC (smaller, but Safari-only on the web), this emits H.264 (libx264) — the codec
every browser and device can play. Quality-targeted with CRF (not a fixed bitrate),
so an over-fat source is shrunk to a sane delivery size automatically.

USAGE
  vid-h264-web.sh         # run inside the folder of clips you want web-ready
  vid-h264-web.sh -q 20   # override CRF (lower = higher quality / bigger file)

ARGUMENTS
  -q <crf>  x264 CRF quality (default 23). Sane web range ~20–26.
  -h        show this help

  (no positional args)  Globs *.mov *.mp4 *.mxf *.avi in the cwd (case-insensitive),
  and skips any input already named *_web.mp4 so re-runs don't make *_web_web.mp4.

EXAMPLES
  cd ~/footage && vid-h264-web.sh
  cd ~/footage && vid-h264-web.sh -q 21   # a touch more quality

NOTES
  Codec: H.264 (libx264, CRF 23, preset medium, yuv420p 8-bit) + AAC 128k in an .mp4.
  Output: <name>_web.mp4 next to each source; an existing one is left untouched
  (idempotent re-runs). Native resolution is kept — this re-encodes for size/reach,
  it does NOT rescale (use vid-convert.sh for that). Needs ffmpeg (no VideoToolbox).
EOF
}

case "${1:-}" in --help) usage; exit 0 ;; esac

crf=23
while getopts "q:h" opt; do
  case $opt in
    q) crf=$OPTARG ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done

shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  # Don't re-process our own output (APFS is case-insensitive, so *_web.MP4 matches too).
  case "$f" in *_web.mp4) continue ;; esac

  out="${f%.*}_web.mp4"
  [ -e "$out" ] && { echo "skip: $out already exists"; continue; }

  ffmpeg -i "$f" \
    -c:v libx264 \
    -crf "$crf" \
    -preset medium \
    -pix_fmt yuv420p \
    -movflags +faststart \
    -c:a aac -b:a 128k \
    "$out"
    # -c:v libx264  universal H.264 (vs the family's HEVC); plays in every browser
    # -crf  quality target — shrinks an over-fat source to a sane delivery size
    # -preset medium  speed/efficiency balance for a one-time delivery encode
    # -pix_fmt yuv420p  8-bit 4:2:0 for broadest player support
    # +faststart  moov atom up front so the page can stream it
    # -c:a aac -b:a 128k  re-encode audio to web-sized AAC
done
