#!/usr/bin/env bash
# au-transcribe-ss.sh — like au-transcribe.sh, but also grabs a few key
# screenshots (and an optional AI visual overview) so you can reorient to what
# the video showed without rewatching it.

usage() {
  cat <<'EOF'
au-transcribe-ss.sh — URL or local video → markdown note with transcript + key frames.

Same pipeline as au-transcribe.sh (yt-dlp + whisper.cpp), but downloads the
*video* (one fetch feeds both audio and frames), samples N evenly-spaced key
frames with ffmpeg's `thumbnail` filter (most-representative frame per segment —
no black/transition junk), saves them beside the note, and embeds them with
timestamps. With -d it sends the frames to the `llm` CLI for a short "Visual
overview" so you can reorient to the footage without rewatching.

USAGE
  au-transcribe-ss.sh [-m MODEL] [-l LANG] [-o OUTDIR] [-n N] [-c BROWSER] [-d] [-k] <url|file> [more…]

OPTIONS
  -m  whisper model (default: base). tiny|base|small|medium|large-v3, plus .en
      English-only variants. Downloaded once to $WHISPER_MODEL_DIR (~/.cache/whisper).
  -l  spoken-language hint (default: auto). e.g. -l en, -l is.
  -o  output directory for the .md + frames (default: current dir).
  -n  number of key frames to grab (default: 6). 0 disables frames.
  -c  load yt-dlp cookies from a browser (chrome|firefox|safari|edge|brave|…)
      for login-gated URLs like TikTok collections. e.g. -c firefox. URLs only.
  -d  generate an AI "Visual overview" from the frames via the `llm` CLI
      (default model: whatever `llm models default` reports; override with
      $AU_SS_LLM_MODEL). Off by default.
  -k  keep the extracted .wav beside the .md (default: discarded).
  -h  show this help.

EXAMPLES
  au-transcribe-ss.sh https://www.tiktok.com/@user/video/123
  au-transcribe-ss.sh -n 10 -d https://youtu.be/dQw4w9WgXcQ
  au-transcribe-ss.sh -o ~/Notes/transcripts -d talk.mp4

OUTPUT
  <slug>.md            the note: frontmatter + caption + key frames + transcript
  <slug>-frames/       the sampled jpg frames, linked from the note

NOTES
  - Deps: ffmpeg + ffprobe + whisper-cli + jq, plus yt-dlp for URLs and (for -d)
    the `llm` CLI. Frames need a video source — an audio-only input just skips them.
  - Download quality is capped at 720p to keep fetches sane; override with
    $AU_SS_FORMAT (a yt-dlp -f expression).
  - whisper.cpp prints Metal/backend lines to stderr on every run — startup
    noise, not an error.
EOF
}

case "${1:-}" in -h|--help|"") usage; exit 0 ;; esac

set -euo pipefail

model="base"; lang="auto"; outdir="."; nframes=6; describe=false; keep=false; cookies=""
while getopts "m:l:o:n:c:dkh" opt; do
  case "$opt" in
    m) model="$OPTARG" ;;
    l) lang="$OPTARG" ;;
    o) outdir="$OPTARG" ;;
    n) nframes="$OPTARG" ;;
    c) cookies="$OPTARG" ;;
    d) describe=true ;;
    k) keep=true ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))
[ "$#" -ge 1 ] || { echo "error: need at least one URL or media file" >&2; usage >&2; exit 1; }
[[ "$nframes" =~ ^[0-9]+$ ]] || { echo "error: -n must be a non-negative integer" >&2; exit 1; }

command -v ffmpeg  >/dev/null || { echo "error: ffmpeg not found" >&2; exit 1; }
command -v ffprobe >/dev/null || { echo "error: ffprobe not found" >&2; exit 1; }
command -v jq      >/dev/null || { echo "error: jq not found" >&2; exit 1; }
whisper=""
for c in whisper-cli whisper-cpp; do
  if command -v "$c" >/dev/null; then whisper="$c"; break; fi
done
[ -n "$whisper" ] || { echo "error: whisper-cli not found (brew install whisper-cpp)" >&2; exit 1; }
if [ "$describe" = true ] && ! command -v llm >/dev/null; then
  echo "warning: llm not found — skipping -d visual overview" >&2; describe=false
fi

mkdir -p "$outdir"

# resolve the whisper model, downloading it once if missing
model_dir="${WHISPER_MODEL_DIR:-$HOME/.cache/whisper}"
model_file="$model_dir/ggml-${model}.bin"
url_base="${WHISPER_MODEL_URL_BASE:-https://huggingface.co/ggerganov/whisper.cpp/resolve/main}"
if [ ! -f "$model_file" ]; then
  command -v curl >/dev/null || { echo "error: curl not found (needed to fetch the model)" >&2; exit 1; }
  mkdir -p "$model_dir"
  echo "▸ downloading whisper model '$model' → $model_file" >&2
  if ! curl -fL --progress-bar -o "$model_file" "$url_base/ggml-${model}.bin"; then
    rm -f "$model_file"
    echo "error: model download failed — check the model name or \$WHISPER_MODEL_URL_BASE" >&2
    exit 1
  fi
fi

# kebab-case slug from a title, capped at 80 chars
slugify() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' | cut -c1-80
}
# quote a value for YAML (double-quoted; internal double quotes downgraded to single)
yaml_str() { printf '"%s"' "${1//\"/\'}"; }
# seconds (float) → HH:MM:SS
fmt_ts() { awk -v s="$1" 'BEGIN{s=int(s+0.5);printf "%02d:%02d:%02d",s/3600,(s%3600)/60,s%60}'; }

transcribe_one() {
  local input="$1"
  local tmp; tmp=$(mktemp -d "${TMPDIR:-/tmp}/au-transcribe-ss.XXXXXX")
  trap 'rm -rf "$tmp"' RETURN

  local title uploader source published duration caption platform media_src

  if [[ "$input" =~ ^https?:// ]]; then
    command -v yt-dlp >/dev/null || { echo "error: yt-dlp not found (needed for URLs)" >&2; return 1; }
    local fmt="${AU_SS_FORMAT:-bestvideo[height<=720]+bestaudio/best[height<=720]/best}"
    echo "▸ fetching video: $input" >&2
    local ytflags=(--no-warnings --no-playlist -f "$fmt" --merge-output-format mp4 --write-info-json)
    [ -n "$cookies" ] && ytflags+=(--cookies-from-browser "$cookies")
    if ! yt-dlp "${ytflags[@]}" -o "$tmp/src.%(ext)s" "$input"; then
      echo "error: yt-dlp failed on $input" >&2; return 1
    fi
    local info
    info=$(find "$tmp" -maxdepth 1 -name '*.info.json' | sort | head -1)
    [ -n "$info" ] || { echo "error: no metadata json for $input" >&2; return 1; }
    media_src=$(find "$tmp" -maxdepth 1 -type f ! -name '*.info.json' | sort | head -1)
    title=$(jq -r '.title // "untitled"' "$info")
    uploader=$(jq -r '.uploader // .channel // .uploader_id // ""' "$info")
    source=$(jq -r '.webpage_url // ""' "$info")
    platform=$(jq -r '.extractor_key // ""' "$info")
    published=$(jq -r '.upload_date // ""' "$info")
    if [ "${#published}" -eq 8 ]; then published="${published:0:4}-${published:4:2}-${published:6:2}"; else published=""; fi
    duration=$(jq -r '.duration_string // ""' "$info")
    caption=$(jq -r '.description // ""' "$info")
  else
    [ -f "$input" ] || { echo "error: no such file: $input" >&2; return 1; }
    title=$(basename "${input%.*}"); uploader=""; source="$input"
    platform="local"; published=""; duration=""; caption=""; media_src="$input"
  fi

  [ -n "${media_src:-}" ] && [ -f "$media_src" ] || { echo "error: no media for $input" >&2; return 1; }

  # → 16 kHz mono PCM wav, the input whisper.cpp expects. Frames are the point of
  # this script, so a silent/video-only clip (no audio stream) degrades to an
  # empty transcript instead of failing the whole entry.
  local wav="$tmp/audio.wav" transcript=""
  if ffmpeg -nostdin -y -loglevel error -i "$media_src" -ar 16000 -ac 1 -c:a pcm_s16le "$wav" 2>/dev/null \
       && [ -s "$wav" ]; then
    echo "▸ transcribing ($model, lang=$lang)…" >&2
    if "$whisper" -m "$model_file" -f "$wav" -l "$lang" -nt -np -otxt -of "$tmp/transcript" >/dev/null 2>&1 \
         && [ -f "$tmp/transcript.txt" ]; then
      transcript=$(sed -E '/^[[:space:]]*$/d; s/^[[:space:]]+//' "$tmp/transcript.txt")
    else
      echo "  (whisper produced no transcript — continuing with frames)" >&2
    fi
  else
    echo "  (no audio stream — transcript skipped, grabbing frames only)" >&2
  fi
  [ -n "$transcript" ] || transcript="_(no speech detected)_"

  # pick the output paths (skip clobbering an existing <slug>.md / -frames dir)
  local slug; slug=$(slugify "$title"); [ -n "$slug" ] || slug="transcript"
  local out="$outdir/$slug.md"; local n=2
  while [ -e "$out" ]; do out="$outdir/$slug-$n.md"; n=$((n + 1)); done
  local base; base=$(basename "${out%.md}")
  local framedir="$outdir/$base-frames"

  # sample N evenly-spaced key frames from the video stream
  local frames_md="" desc=""
  if [ "$nframes" -gt 0 ]; then
    local dur
    dur=$(ffprobe -v error -show_entries format=duration \
            -of default=noprint_wrappers=1:nokey=1 "$media_src" 2>/dev/null | head -1)
    local has_video
    has_video=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_type \
                  -of default=noprint_wrappers=1:nokey=1 "$media_src" 2>/dev/null | head -1)
    if [ "$has_video" != "video" ] || [ -z "$dur" ] || ! awk -v d="$dur" 'BEGIN{exit (d>0)?0:1}'; then
      echo "  (no usable video stream — skipping frames)" >&2
    else
      echo "▸ grabbing $nframes key frames…" >&2
      mkdir -p "$framedir"
      local -a llm_args=()
      local i ts fname rel got=0
      for i in $(seq 0 $((nframes - 1))); do
        # center of segment i, then let `thumbnail` pick the best frame in a 3s window
        ts=$(awk -v d="$dur" -v n="$nframes" -v i="$i" 'BEGIN{printf "%.3f", d*(i+0.5)/n}')
        fname=$(printf 'frame-%02d.jpg' "$((i + 1))")
        if ffmpeg -nostdin -y -loglevel error -ss "$ts" -i "$media_src" -t 3 \
             -vf "thumbnail,scale=960:-2" -frames:v 1 -q:v 3 "$framedir/$fname" 2>/dev/null \
           && [ -s "$framedir/$fname" ]; then
          rel="$base-frames/$fname"
          local hms; hms=$(fmt_ts "$ts")
          frames_md+="![$hms]($rel)"$'\n'"*$hms*"$'\n\n'
          llm_args+=(-a "$framedir/$fname")
          got=$((got + 1))
        fi
      done
      [ "$got" -gt 0 ] || { echo "  (no frames extracted)" >&2; rmdir "$framedir" 2>/dev/null || true; }

      # optional AI visual overview from the grabbed frames
      if [ "$describe" = true ] && [ "$got" -gt 0 ]; then
        echo "▸ describing $got frames via llm…" >&2
        local prompt
        prompt="These are $got still frames sampled in chronological order from a video titled \"$title\". Write a concise visual overview (3-5 sentences) of what the video shows — setting, people, on-screen text, and what visibly happens — so a reader can reorient to the footage without rewatching it. Describe only what is visible; do not invent audio or narration. Reply with the overview prose only — no heading, title, or preamble."
        local m=(); [ -n "${AU_SS_LLM_MODEL:-}" ] && m=(-m "$AU_SS_LLM_MODEL")
        if ! desc=$(llm ${m[@]+"${m[@]}"} "${llm_args[@]}" "$prompt" 2>/dev/null); then
          echo "  (llm description failed — skipping)" >&2; desc=""
        fi
      fi
    fi
  fi

  # assemble the note
  {
    echo "---"
    printf 'title: %s\n' "$(yaml_str "$title")"
    [ -n "$source" ]    && printf 'source: %s\n' "$source"
    [ -n "$platform" ]  && printf 'platform: %s\n' "$platform"
    [ -n "$uploader" ]  && printf 'uploader: %s\n' "$(yaml_str "$uploader")"
    [ -n "$published" ] && printf 'published: %s\n' "$published"
    [ -n "$duration" ]  && printf 'duration: %s\n' "$duration"
    printf 'transcribed: %s\n' "$(date +%F)"
    printf 'model: ggml-%s\n' "$model"
    printf 'tags:\n  - transcript\n'
    echo "---"
    printf '\n# %s\n' "$title"
    [ -n "$caption" ] && [ "$caption" != "$title" ] && printf '\n## Caption\n\n%s\n' "$caption"
    [ -n "$desc" ]       && printf '\n## Visual overview\n\n%s\n' "$desc"
    [ -n "$frames_md" ]  && printf '\n## Key frames\n\n%s' "$frames_md"
    printf '\n## Transcript\n\n%s\n' "$transcript"
  } > "$out"

  echo "✓ $out"
  [ -n "$frames_md" ] && echo "  frames: $framedir"
  if [ "$keep" = true ] && [ -s "$wav" ]; then cp -f "$wav" "$outdir/$base.wav"; echo "  audio: $outdir/$base.wav"; fi
}

fail=0
for input in "$@"; do
  transcribe_one "$input" || { echo "skipped: $input" >&2; fail=1; }
done
exit "$fail"
