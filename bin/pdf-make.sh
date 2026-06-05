#!/usr/bin/env bash
# pdf-make.sh — bundle every image/vector in the CURRENT directory into one PDF.

usage() {
  cat <<'EOF'
pdf-make.sh — bundle every image & vector in the CURRENT directory into one PDF.

Scans the current directory (top level only) for raster images and vector/PDF
files, rasterises the vectors to 300 dpi PNG, then stitches everything into a
single PDF via img2pdf. Pages come out in natural-sorted filename order.

USAGE
  pdf-make.sh [out.pdf]        # run it inside the folder holding the inputs

ARGUMENTS
  out.pdf   Output filename. Default: output.pdf

BEHAVIOR
  - Picks up *.png *.jpg *.jpeg *.pdf *.ai *.eps (any case), top level only.
  - Raster images are embedded as-is (no recompression) — fastest, lossless.
  - PDF/AI/EPS are rasterised at 300 dpi with the alpha channel flattened onto
    white, one PNG per page, then embedded.
  - Files are ordered with `sort -V` (page2 before page10).

EXAMPLES
  pdf-make.sh                  # → output.pdf
  pdf-make.sh portfolio.pdf    # → portfolio.pdf

NOTES
  - Deps: ImageMagick (`magick`) and img2pdf, both on PATH.
  - No bit-depth handling here — if img2pdf rejects a 16-bit PNG, reach for
    pdf-make-16bit.sh (downconverts to 8-bit) or pdf-make-16bit-force.sh.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

out="${1:-output.pdf}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

imgs=()

while IFS= read -r f; do
  case "$f" in
    *.png|*.PNG|*.jpg|*.JPG|*.jpeg|*.JPEG)
      imgs+=("$f")
      ;;
    *.pdf|*.PDF|*.ai|*.AI|*.eps|*.EPS)
      base="$(basename "${f%.*}")"
      # Rasterise vectors at 300 dpi; flatten transparency onto white so
      # img2pdf gets clean opaque pages. %03d → one PNG per source page.
      magick -density 300 "$f" -alpha remove -background white "$tmp/${base}-%03d.png"
      for p in "$tmp/${base}-"*.png; do
        [ -e "$p" ] && imgs+=("$p")
      done
      ;;
  esac
done < <(
  # Top level only (-maxdepth 1); case-insensitive match; natural sort so
  # page2 lands before page10.
  find . -maxdepth 1 -type f \
    \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.pdf" -o -iname "*.ai" -o -iname "*.eps" \) \
  | sort -V
)

[ "${#imgs[@]}" -gt 0 ] || { echo "No input images found."; exit 1; }

img2pdf "${imgs[@]}" -o "$out"
echo "Wrote: $out"