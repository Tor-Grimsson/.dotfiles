#!/usr/bin/env bash

usage() {
  cat <<'EOF'
img-web-thumb.sh — emit a responsive set of fixed 2:1 web thumbnails (cropped).

Generates four widths (1600, 1200, 800, 400 px) from ONE source, each cropped to
a 2:1 landscape ratio (width × width/2). Scales to cover the box, then
center-crops the overflow — every output is an exact 2:1 thumbnail. sRGB 8-bit
JPEG at quality 80.

USAGE
  img-web-thumb.sh <source.jpg>

ARGUMENTS / BEHAVIOR
  <source>    Source image. Required.
  Output      Written to ./<slug>/web/<slug>-<width>.jpg, where <slug> is a
              lowercased, URL-safe slug of the source name. The <slug>/web/
              directory is created if missing. Dimensions: 1600×800, 1200×600,
              800×400, 400×200.

EXAMPLES
  img-web-thumb.sh card.tif
    → ./card/web/card-1600.jpg (1600×800), card-1200.jpg (1200×600), …

NOTES
  Dep: imagemagick (magick). Creates ./<slug>/web/ in the cwd and OVERWRITES any
  same-named files there. This one CROPS to 2:1 — for aspect-preserving widths use
  img-web-aspect.sh. Change the ratio by editing the height= line; widths via SIZES.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

SOURCE="${1:?Usage: $0 source.jpg}"
# URL-safe slug of the source stem; doubles as the output sub-directory name.
SLUG="$(basename "$SOURCE" | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g')"
OUT_DIR="$SLUG/web"
mkdir -p "$OUT_DIR"

# Responsive width ladder (px); height is derived per-size for a 2:1 crop.
SIZES=(1600 1200 800 400)
QUALITY=80

for size in "${SIZES[@]}"; do
  width=$size
  height=$((size / 2))  # 2:1 ratio — half the width
  out="$OUT_DIR/${SLUG}-${size}.jpg"

  magick "$SOURCE" \
    -flatten \
    -resize "${width}x${height}^" \
    `# WxH^ ("cover"): scale so the image FILLS the box, overflow on one side` \
    -gravity center \
    -extent "${width}x${height}" \
    `# center-crop the overflow back to an EXACT WxH canvas → true 2:1 thumb` \
    -strip \
    -colorspace sRGB \
    -depth 8 \
    `# strip metadata + force 8-bit sRGB for the web` \
    -quality $QUALITY \
    "$out"

  echo "Created: $out"
done