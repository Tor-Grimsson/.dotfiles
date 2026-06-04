#!/usr/bin/env bash

shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg \
    -i "$f" \
    -vf "yadif,scale=768:576,setsar=1" \
    -c:v hevc_videotoolbox \
    -b:v 4M \
    -maxrate 4M \
    -bufsize 8M \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a aac -b:a 160k \
    "${f%.*}_h265_small.mov"
done
