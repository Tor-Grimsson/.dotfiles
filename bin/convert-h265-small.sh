#!/bin/bash
shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg \
    -i "$f" \
    -c:v hevc_videotoolbox \
    -b:v 12M \
    -maxrate 12M \
    -bufsize 24M \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a aac -b:a 192k \
    "${f%.*}_h265_small.mov"
done
