#!/usr/bin/env bash
# pdf-make-16bit.sh — like pdf-make.sh, but downconverts 16-bit inputs to 8-bit
# so img2pdf will accept them.

usage() {
  cat <<'EOF'
pdf-make-16bit.sh — images & vectors → PDF, with 16-bit inputs downconverted.

Same job as pdf-make.sh, but every input is probed for bit depth first: img2pdf
refuses >8-bit PNGs, so anything deeper than 8 bits/channel is re-encoded to
8-bit before being embedded. 8-bit images pass straight through untouched.

USAGE
  pdf-make-16bit.sh [out.pdf]   # run it inside the folder holding the inputs

ARGUMENTS
  out.pdf   Output filename. Default: output.pdf

BEHAVIOR
  - Picks up *.png *.jpg *.jpeg *.pdf *.ai *.eps (any case), top level only.
  - Probes depth with `magick identify -format %z`; only >8-bit files get a
    `-depth 8` pass (into a temp file). 8-bit files are embedded as-is.
  - PDF/AI/EPS rasterise at 300 dpi, then each page is depth-checked the same way.
  - Files ordered with `sort -V`.

EXAMPLES
  pdf-make-16bit.sh                 # → output.pdf
  pdf-make-16bit.sh deep-scans.pdf  # → deep-scans.pdf

NOTES
  - Deps: ImageMagick (`magick`) and img2pdf.
  - Use this when plain pdf-make.sh dies on "unsupported bit depth". If img2pdf
    STILL rejects an input (odd colorspace, multi-frame, profile), use
    pdf-make-16bit-force.sh, which re-encodes EVERY image through ImageMagick.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

out="${1:-output.pdf}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

imgs=()

# %z = bit depth per channel; img2pdf only accepts <=8, so this gates the
# downconversion below.
bitdepth() {
  magick identify -format "%z" "$1"
}

while IFS= read -r f; do
  case "$f" in
    *.png|*.PNG|*.jpg|*.JPG|*.jpeg|*.JPEG)
      base="$(basename "$f")"
      if [ "$(bitdepth "$f")" -gt 8 ]; then
        # >8-bit: re-encode down to 8-bit so img2pdf will take it.
        magick "$f" -depth 8 "$tmp/$base.png"
        imgs+=("$tmp/$base.png")
      else
        # Already 8-bit (or less): embed the original, no recompression.
        imgs+=("$f")
      fi
      ;;
    *.pdf|*.PDF|*.ai|*.AI|*.eps|*.EPS)
      base="$(basename "${f%.*}")"
      # Rasterise at 300 dpi, one PNG per page (%03d).
      magick -density 300 "$f" "$tmp/${base}-%03d.png"
      for p in "$tmp/${base}-"*.png; do
        [ -e "$p" ] || continue
        # Depth-check each rendered page; overwrite in place if too deep.
        if [ "$(bitdepth "$p")" -gt 8 ]; then
          magick "$p" -depth 8 "$p"
        fi
        imgs+=("$p")
      done
      ;;
  esac
done < <(
  find . -maxdepth 1 -type f \
    \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \
       -o -iname "*.pdf" -o -iname "*.ai" -o -iname "*.eps" \) \
  | sort -V
)

[ "${#imgs[@]}" -gt 0 ] || { echo "No input images found."; exit 1; }

img2pdf "${imgs[@]}" -o "$out"
echo "Wrote: $out"
