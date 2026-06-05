#!/usr/bin/env bash

usage() {
  cat <<'EOF'
img-resize-1080.sh — resize + center-crop an image to exactly 1920×1080 (16:9).

Fills a Full-HD 1080p frame: scales the source so the SHORTER side covers
1920×1080, then center-crops the overflow. Output is always exactly 1920×1080,
no letterboxing, no distortion. Keeps the source's file extension/format.

USAGE
  img-resize-1080.sh <source.jpg> [output.jpg]

ARGUMENTS
  <source>    Source image. Required.
  [output]    Output path. Defaults to <source>_1920x1080.<ext> (same ext as
              the source) next to the source.

EXAMPLES
  img-resize-1080.sh shot.jpg
  img-resize-1080.sh shot.png wallpaper.png

NOTES
  Dep: imagemagick (magick). Writes beside the source unless [output] given, and
  OVERWRITES that path. No -strip/-quality here, so format defaults apply.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

SOURCE="${1:?Usage: resize1080 source.jpg [output.jpg]}"
# Default name keeps the source's extension (${SOURCE##*.}) — PNG in, PNG out.
OUT="${2:-${SOURCE%.*}_1920x1080.${SOURCE##*.}}"

# "1920x1080^" — the ^ means "cover": scale so the image FILLS the box (shorter
# side fits exactly), letting the other side overflow. Then -gravity center +
# -extent crops that overflow back to an exact 1920x1080 canvas.
magick "$SOURCE" -resize "1920x1080^" -gravity center -extent "1920x1080" "$OUT"
echo "Created: $OUT"