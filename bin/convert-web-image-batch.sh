#!/usr/bin/env bash
set -euo pipefail

# Configuration
WIDTH="${1:-2560}"
MAX_SIZE="500kb"  # Adjust this to your needs
mkdir -p web_optimized

# Loop through common image formats
shopt -s nullglob nocaseglob
for f in *.jpg *.jpeg *.png *.tiff *.heic; do

  # 1. Create the clean SLUG filename
  SLUG="$(basename "$f" | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g')"
  
  echo "Processing: $f -> web_optimized/${SLUG}.jpg"

  # 2. Convert and compress
  magick "$f" \
    -flatten \
    -resize "${WIDTH}x>" \
    -strip \
    -colorspace sRGB \
    -define jpeg:extent="$MAX_SIZE" \
    "web_optimized/${SLUG}.jpg"

done

echo "Done! Optimized images are in the 'web_optimized' folder."