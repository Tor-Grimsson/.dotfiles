#!/usr/bin/env bash
# pdf-make-16bit-force.sh — like pdf-make-16bit.sh, but re-encodes EVERY image
# through ImageMagick so img2pdf can't choke on odd encodings.

usage() {
  cat <<'EOF'
pdf-make-16bit-force.sh — images & vectors → PDF, re-encoding every input.

The heavy-hammer variant. Where pdf-make-16bit.sh passes already-8-bit images
straight to img2pdf, this one routes EVERY raster image through ImageMagick
first, taking only the first frame (`[0]`) and writing a fresh PNG. That
normalises colorspace, strips problem profiles, and drops extra frames — so
img2pdf accepts files it would otherwise reject. Slower; lossless re-encode.

USAGE
  pdf-make-16bit-force.sh [out.pdf]   # run it inside the folder with the inputs

ARGUMENTS
  out.pdf   Output filename. Default: output.pdf

BEHAVIOR
  - Picks up *.png *.jpg *.jpeg *.pdf *.ai *.eps (any case), top level only.
  - Every raster image is re-encoded to PNG via `magick "$f[0]"` (first frame
    only); >8-bit ones additionally get `-depth 8`. Nothing is passed through raw.
  - Depth is probed with `magick identify -ping` (header-only, faster than full
    identify) purely to decide whether the `-depth 8` flag is needed.
  - PDF/AI/EPS rasterise at 300 dpi, one PNG/page, each depth-checked.
  - Files ordered with `sort -V`.

EXAMPLES
  pdf-make-16bit-force.sh                # → output.pdf
  pdf-make-16bit-force.sh catalogue.pdf  # → catalogue.pdf

NOTES
  - Deps: ImageMagick (`magick`) and img2pdf.
  - Reach for this only when pdf-make-16bit.sh still fails — typically multi-
    frame PNGs, embedded ICC profiles, or colorspaces img2pdf won't touch. The
    forced re-encode normalises all of those at the cost of speed.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

out="${1:-output.pdf}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

imgs=()

# -ping = read header only (no pixel decode) — fast depth probe. %z = bits/channel.
bitdepth() {
  magick identify -ping -format "%z" "$1"
}

while IFS= read -r f; do
  case "$f" in
    *.png|*.PNG|*.jpg|*.JPG|*.jpeg|*.JPEG)
      base="$(basename "$f")"
      outpng="$tmp/$base.png"

      # Note: BOTH branches re-encode via magick — that's the "force". `[0]`
      # takes the first frame only (drops extra frames). >8-bit also gets
      # flattened to 8-bit; <=8-bit is still re-encoded clean for img2pdf.
      if [ "$(bitdepth "$f")" -gt 8 ]; then
        magick "$f[0]" -depth 8 "$outpng"
        imgs+=("$outpng")
      else
        magick "$f[0]" "$outpng"
        imgs+=("$outpng")
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
