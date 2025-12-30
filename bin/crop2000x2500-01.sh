#!/usr/bin/env bash
set -euo pipefail

SOURCE="${1:?Usage: crop2000x2500 image.jpg [gravity] [output.jpg]}"
GRAVITY="${2:-center}"
OUT="${3:-${SOURCE%.*}_2000x2500_${GRAVITY}.${SOURCE##*.}}"

magick "$SOURCE" \
  -gravity "$GRAVITY" \
  -crop 2000x2500+0+0 \
  +repage \
  "$OUT"

echo "Created: $OUT"