#!/usr/bin/env bash
set -euo pipefail

SOURCE="${1:?Usage: crop2000x2500 image.(tif|tiff|png|jpg) [gravity] [output.jpg]}"
GRAVITY="${2:-center}"
OUT="${3:-${SOURCE%.*}_2000x2500_${GRAVITY}.jpg}"

magick "$SOURCE" \
  -auto-orient \
  -gravity "$GRAVITY" \
  -crop 2000x2500+0+0 \
  +repage \
  -flatten \
  -strip \
  -colorspace sRGB \
  -depth 8 \
  -quality 80 \
  "$OUT"

echo "Created: $OUT"