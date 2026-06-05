#!/bin/bash
# vid-h265-pad.sh — batch crop-and-rescale cwd videos to clean 1080p 10-bit H.265.

usage() {
  cat <<'EOF'
vid-h265-pad.sh — batch crop a thin border off cwd clips, rescale to 1080p H.265.

Despite the "pad" name this CROPS, not letterboxes: it trims a 16px/9px inset
(crop=1888x1062 at offset 16,9) to drop dirty edges, then scales back to
1920x1080. Encodes 10-bit HEVC via VideoToolbox at ~80 Mbps.

USAGE
  vid-h265-pad.sh        # run inside the folder of clips you want cleaned to 1080p

ARGUMENTS
  (none)  Globs *.mov *.mp4 *.mxf *.avi in the cwd.

EXAMPLES
  cd ~/footage && vid-h265-pad.sh

NOTES
  Codec: HEVC main10 / 10-bit (hevc_videotoolbox, p010le, 80M), hvc1-tagged, audio copied.
  Output: <name>_h265_1080.mov next to each source. Needs ffmpeg with VideoToolbox.
  The crop geometry is hard-coded for ~1920x1080 sources; other resolutions will
  crop/scale unexpectedly.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

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
    "${f%.*}_h265_1080.mov"
    # crop=1888:1062:16:9  cut a 1888x1062 window starting 16px right, 9px down (trims
    #   a thin border off a 1920x1080 frame); scale=1920:1080  rescale back to full HD
    # -profile:v main10 + -pix_fmt p010le  10-bit colour
    # -b:v/-maxrate/-bufsize 80M/80M/160M  high-bitrate intermediate
    # -tag:v hvc1  QuickTime HEVC tag; +faststart  moov atom up front; -c:a copy  audio passthrough
done
