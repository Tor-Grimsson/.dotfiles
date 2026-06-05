#!/usr/bin/env bash
# pdf-to-png.sh — rasterise every page of a PDF to a 300 dpi PNG.

usage() {
  cat <<'EOF'
pdf-to-png.sh — rasterise a PDF to one 300 dpi PNG per page.

Renders the input PDF to PNG images with Ghostscript at 300 dpi, 24-bit colour.
Output lands in a fresh frames-NN/ directory so repeated runs never clobber
earlier output.

USAGE
  pdf-to-png.sh <in.pdf>

ARGUMENTS
  in.pdf    Source PDF to rasterise. Required.

BEHAVIOR
  - Creates the first unused frames-NN/ (frames-01, frames-02, …) in the cwd.
  - Writes page-001.png, page-002.png, … at 300 dpi, png16m (24-bit RGB).

EXAMPLES
  pdf-to-png.sh deck.pdf        # → frames-01/page-001.png, page-002.png, …

NOTES
  - Dep: Ghostscript (`gs`).
  - Pages become raster PNGs — use pdf-expand.sh to keep them as vector PDFs.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

in="${1:?input pdf required}"

# Pick the first frames-NN that doesn't exist yet, so reruns never overwrite.
n=1
while :; do
  outdir=$(printf "frames-%02d" "$n")
  [[ ! -d "$outdir" ]] && break
  ((n++))
done

mkdir "$outdir"

# -dSAFER: restrict gs file access. -dBATCH -dNOPAUSE: render all pages and
# exit, no prompts. -sDEVICE=png16m: 24-bit RGB PNG. -r300: 300 dpi.
gs -dSAFER -dBATCH -dNOPAUSE \
   -sDEVICE=png16m -r300 \
   -sOutputFile="$outdir/page-%03d.png" \
   "$in"

echo "Wrote PNG pages to: $outdir/"
