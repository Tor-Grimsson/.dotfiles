#!/usr/bin/env bash
set -euo pipefail
SOURCE="${1:?Usage: $0 source.jpg [width]}"
WIDTH="${2:-2560}"
SLUG="$(basename "$SOURCE" | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g')"

magick "$SOURCE" \
  -flatten \
  -resize "${WIDTH}x" \
  -strip \
  -colorspace sRGB \
  -depth 8 \
  -quality 80 \
  "${SLUG}.jpg"