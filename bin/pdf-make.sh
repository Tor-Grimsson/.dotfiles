#!/usr/bin/env bash
set -euo pipefail

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
      magick -density 300 "$f" -alpha remove -background white "$tmp/${base}-%03d.png"
      for p in "$tmp/${base}-"*.png; do
        [ -e "$p" ] && imgs+=("$p")
      done
      ;;
  esac
done < <(
  find . -maxdepth 1 -type f \
    \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.pdf" -o -iname "*.ai" -o -iname "*.eps" \) \
  | sort -V
)

[ "${#imgs[@]}" -gt 0 ] || { echo "No input images found."; exit 1; }

img2pdf "${imgs[@]}" -o "$out"
echo "Wrote: $out"