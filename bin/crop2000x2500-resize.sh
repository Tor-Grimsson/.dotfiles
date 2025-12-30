#!/usr/bin/env bash
set -euo pipefail

SOURCE="${1:?Usage: crop2000x2500 image.(tif|tiff|png|jpg) [gravity] [scale:50|75|100] [output.jpg]}"
GRAVITY="${2:-center}"
SCALE="${3:-100}"
OUT="${4:-${SOURCE%.*}_2000x2500_${GRAVITY}_${SCALE}pct.jpg}"

magick "$SOURCE" \
  -auto-orient \
  -resize "${SCALE}%" \
  -gravity "$GRAVITY" \
  -crop 2000x2500+0+0 \
  +repage \
  -flatten \
  -strip \
  -colorspace sRGB \
  -depth 8 \
  -quality 80 \
  "$OUT"