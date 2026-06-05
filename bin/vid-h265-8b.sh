#!/bin/bash
# vid-h265-8b.sh — batch transcode videos in the cwd to 8-bit hardware H.265.

usage() {
  cat <<'EOF'
vid-h265-8b.sh — batch transcode every video in the CURRENT directory to 8-bit H.265.

Apple VideoToolbox (hardware) HEVC, profile main / 8-bit, ~200 Mbps. The high
bitrate makes this an intermediate/mastering encode, not a delivery file.

USAGE
  vid-h265-8b.sh         # run inside the folder of clips you want transcoded

ARGUMENTS
  (none)  Globs *.mov *.mp4 *.mxf *.avi in the cwd.

EXAMPLES
  cd ~/footage && vid-h265-8b.sh

NOTES
  Codec: HEVC main / 8-bit (hevc_videotoolbox, yuv420p, 200M, hvc1), audio stream-copied.
  Output: <name>_h265_8bit.mov next to each source. Needs ffmpeg with VideoToolbox.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

shopt -s nullglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg -i "$f" \
    -c:v hevc_videotoolbox \
    -profile:v main \
    -pix_fmt yuv420p \
    -b:v 200M \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a copy \
    "${f%.*}_h265_8bit.mov"
    # -profile:v main + -pix_fmt yuv420p  8-bit 4:2:0 (vs main10/p010le for 10-bit)
    # -b:v 200M  very high target bitrate — near-mastering quality, big files
    # -tag:v hvc1  QuickTime-friendly HEVC tag (vs the generic 'hev1')
    # -movflags +faststart  moov atom up front for instant streaming/playback
    # -c:a copy  audio passed through untouched
done
