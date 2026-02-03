#!/bin/bash

find . -type d -mindepth 1 -exec sh -c '
for d; do
  shopt -s dotglob nullglob
  mv "$d"/* "$(dirname "$d")"/ 2>/dev/null
  rmdir "$d" 2>/dev/null
done
' sh {} +
