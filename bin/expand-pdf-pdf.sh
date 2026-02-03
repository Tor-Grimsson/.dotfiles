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

pdfseparate "$in" "$outdir/page-%03d.pdf"

echo "Wrote PDF pages to: $outdir/"
