#!/usr/bin/env bash
set -euo pipefail

in="${1:?input pdf required}"

n=1
while :; do
  outdir=$(printf "frames-%02d" "$n")
  [[ ! -d "$outdir" ]] && break
  ((n++))
done

mkdir "$outdir"

gs -dSAFER -dBATCH -dNOPAUSE \
   -sDEVICE=png16m -r300 \
   -sOutputFile="$outdir/page-%03d.png" \
   "$in"

echo "Wrote PNG pages to: $outdir/"
