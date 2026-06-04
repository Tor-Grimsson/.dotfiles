#!/bin/bash
shopt -s nullglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg \
    -i "$f" \
    -vf "crop=1888:1062:16:9,scale=1920:1080" \
    -c:v hevc_videotoolbox \
    -profile:v main10 \
    -pix_fmt p010le \
    -b:v 80M \
    -maxrate 80M \
    -bufsize 160M \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a copy \
    "${f%.*}_h265_hw.mov"
done
