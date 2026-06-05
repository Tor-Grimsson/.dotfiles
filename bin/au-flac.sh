#!/usr/bin/env bash
# au-flac.sh — recursively transcode WAV/AIF/AIFF to FLAC (compression 8), in
# parallel, then DELETE each source once its FLAC is written successfully.

usage() {
  cat <<'EOF'
au-flac.sh — recursively convert WAV/AIF/AIFF audio to FLAC.

Walks a directory tree, transcodes every *.wav / *.aif / *.aiff to a sibling
*.flac (max compression, level 8), and removes the original ONLY if ffmpeg
exits clean. Up to 6 files convert at once.

USAGE
  au-flac.sh [dir]                       # default dir is . (the current directory)

BEHAVIOR
  - Searches DIR recursively (all subfolders) for *.wav, *.aif, *.aiff (case-insensitive).
  - Writes foo.wav -> foo.flac alongside the original; lossless re-encode.
  - DESTRUCTIVE: deletes the source file on a successful encode (mv-style replace).
  - Existing foo.flac with the same name is overwritten without prompting.

EXAMPLES
  au-flac.sh                             # convert everything under the current dir
  au-flac.sh ~/Music/recordings          # convert everything under that tree

NOTES
  - Dependency: ffmpeg (with the FLAC encoder, which is the default build).
  - FLAC is lossless, so the audio is bit-for-bit reconstructable; only the
    container/codec changes. Source deletion is intentional — back up first if unsure.
EOF
}

# Help only — must not consume the optional [dir] positional in normal use.
case "${1:-}" in -h|--help) usage; exit 0 ;; esac

# find: walk ${1:-.} (arg dir, else cwd) for regular files whose name ends in one
# of the three audio extensions. -iname = case-insensitive, so .WAV/.Aiff match too.
# -print0 + xargs -0 use NUL separators so paths with spaces/newlines survive.
find "${1:-.}" -type f \( -iname "*.wav" -o -iname "*.aif" -o -iname "*.aiff" \) -print0 | \
xargs -0 -P 6 -I {} sh -c '
# -P 6: run up to 6 ffmpeg jobs concurrently. -I {}: one file per invocation,
# passed in as "$1" to the inner shell (the leading _ is $0, a throwaway).
# ffmpeg flags:
#   -stats          show the progress/throughput line
#   -nostdin        never read stdin — vital under xargs -P so parallel jobs
#                   do not fight over the terminal and stall
#   -loglevel error only print real errors, not the banner/info spam
#   -i "$1"         input file
#   -c:a flac       encode the audio stream as FLAC (lossless)
#   -compression_level 8  hardest FLAC compression (smallest file, slowest CPU)
#   "${1%.*}.flac"  output path = input with its extension stripped + .flac
# && rm "$1": delete the source ONLY when ffmpeg succeeds (non-zero exit skips rm).
ffmpeg -stats -nostdin -loglevel error -i "$1" -c:a flac -compression_level 8 "${1%.*}.flac" && rm "$1"
' _ {}
