#!/usr/bin/env bash
# pdf-from-images.sh — stitch all *.png/*.jpg in the CURRENT directory into output.pdf.

usage() {
  cat <<'EOF'
pdf-from-images.sh — stitch every *.png & *.jpg in the CURRENT directory → output.pdf.

The bare-minimum builder: natural-sort the images in the cwd and hand them to
img2pdf as-is (no rasterising, no bit-depth handling). One page per image.

USAGE
  pdf-from-images.sh            # run it inside the folder holding the images

ARGUMENTS
  (none — output is always output.pdf in the cwd)

BEHAVIOR
  - Globs *.png and *.jpg in the cwd, ordered with `ls -1v` (page2 before page10).
  - Embeds each image directly via img2pdf → output.pdf.

EXAMPLES
  pdf-from-images.sh            # → output.pdf

NOTES
  - Dep: img2pdf.
  - No 16-bit/colorspace handling — if img2pdf rejects an image, use
    pdf-make-16bit.sh (or -force). For vectors/PDFs as input, use pdf-make.sh.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

ls -1v *.png *.jpg | xargs img2pdf -o output.pdf
