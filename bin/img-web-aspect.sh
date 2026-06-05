#!/usr/bin/env bash

usage() {
  cat <<'EOF'
img-web-aspect.sh — emit a responsive set of web JPEGs, original aspect kept.

Generates four widths (1600, 1200, 800, 400 px) from ONE source — a typical
srcset ladder. Each is resized by width only, so the source's aspect ratio is
preserved (no cropping). sRGB 8-bit JPEG at quality 80.

USAGE
  img-web-aspect.sh <source.jpg>

ARGUMENTS / BEHAVIOR
  <source>    Source image. Required.
  Output      Written to ./<slug>/web/<slug>-<width>.jpg, where <slug> is a
              lowercased, URL-safe slug of the source name. The <slug>/web/
              directory is created if missing.

EXAMPLES
  img-web-aspect.sh hero.tif
    → ./hero/web/hero-1600.jpg, hero-1200.jpg, hero-800.jpg, hero-400.jpg

NOTES
  Dep: imagemagick (magick). Creates ./<slug>/web/ in the cwd and OVERWRITES any
  same-named files there. Aspect-preserving — for a fixed 2:1 crop use
  img-web-thumb.sh instead. Edit the SIZES array to change the width ladder.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

SOURCE="${1:?Usage: $0 source.jpg}"
# URL-safe slug of the source stem; doubles as the output sub-directory name.
SLUG="$(basename "$SOURCE" | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g')"
OUT_DIR="$SLUG/web"
mkdir -p "$OUT_DIR"

# Responsive width ladder (px) — emitted as a srcset-style set, largest first.
SIZES=(1600 1200 800 400)
QUALITY=80

for size in "${SIZES[@]}"; do
  out="$OUT_DIR/${SLUG}-${size}.jpg"

  magick "$SOURCE" \
    -flatten \
    -resize "${size}x" \
    `# "${size}x" = width only, height auto → aspect ratio preserved, no crop` \
    -strip \
    -colorspace sRGB \
    -depth 8 \
    `# strip metadata + force 8-bit sRGB for the web` \
    -quality $QUALITY \
    "$out"

  echo "Created: $out"
done