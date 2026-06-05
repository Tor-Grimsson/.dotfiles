#!/usr/bin/env bash

usage() {
  cat <<'EOF'
img-crop-2000x2500-resize.sh — scale an image by a %, THEN crop to 2000×2500.

Same fixed 2000×2500 (4:5 portrait) crop as img-crop-2000x2500.sh, but runs a
percentage resize FIRST. Scaling down before cropping lets you fit more of a
large source into the frame; scaling up lets a small source actually fill it.
Writes an sRGB 8-bit JPEG at quality 80.

USAGE
  img-crop-2000x2500-resize.sh <image.(tif|tiff|png|jpg)> [gravity] [scale] [output.jpg]

ARGUMENTS
  <image>     Source file. Required.
  [gravity]   Crop anchor: center (default), north, south, etc.
  [scale]     Resize percent applied before the crop: 50 / 75 / 100 (default 100).
  [output]    Output path. Defaults to <source>_2000x2500_<gravity>_<scale>pct.jpg
              next to the source.

EXAMPLES
  img-crop-2000x2500-resize.sh photo.tif              # 100% then crop (== plain crop)
  img-crop-2000x2500-resize.sh photo.tif center 75    # shrink to 75%, then crop
  img-crop-2000x2500-resize.sh photo.tif north 50 out.jpg

NOTES
  Dep: imagemagick (magick). Writes beside the source unless [output] given, and
  OVERWRITES that path. Unlike its sibling this script prints nothing on success.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

set -euo pipefail

SOURCE="${1:?Usage: crop2000x2500 image.(tif|tiff|png|jpg) [gravity] [scale:50|75|100] [output.jpg]}"
GRAVITY="${2:-center}"
SCALE="${3:-100}"
# Default output name records gravity AND the scale % so each variant is distinct.
OUT="${4:-${SOURCE%.*}_2000x2500_${GRAVITY}_${SCALE}pct.jpg}"

magick "$SOURCE" \
  -auto-orient \
  `# bake EXIF orientation upright before any geometry op` \
  -resize "${SCALE}%" \
  `# scale the WHOLE image by SCALE% first — this is the only diff vs the plain crop` \
  -gravity "$GRAVITY" \
  `# 2000x2500+0+0 = fixed-size box; gravity anchors which part of the scaled image is kept` \
  -crop 2000x2500+0+0 \
  +repage \
  `# +repage clears the leftover crop offset from the canvas metadata` \
  -flatten \
  `# composite onto a solid bg (drop alpha/layers — JPEG can't hold them)` \
  -strip \
  `# remove EXIF/ICC to shrink the file` \
  -colorspace sRGB \
  -depth 8 \
  `# normalise to 8-bit sRGB for the web` \
  -quality 80 \
  "$OUT"