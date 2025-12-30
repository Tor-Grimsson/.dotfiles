#!/usr/bin/env bash
set -euo pipefail

SOURCE="${1:?Usage: $0 source.jpg}"
SLUG="$(basename "$SOURCE" | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g')"
OUT_DIR="$SLUG/web"
mkdir -p "$OUT_DIR"

SIZES=(1600 1200 800 400)
QUALITY=80

for size in "${SIZES[@]}"; do
  width=$size
  height=$((size / 2))  # 2:1 ratio
  out="$OUT_DIR/${SLUG}-${size}.jpg"
  
  magick "$SOURCE" \
    -flatten \
    -resize "${width}x${height}^" \
    -gravity center \
    -extent "${width}x${height}" \
    -strip \
    -colorspace sRGB \
    -depth 8 \
    -quality $QUALITY \
    "$out"
  
  echo "Created: $out"
done