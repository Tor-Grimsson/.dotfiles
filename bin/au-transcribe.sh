#!/usr/bin/env bash
# au-transcribe.sh — transcribe an online video/audio URL (yt-dlp) or a local media
# file to a markdown note: metadata + caption frontmatter/body, whisper transcript.

usage() {
  cat <<'EOF'
au-transcribe.sh — URL or local media → markdown transcript note (yt-dlp + whisper.cpp).

Fetches a video/audio URL with yt-dlp (YouTube, TikTok + ~1800 sites) OR reads a
local media file, extracts 16 kHz mono audio (ffmpeg), transcribes it with
whisper.cpp (whisper-cli), and writes one <slug>.md per input: YAML frontmatter
(title, source, uploader, published, duration, model) + the posted caption + the
spoken transcript.

USAGE
  au-transcribe.sh [-m MODEL] [-l LANG] [-o OUTDIR] [-c BROWSER] [-M] [-k] <url|file> [more…]

OPTIONS
  -m  whisper model (default: base). tiny|base|small|medium|large-v3, plus .en
      English-only variants (faster). Downloaded once on first use to
      $WHISPER_MODEL_DIR (default ~/.cache/whisper). e.g. -m small.en
  -l  spoken-language hint (default: auto). e.g. -l en, -l is.
  -o  output directory for the .md (default: current dir).
  -c  load yt-dlp cookies from a browser (chrome|firefox|safari|edge|brave|…)
      for login-gated URLs. e.g. -c firefox. URLs only; ignored for local files.
  -M  also ask the `llm` CLI to identify the movie/show the clip is from, using
      the caption, top comments (fetched with the video, when available), and the
      dialogue transcript. Writes a `movie:` frontmatter field + a "## Movie ID"
      section. Best-effort — answers UNKNOWN when unsure. Off by default.
  -k  keep the extracted .wav beside the .md (default: discarded).
  -h  show this help.

EXAMPLES
  au-transcribe.sh https://www.tiktok.com/@user/video/123
  au-transcribe.sh -M https://www.tiktok.com/@user/video/123     # + identify the movie
  au-transcribe.sh -m small -l en https://youtu.be/dQw4w9WgXcQ
  au-transcribe.sh -o ~/Notes/transcripts talk.mp4
  au-transcribe.sh https://youtu.be/a https://youtu.be/b          # batch

NOTES
  - Deps: ffmpeg + whisper-cli (whisper.cpp) + jq, plus yt-dlp for URLs. All in
    the Brewfile; a local-file input doesn't need yt-dlp. The -M movie-ID adds the
    `llm` CLI (uv tool, not the Brewfile); override its model with $AU_LLM_MODEL.
  - The caption/description is pulled straight from yt-dlp metadata (no ASR);
    only the spoken transcript runs through whisper. Local files have no caption.
  - Models: base ≈ 142 MB (fast, multilingual); small/medium are slower + more
    accurate; *.en are English-only. Override the download host with
    $WHISPER_MODEL_URL_BASE.
  - whisper.cpp prints Metal/backend lines to stderr on every run — startup
    noise, not an error.
EOF
}

case "${1:-}" in -h|--help|"") usage; exit 0 ;; esac

set -euo pipefail

model="base"; lang="auto"; outdir="."; keep=false; identify=false; cookies=""
while getopts "m:l:o:c:kMh" opt; do
  case "$opt" in
    m) model="$OPTARG" ;;
    l) lang="$OPTARG" ;;
    o) outdir="$OPTARG" ;;
    c) cookies="$OPTARG" ;;
    k) keep=true ;;
    M) identify=true ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))
[ "$#" -ge 1 ] || { echo "error: need at least one URL or media file" >&2; usage >&2; exit 1; }

command -v ffmpeg >/dev/null || { echo "error: ffmpeg not found" >&2; exit 1; }
command -v jq     >/dev/null || { echo "error: jq not found" >&2; exit 1; }
whisper=""
for c in whisper-cli whisper-cpp; do
  if command -v "$c" >/dev/null; then whisper="$c"; break; fi
done
[ -n "$whisper" ] || { echo "error: whisper-cli not found (brew install whisper-cpp)" >&2; exit 1; }

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

transcribe_one() {
  local input="$1"
  local tmp; tmp=$(mktemp -d "${TMPDIR:-/tmp}/au-transcribe.XXXXXX")
  trap 'rm -rf "$tmp"' RETURN

  local title uploader source published duration caption platform audio_src

  if [[ "$input" =~ ^https?:// ]]; then
    command -v yt-dlp >/dev/null || { echo "error: yt-dlp not found (needed for URLs)" >&2; return 1; }
    echo "▸ fetching: $input" >&2
    # 'download' = TikTok's muxed source format (reliably has audio); some TikTok
    # video formats are mislabeled as having aac but download video-only, so prefer
    # a real audio stream first, then download, then bare best.
    local ytflags=(--no-warnings --no-playlist -f 'bestaudio/download/best' --write-info-json)
    [ -n "$cookies" ]      && ytflags+=(--cookies-from-browser "$cookies")
    [ "$identify" = true ] && ytflags+=(--write-comments)
    if ! yt-dlp "${ytflags[@]}" -o "$tmp/src.%(ext)s" "$input"; then
      echo "error: yt-dlp failed on $input" >&2; return 1
    fi
    local info
    info=$(find "$tmp" -maxdepth 1 -name '*.info.json' | sort | head -1)
    [ -n "$info" ] || { echo "error: no metadata json for $input" >&2; return 1; }
    audio_src=$(find "$tmp" -maxdepth 1 -type f ! -name '*.info.json' | sort | head -1)
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
    platform="local"; published=""; duration=""; caption=""; audio_src="$input"
  fi

  [ -n "${audio_src:-}" ] && [ -f "$audio_src" ] || { echo "error: no audio for $input" >&2; return 1; }

  # → 16 kHz mono PCM wav, the input whisper.cpp expects
  local wav="$tmp/audio.wav"
  if ! ffmpeg -nostdin -y -loglevel error -i "$audio_src" -ar 16000 -ac 1 -c:a pcm_s16le "$wav"; then
    echo "error: ffmpeg audio extract failed for $input" >&2; return 1
  fi

  echo "▸ transcribing ($model, lang=$lang)…" >&2
  if ! "$whisper" -m "$model_file" -f "$wav" -l "$lang" -nt -np -otxt -of "$tmp/transcript" >/dev/null 2>&1; then
    echo "error: whisper failed for $input" >&2; return 1
  fi
  local transcript=""
  if [ -f "$tmp/transcript.txt" ]; then transcript=$(sed -E '/^[[:space:]]*$/d; s/^[[:space:]]+//' "$tmp/transcript.txt"); fi
  [ -n "$transcript" ] || transcript="_(no speech detected)_"

  # optional: ask the llm CLI to name the movie/show this clip is from
  local movie="" movie_id_block=""
  if [ "$identify" = true ]; then
    if ! command -v llm >/dev/null; then
      echo "warning: -M set but llm not found — skipping movie ID for $input" >&2
    else
      # top comments by like count (when the extractor returned any)
      local comments=""
      if [ -n "${info:-}" ] && [ -f "${info:-}" ]; then
        comments=$(jq -r '(.comments // []) | sort_by(-(.like_count // 0)) | .[0:30]
                          | map(.text // empty) | map(select(length>0)) | .[]' \
                   "$info" 2>/dev/null | head -c 4000 || true)
      fi
      local prompt
      prompt=$(cat <<PROMPT
You are identifying which movie (or TV show) a short video clip is taken from.
Use the signals below; any of them may be empty, wrong, or unrelated to the film.

CAPTION:
${caption:-(none)}

TOP COMMENTS:
${comments:-(none)}

DIALOGUE TRANSCRIPT:
${transcript}

Answer in exactly this format:
First line: the title and year, e.g. "The Matrix (1999)" — or the single word UNKNOWN if you cannot identify it with reasonable confidence. Do not guess wildly.
Following lines: one or two short sentences of justification, naming which signal you relied on.
PROMPT
)
      local llm_args=()
      [ -n "${AU_LLM_MODEL:-}" ] && llm_args=(-m "$AU_LLM_MODEL")
      echo "▸ identifying movie (llm)…" >&2
      local raw=""
      raw=$(llm ${llm_args[@]+"${llm_args[@]}"} "$prompt" 2>/dev/null || true)
      if [ -n "$raw" ]; then
        # first line = the title (strip any markdown heading/emphasis the model added)
        movie=$(printf '%s\n' "$raw" | head -1 | sed -E 's/^[[:space:]#>*_-]+//; s/[[:space:]*_]+$//')
        # the rest = justification
        local justification
        justification=$(printf '%s\n' "$raw" | tail -n +2 | sed -E '/^[[:space:]]*$/d; s/^[[:space:]]+//')
        if [ -n "$justification" ]; then
          movie_id_block=$(printf '**%s**\n\n%s' "$movie" "$justification")
        else
          movie_id_block=$(printf '**%s**' "$movie")
        fi
      else
        echo "warning: movie ID failed (llm error) for $input" >&2
      fi
    fi
  fi

  # assemble the note (skip clobbering an existing <slug>.md)
  local slug; slug=$(slugify "$title"); [ -n "$slug" ] || slug="transcript"
  local out="$outdir/$slug.md"; local n=2
  while [ -e "$out" ]; do out="$outdir/$slug-$n.md"; n=$((n + 1)); done

  {
    echo "---"
    printf 'title: %s\n' "$(yaml_str "$title")"
    [ -n "$source" ]    && printf 'source: %s\n' "$source"
    [ -n "$platform" ]  && printf 'platform: %s\n' "$platform"
    [ -n "$uploader" ]  && printf 'uploader: %s\n' "$(yaml_str "$uploader")"
    [ -n "$published" ] && printf 'published: %s\n' "$published"
    [ -n "$duration" ]  && printf 'duration: %s\n' "$duration"
    [ -n "$movie" ]     && printf 'movie: %s\n' "$(yaml_str "$movie")"
    printf 'transcribed: %s\n' "$(date +%F)"
    printf 'model: ggml-%s\n' "$model"
    printf 'tags:\n  - transcript\n'
    echo "---"
    printf '\n# %s\n' "$title"
    [ -n "$caption" ] && [ "$caption" != "$title" ] && printf '\n## Caption\n\n%s\n' "$caption"
    [ -n "$movie_id_block" ] && printf '\n## Movie ID\n\n%s\n' "$movie_id_block"
    printf '\n## Transcript\n\n%s\n' "$transcript"
  } > "$out"

  echo "✓ $out"
  if [ "$keep" = true ]; then cp -f "$wav" "$outdir/$slug.wav"; echo "  audio: $outdir/$slug.wav"; fi
}

fail=0
for input in "$@"; do
  transcribe_one "$input" || { echo "skipped: $input" >&2; fail=1; }
done
exit "$fail"
