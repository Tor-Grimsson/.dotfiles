#!/bin/bash
shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg -i "$f" \
    -c:v hevc_videotoolbox \
    -b:v 12M \
    -tag:v hvc1 \
    -pix_fmt yuv420p \
    -movflags +faststart \
    -c:a aac -b:a 192k \
    "${f%.*}_h265_small.mp4"
done