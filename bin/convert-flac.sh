#!/usr/bin/env bash
find "${1:-.}" -type f -iname "*.wav" -print0 | \
xargs -0 -P 6 -I {} sh -c '
ffmpeg -stats -nostdin -loglevel error -i "$1" -c:a flac -compression_level 8 "${1%.wav}.flac" && rm "$1"
' _ {}
