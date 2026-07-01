#!/usr/bin/env bash

usage() {
  cat <<'EOF'
img-web.sh — make one web-optimized JPEG, resized to a target width.

Resizes a single image down to WIDTH px wide (height auto, aspect preserved) and
writes an sRGB 8-bit JPEG at quality 80. The output filename is a clean slug of
the source name (lowercased, non-alphanumerics → hyphens) so it's URL-safe.

USAGE
  img-web.sh [-f] <source.jpg> [width]

ARGUMENTS
  -f          Force overwrite if output already exists.
  <source>    Source image. Required.
  [width]     Target width in px (default 2560). Height scales to match.
  Output      Written to the CURRENT directory as <slug>.jpg — NOT beside the
              source. e.g. "My Photo.TIF" → ./my-photo.jpg

EXAMPLES
  img-web.sh photo.tif          # → ./photo.jpg, 2560px wide
  img-web.sh photo.tif 1200     # → ./photo.jpg, 1200px wide

NOTES
  Dep: imagemagick (magick). Output lands in the cwd and OVERWRITES an existing
  <slug>.jpg. "${WIDTH}x" resizes by width only and only DOWN-scales unless the
  source is already smaller (no < / > guard here — magick will upscale a tiny src).
EOF
}

FORCE=0
case "${1:-}" in -h|--help) usage; exit 0 ;; -f) FORCE=1; shift ;; esac

set -euo pipefail
SOURCE="${1:?Usage: $0 [-f] source.jpg [width]}"
WIDTH="${2:-2560}"
# SLUG: strip extension, lowercase, collapse any run of non-[a-z0-9] into a single
# hyphen → a tidy, URL-safe stem for the output file. Output lands in the cwd.
SLUG="$(basename "$SOURCE" | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g')"
# ponytail: suffix width only when explicitly supplied to avoid stomping the source
[[ $# -ge 2 ]] && SLUG="${SLUG}-${WIDTH}"

[[ $FORCE -eq 0 && -f "${SLUG}.jpg" ]] && { echo "img-web: ${SLUG}.jpg already exists — move it or pass -f to overwrite"; exit 1; }

magick "$SOURCE" \
  -flatten \
  `# composite layers/alpha onto a solid bg (JPEG has no transparency)` \
  -resize "${WIDTH}x" \
  `# "${WIDTH}x" = resize to WIDTH px wide, height auto, aspect ratio kept` \
  -strip \
  `# drop EXIF/ICC metadata to shrink the file` \
  -colorspace sRGB \
  -depth 8 \
  `# normalise to 8-bit sRGB for predictable browser colour` \
  -quality 80 \
  "${SLUG}.jpg"