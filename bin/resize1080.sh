#!/usr/bin/env bash
set -euo pipefail

SOURCE="${1:?Usage: resize1080 source.jpg [output.jpg]}"
OUT="${2:-${SOURCE%.*}_1920x1080.${SOURCE##*.}}"

magick "$SOURCE" -resize "1920x1080^" -gravity center -extent "1920x1080" "$OUT"
echo "Created: $OUT"