#!/usr/bin/env bash
# pdf-expand.sh — split a multi-page PDF into one PDF file per page.

usage() {
  cat <<'EOF'
pdf-expand.sh — explode a PDF into one PDF file per page.

Splits the input PDF into single-page PDFs (vector preserved, not rasterised)
using poppler's pdfseparate. Output lands in a fresh frames-NN/ directory so
repeated runs never clobber earlier output.

USAGE
  pdf-expand.sh <in.pdf>

ARGUMENTS
  in.pdf    Source PDF to split. Required.

BEHAVIOR
  - Creates the first unused frames-NN/ (frames-01, frames-02, …) in the cwd.
  - Writes page-001.pdf, page-002.pdf, … (one PDF per page, content intact).

EXAMPLES
  pdf-expand.sh deck.pdf        # → frames-01/page-001.pdf, page-002.pdf, …

NOTES
  - Dep: poppler (`pdfseparate`).
  - Pages stay as PDF, NOT images — use pdf-to-png.sh if you want raster pages.
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

# pdfseparate = poppler's page splitter; %03d → page-001.pdf, page-002.pdf, …
pdfseparate "$in" "$outdir/page-%03d.pdf"

echo "Wrote PDF pages to: $outdir/"
