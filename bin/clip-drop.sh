#!/bin/zsh

# clip-drop.sh — dump the clipboard image into an inbox; --yazi opens yazi on it;
# --note/--review pair the image with a markdown doc in its own folder.
#
# Solves "I have an image in the clipboard and don't know where to put it":
# capture FIRST to a staging inbox, then file it later. When the screenshot is
# EVIDENCE (an issue, a review), --note/--review fold image + .md together so
# the words live next to the picture.

usage() {
  cat <<'EOF'
clip-drop.sh — save the CLIPBOARD image to an inbox; optionally with a linked .md.

Plain: dumps the clipboard image to <DIR>/clip_<timestamp>.png (via pngpaste)
and prints the path. Unfiled drops pile up in the inbox.

Modes (mutually exclusive):
  --note [NAME]     one-off issue: saves into its own folder <DIR>/<NAME>/ and
                    creates/appends <NAME>.md there (title + image embed).
                    NAME defaults to clip_<timestamp>; rename later in yazi.
  --review [NAME]   ongoing session: with NAME, starts (or switches to) that
                    review folder and remembers it as current. Bare, appends
                    the capture to the CURRENT review folder's .md.
                    The pointer is <DIR>/.current-review.
  --yazi            after saving, exec yazi hovering the saved file. Combines
                    with either mode.
  --desc TEXT       with --note/--review: write TEXT under this capture's
                    image embed in the .md (a one-line annotation; open the
                    .md in your editor for longer bodies).
  --menu            interactive: a small fzf menu of the modes (file/drop/
                    note/review), prompting for a name and an optional
                    description where needed. What the tmux prefix Ctrl+P
                    popup runs. Needs fzf.

USAGE
  clip-drop.sh [--note [NAME] | --review [NAME]] [--yazi] [DIR]
  clip-drop.sh --menu [DIR]

ARGUMENTS
  DIR    inbox root. Defaults to ~/_inbox. Created with mkdir -p if missing.
         A leading ~ is expanded to $HOME.

NOTES
  Requires pngpaste (brew install pngpaste); yazi only with --yazi. Exits 1
  with an error if the clipboard holds no image, or if pngpaste isn't
  installed. `--review NAME` switches the current-review pointer even if the
  clipboard is empty — "start review" works before the first screenshot.
EOF
}

MODE=""
NAME=""
DESC=""
YAZI=0
MENU=0
POS=()
while (( $# )); do
  case "$1" in
    -h|--help)       usage; exit 0 ;;
    --yazi)          YAZI=1 ;;
    --menu)          MENU=1 ;;
    --desc)          DESC="${2:-}"; shift ;;
    --note|--review) MODE="${1#--}"
                     # optional NAME right after the flag — but never anything
                     # flag- or path-shaped (a DIR positional must stay a DIR)
                     if [[ -n "${2:-}" && "${2:0:1}" != "-" && "$2" != */* && "${2:0:1}" != "~" ]]; then NAME="$2"; shift; fi ;;
    *)               POS+=("$1") ;;
  esac
  shift
done

# Inbox root (positional), default ~/_inbox. Expand a leading ~ — often quoted.
ROOT="${POS[1]:-$HOME/_inbox}"
ROOT="${ROOT/#\~/$HOME}"

# --menu: pick a mode interactively, then re-invoke self with the right flags.
# The pause keeps the popup readable — without it, print-and-exit closes it
# before the saved path can be seen (yazi mode hands over instead).
if (( MENU )); then
  pause() { printf '\n[any key]'; read -k1 -s; }
  cur=""
  [[ -f "$ROOT/.current-review" ]] && cur=$(<"$ROOT/.current-review")
  items="file (yazi)"$'\n'"drop (just save)"$'\n'"note…"
  [[ -n "$cur" ]] && items+=$'\n'"review: $cur (append)"
  items+=$'\n'"review: start new…"
  # --preview '' kills the global FZF_DEFAULT_OPTS file-preview (bat) — menu
  # labels aren't paths, so the inherited preview just errors (same trap as
  # the sesh bind in .tmux.conf).
  choice=$(printf '%s\n' "$items" | fzf --prompt='capture > ' --layout=reverse --preview '') || exit 0
  case "$choice" in
    "file (yazi)")      exec "$0" --yazi "$ROOT" ;;
    "drop (just save)") "$0" "$ROOT"; pause ;;
    "note…")
      printf 'name: '; read name
      printf 'description (Enter = skip): '; read desc
      args=(--note)
      [[ -n "$name" ]] && args+=("$name")
      [[ -n "$desc" ]] && args+=(--desc "$desc")
      "$0" "${args[@]}" "$ROOT"; pause ;;
    "review: start new…")
      printf 'review name: '; read name
      if [[ -n "$name" ]]; then
        printf 'description (Enter = skip): '; read desc
        args=(--review "$name")
        [[ -n "$desc" ]] && args+=(--desc "$desc")
        "$0" "${args[@]}" "$ROOT"
      else
        echo "no name — cancelled"
      fi
      pause ;;
    review:*)
      printf 'description (Enter = skip): '; read desc
      args=(--review)
      [[ -n "$desc" ]] && args+=(--desc "$desc")
      "$0" "${args[@]}" "$ROOT"; pause ;;
  esac
  exit 0
fi

TS=$(date +"%Y%m%d_%H%M%S")

case "$MODE" in
  note)
    NAME="${NAME:-clip_$TS}"
    DIR="$ROOT/$NAME"
    ;;
  review)
    PTR="$ROOT/.current-review"
    if [[ -n "$NAME" ]]; then
      mkdir -p "$ROOT"
      printf '%s\n' "$NAME" > "$PTR"
    else
      NAME=$(cat "$PTR" 2>/dev/null || true)
      if [[ -z "$NAME" ]]; then
        echo "❌ No current review — start one: clip-drop.sh --review <name>"
        exit 1
      fi
    fi
    DIR="$ROOT/$NAME"
    ;;
  *)
    DIR="$ROOT"
    ;;
esac

mkdir -p "$DIR"
# Timestamped name; same-second captures get a _2/_3 suffix instead of clobbering.
FULL_PATH="$DIR/clip_$TS.png"
n=2
while [[ -e "$FULL_PATH" ]]; do FULL_PATH="$DIR/clip_${TS}_$n.png"; ((n++)); done
BASE="${FULL_PATH##*/}"

if pngpaste "$FULL_PATH" 2>/dev/null; then
  if [[ -n "$MODE" ]]; then
    MD="$DIR/$NAME.md"
    if [[ ! -f "$MD" ]]; then
      printf '# %s\n' "$NAME" > "$MD"
    fi
    printf '\n## %s\n![](%s)\n' "$(date +"%Y-%m-%d %H:%M:%S")" "$BASE" >> "$MD"
    if [[ -n "$DESC" ]]; then printf '\n%s\n' "$DESC" >> "$MD"; fi
    echo "✅ Saved to: $FULL_PATH"
    echo "📝 $MD"
  else
    echo "✅ Saved to: $FULL_PATH"
  fi
  if (( YAZI )); then
    exec yazi "$FULL_PATH"
  fi
else
  if [[ "$MODE" == "review" ]]; then
    echo "❌ No image in the clipboard (review '$NAME' is now current)."
  else
    echo "❌ No image in the clipboard (or pngpaste is missing)."
  fi
  exit 1
fi
