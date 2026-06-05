#!/usr/bin/env bash

usage() {
  cat <<'EOF'
img-web-batch.sh — batch-optimize EVERY image in the CURRENT directory for the web.

Loops over all .jpg/.jpeg/.png/.tiff/.heic files in the cwd (case-insensitive),
resizes each DOWN to a max width, and writes a slugged, size-capped sRGB JPEG to
a ./web_optimized/ folder. Originals are never touched.

USAGE
  img-web-batch.sh [width]          # run it INSIDE the folder of images

ARGUMENTS / BEHAVIOR
  [width]     Max width in px (default 2560). "${WIDTH}x>" only down-scales —
              images already narrower are left at their size.
  Input       ALL *.jpg *.jpeg *.png *.tiff *.heic in the cwd (NOT recursive).
  Output      ./web_optimized/<slug>.jpg per image; each capped near 500kb via
              jpeg:extent. The folder is created if missing.

EXAMPLES
  img-web-batch.sh              # optimize this folder at max 2560px wide
  img-web-batch.sh 1200         # same, capped at 1200px wide

NOTES
  Dep: imagemagick (magick). Output lands in ./web_optimized/ and OVERWRITES
  same-named files there; originals are untouched. MAX_SIZE (500kb) is a target,
  not a hard guarantee. With no matching files the loop is a no-op (nullglob).
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

# Configuration
WIDTH="${1:-2560}"
MAX_SIZE="500kb"  # soft target file-size cap (see jpeg:extent below)
mkdir -p web_optimized

# nullglob: a pattern with no matches expands to nothing (so the loop just skips
# absent formats). nocaseglob: match .JPG/.Jpeg/.PNG etc. regardless of case.
# Globs are NOT recursive — only the current directory is scanned.
shopt -s nullglob nocaseglob
for f in *.jpg *.jpeg *.png *.tiff *.heic; do

  # 1. Clean, URL-safe slug: strip ext, lowercase, non-[a-z0-9] runs → single hyphen.
  SLUG="$(basename "$f" | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g')"

  echo "Processing: $f -> web_optimized/${SLUG}.jpg"

  # 2. Convert and compress
  magick "$f" \
    -flatten \
    -resize "${WIDTH}x>" \
    `# "${WIDTH}x>" — the > means "only shrink": never upscale a smaller source` \
    -strip \
    -colorspace sRGB \
    `# strip metadata + force sRGB; note: no -depth 8 here, unlike the other scripts` \
    -define jpeg:extent="$MAX_SIZE" \
    `# jpeg:extent tells the encoder to TARGET this file size by tuning quality` \
    "web_optimized/${SLUG}.jpg"

done

echo "Done! Optimized images are in the 'web_optimized' folder."