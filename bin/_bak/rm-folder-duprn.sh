#!/bin/bash

find . -type d -mindepth 1 -exec bash -c '
for d; do
  shopt -s dotglob nullglob
  for f in "$d"/*; do
    base=$(basename "$f")
    dest="$(dirname "$d")/$base"

    if [[ -e "$dest" ]]; then
      i=1
      while [[ -e "$dest.bak$i" ]]; do
        ((i++))
      done
      mv "$f" "$dest.bak$i"
    else
      mv "$f" "$(dirname "$d")/"
    fi
  done
  rmdir "$d" 2>/dev/null
done
' bash {} +
