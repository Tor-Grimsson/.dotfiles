#!/bin/bash
shopt -s nullglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg -i "$f" \
    -c:v hevc_videotoolbox \
    -profile:v main \
    -pix_fmt yuv420p \
    -b:v 200M \
    -movflags +faststart \
    -c:a copy \
    "${f%.*}_h265_8bit.mov"
done
