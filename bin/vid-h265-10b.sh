#!/bin/bash
# vid-h265-10b.sh — batch transcode videos in the cwd to 10-bit hardware H.265.

usage() {
  cat <<'EOF'
vid-h265-10b.sh — batch transcode every video in the CURRENT directory to 10-bit H.265.

Apple VideoToolbox (hardware) HEVC, profile main10 / 10-bit, ~200 Mbps. Like
vid-h265-8b.sh but with 10-bit colour depth; an intermediate/mastering encode.

USAGE
  vid-h265-10b.sh        # run inside the folder of clips you want transcoded

ARGUMENTS
  (none)  Globs *.mov *.mp4 *.mxf *.avi in the cwd.

EXAMPLES
  cd ~/footage && vid-h265-10b.sh

NOTES
  Codec: HEVC main10 / 10-bit (hevc_videotoolbox, yuv420p10le, 200M, hvc1), audio copied.
  Output: <name>_h265_200m.mov next to each source. Needs ffmpeg with VideoToolbox.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

shopt -s nullglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg -i "$f" \
    -c:v hevc_videotoolbox \
    -profile:v main10 \
    -b:v 200M \
    -pix_fmt yuv420p10le \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a copy \
    "${f%.*}_h265_200m.mov"
    # -profile:v main10 + -pix_fmt yuv420p10le  10-bit 4:2:0 colour
    # -b:v 200M  near-mastering target bitrate (large files)
    # -tag:v hvc1  QuickTime-friendly HEVC tag (vs the generic 'hev1')
    # -movflags +faststart  moov atom up front for instant playback/streaming
    # -c:a copy  audio passed through untouched
done
