#!/bin/bash
shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg \
    -i "$f" \
    -vf "yadif,scale=1920:1080,setsar=1" \
    -af "pan=stereo|c0=FL|c1=FR" \
    -c:v hevc_videotoolbox \
    -b:v 12M \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a aac -b:a 192k \
    "${f%.*}_h265_small.mov"
done
