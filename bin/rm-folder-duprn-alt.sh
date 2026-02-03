#!/bin/bash

find . -type d -mindepth 1 -exec bash -c '
for d; do
  shopt -s dotglob nullglob
  for f in "$d"/*; do
    filename=$(basename "$f")
    
    # Split the filename
    if [[ "$filename" == *.* ]]; then
        ext=".${filename##*.}"
        name="${filename%.*}"
    else
        ext=""
        name="$filename"
    fi

    dest_dir="$(dirname "$d")"
    dest="$dest_dir/$filename"

    if [[ -e "$dest" ]]; then
      i=1
      # Check for name-bak1.ext
      while [[ -e "$dest_dir/$name-bak$i$ext" ]]; do
        ((i++))
      done
      mv "$f" "$dest_dir/$name-bak$i$ext"
    else
      mv "$f" "$dest_dir/"
    fi
  done
  rmdir "$d" 2>/dev/null
done
' bash {} +