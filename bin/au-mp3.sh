#!/usr/bin/env bash
# au-mp3.sh — recursively transcode WAV/AIFF to MP3 (CBR), keeping the source.

usage() {
  cat <<'EOF'
au-mp3.sh — recursively convert WAV/AIF/AIFF audio to MP3 (CBR).

Walks a directory tree and transcodes every *.wav / *.aif / *.aiff to a sibling
*.mp3 via ffmpeg + libmp3lame, at the chosen constant bitrate. Up to 6 files
convert at once. NON-destructive: the lossless source is kept (MP3 is lossy).

USAGE
  au-mp3.sh [-b 128|160|192|320] [dir]       # default bitrate 320, default dir .

OPTIONS
  -b  CBR bitrate in kbps: 128, 160, 192 or 320 (default 320).
  -h  show this help.

BEHAVIOR
  - Searches DIR recursively for *.wav, *.aif, *.aiff (case-insensitive).
  - Writes foo.wav -> foo.mp3 alongside the original; overwrites a same-named mp3.
  - KEEPS the source — unlike au-flac.sh, which deletes (FLAC is lossless, MP3 isn't).

EXAMPLES
  au-mp3.sh                                  # 320 kbps, everything under the cwd
  au-mp3.sh -b 192 ~/Music/album            # 192 kbps under that tree

NOTES
  - Dep: ffmpeg (with libmp3lame, the default build).
  - CBR at the chosen bitrate; for tags + cover art run au-tag.sh afterwards.
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

bitrate=320
while getopts "b:h" opt; do
  case "$opt" in
    b) bitrate="$OPTARG" ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

case "$bitrate" in 128|160|192|320) ;; *) echo "error: -b must be 128, 160, 192 or 320" >&2; exit 1 ;; esac

# find ${1:-.} recursively, NUL-separated so spaces/newlines survive. BR carries
# the bitrate into each parallel sh child via xargs's inherited environment.
find "${1:-.}" -type f \( -iname "*.wav" -o -iname "*.aif" -o -iname "*.aiff" \) -print0 | \
BR="$bitrate" xargs -0 -P 6 -I {} sh -c '
# -nostdin: never read stdin (keeps parallel ffmpeg jobs off the tty). -y:
# overwrite an existing mp3. -c:a libmp3lame -b:a ${BR}k: CBR MP3 at the bitrate.
ffmpeg -stats -nostdin -y -loglevel error -i "$1" -c:a libmp3lame -b:a "${BR}k" "${1%.*}.mp3"
' _ {}
