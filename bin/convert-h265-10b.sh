#!/bin/bash
shopt -s nullglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg -i "$f" \
    -c:v hevc_videotoolbox \
    -profile:v main10 \
    -b:v 200M \
    -pix_fmt yuv420p10le \
    -movflags +faststart \
    -c:a copy \
    "${f%.*}_h265_hw.mov"
done
