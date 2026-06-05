#!/bin/bash
# vid-h265.sh — batch transcode videos in the cwd to 10-bit hardware H.265.

usage() {
  cat <<'EOF'
vid-h265.sh — batch transcode every video in the CURRENT directory to H.265.

Encodes via Apple VideoToolbox (hardware, macOS) at 10-bit main10, ~80 Mbps —
a high-bitrate mastering/intermediate, NOT a small delivery file. Audio is copied.

USAGE
  vid-h265.sh            # run inside the folder of clips you want transcoded

ARGUMENTS
  (none)  Globs *.mov *.mp4 *.mxf *.avi in the cwd (case-insensitive).

EXAMPLES
  cd ~/footage && vid-h265.sh

NOTES
  Codec: HEVC main10 (hevc_videotoolbox, p010le, 80M CBR-ish), audio stream-copied.
  Output: <name>_h265_80m.mov next to each source. Needs ffmpeg with VideoToolbox.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

shopt -s nullglob nocaseglob

for f in *.mov *.mp4 *.mxf *.avi; do
  ffmpeg \
    -i "$f" \
    -vf "scale=iw:ih:flags=lanczos" \
    -c:v hevc_videotoolbox \
    -profile:v main10 \
    -pix_fmt p010le \
    -b:v 80M \
    -maxrate 80M \
    -bufsize 160M \
    -tag:v hvc1 \
    -movflags +faststart \
    -c:a copy \
    "${f%.*}_h265_80m.mov"
    # -vf scale=iw:ih  no-op resize, just forces the lanczos path through the filter graph
    # -c:v hevc_videotoolbox  Apple hardware HEVC encoder (fast, macOS-only)
    # -profile:v main10 + -pix_fmt p010le  10-bit colour (p010le = 10-bit planar)
    # -b:v/-maxrate/-bufsize  cap bitrate at 80M, allow a 160M VBV buffer
    # -tag:v hvc1  Apple/QuickTime-friendly HEVC tag (vs the generic 'hev1')
    # -movflags +faststart  moves the moov atom to the front so it streams immediately
    # -c:a copy  pass audio through untouched
done
