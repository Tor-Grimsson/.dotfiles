#!/usr/bin/env bash
set -euo pipefail

out="${1:-output.pdf}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

imgs=()

bitdepth() {
  magick identify -ping -format "%z" "$1"
}

while IFS= read -r f; do
  case "$f" in
    *.png|*.PNG|*.jpg|*.JPG|*.jpeg|*.JPEG)
      base="$(basename "$f")"
      outpng="$tmp/$base.png"

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
      magick -density 300 "$f" "$tmp/${base}-%03d.png"
      for p in "$tmp/${base}-"*.png; do
        [ -e "$p" ] || continue
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
