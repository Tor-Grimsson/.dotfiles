#!/usr/bin/env bash

usage() {
  cat <<'EOF'
img-crop-2000x2500.sh — crop one image to a hard 2000×2500 frame (4:5 portrait).

Cuts a fixed 2000×2500 pixel rectangle out of the source (no scaling), anchored
by gravity, and writes an sRGB 8-bit JPEG at quality 80. If the source is smaller
than 2000×2500 the crop yields whatever pixels exist — it does NOT upscale.

USAGE
  img-crop-2000x2500.sh <image.(tif|tiff|png|jpg)> [gravity] [output.jpg]

ARGUMENTS
  <image>     Source file. Required.
  [gravity]   Crop anchor: center (default), north, south, east, west, etc.
  [output]    Output path. Defaults to <source>_2000x2500_<gravity>.jpg
              next to the source.

EXAMPLES
  img-crop-2000x2500.sh photo.tif
  img-crop-2000x2500.sh photo.tif north
  img-crop-2000x2500.sh photo.tif center cover.jpg

NOTES
  Dep: imagemagick (magick). Output lands beside the source unless [output]
  is given, and OVERWRITES any file at that path. Magic numbers 2000×2500 are
  the fixed print/listing frame; quality 80 is the house web JPEG setting.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

SOURCE="${1:?Usage: crop2000x2500 image.(tif|tiff|png|jpg) [gravity] [output.jpg]}"
GRAVITY="${2:-center}"
# Default output name encodes the geometry + gravity so variants don't collide.
OUT="${3:-${SOURCE%.*}_2000x2500_${GRAVITY}.jpg}"

magick "$SOURCE" \
  -auto-orient \
  `# respect EXIF orientation, then bake pixels upright (cameras store sideways)` \
  -gravity "$GRAVITY" \
  `# 2000x2500+0+0 = take a 2000-wide × 2500-tall box; +0+0 + gravity decides WHERE` \
  -crop 2000x2500+0+0 \
  `# +repage resets the virtual canvas so the crop offset doesn't linger in metadata` \
  +repage \
  -flatten \
  `# -flatten composites layers/alpha onto a solid background (JPEG has no transparency)` \
  -strip \
  `# -strip drops EXIF/ICC/thumbnails for a smaller file` \
  -colorspace sRGB \
  -depth 8 \
  `# force standard 8-bit sRGB so browsers render colour predictably` \
  -quality 80 \
  "$OUT"

echo "Created: $OUT"