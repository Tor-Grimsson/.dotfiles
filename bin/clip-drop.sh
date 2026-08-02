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
clip-drop.sh — clipboard image → ~/_inbox, or straight into a repo's lobby.

~/_inbox is the HOME. A bare word is a FOLDER NAME inside it, never a path —
so captures can't scatter into whatever directory your shell happens to be in.

EXAMPLES — the whole tool
  clip-drop.sh                      ~/_inbox/clip_<ts>.png
  clip-drop.sh bingo                ~/_inbox/bingo/clip_<ts>.png
  clip-drop.sh bingo --note         …/bingo/ + bingo.md with the embed
  clip-drop.sh --review audit       start a review, keep appending to it
  clip-drop.sh --review             append to the current review
  clip-drop.sh --yazi               save, then open yazi on the file
  clip-drop.sh --desc "1px low"     annotate this capture in the .md

  clip-drop.sh --kol-ds-ui topnav   kol-ds-ui/lobby/inbox/topnav.md + ledger row
  clip-drop.sh --humpty overload    humpty/lobby/inbox/overload.md + ledger row
  clip-drop.sh --kol-website hero   kol-website/lobby/inbox/hero.md + ledger row
  clip-drop.sh --dotfiles refcard   ~/.dotfiles/lobby/inbox/refcard.md + ledger row

  clip-drop.sh --menu               fzf picker over all of the above (prefix C-p)
  clip-drop.sh --lobby              list the registered lobbies

RULES
  same word twice   same folder — images and .md entries accumulate, nothing clobbers
  repo flags        one per registered lobby (files/folders.md `## lobby`); the .md
                    lands in <lobby>/inbox/, images in <lobby>/_assets/, and a
                    🔵 filed row is appended to the ledger (INDEX.md / LEDGER.md)
  --dir PATH        the escape hatch: use PATH as the inbox root instead of ~/_inbox
  needs             pngpaste (brew install pngpaste) · yazi only with --yazi

`--review NAME` switches the current-review pointer even with an empty clipboard,
so "start a review" works before the first screenshot.
EOF
}

MODE=""
NAME=""
DESC=""
LOBBY_WORD=""
DIR_OVERRIDE=""
YAZI=0
MENU=0
POS=()

# Lobby registry: the `## lobby` section of files/folders.md — one path catalog,
# two consumers (`files`/`to` print+jump, this resolves capture targets).
# Every registered lobby also answers as a flag: --<repo>, e.g. --humpty.
lobby_paths() {
  awk -v home="$HOME" '
    /^## / { shw = (tolower($0) ~ /lobby/); next }
    shw && /^\| *~\// { p = $0; sub(/^\| */, "", p); sub(/ *\|.*$/, "", p); sub(/^~/, home, p); print p }
  ' "$HOME/.dotfiles/files/folders.md" 2>/dev/null
}
# flag name for a lobby path = the folder that holds it (…/kol-ds-ui/lobby -> kol-ds-ui,
# …/.dotfiles/lobby -> dotfiles)
lobby_flag() { local d="${1%/lobby}"; d="${d##*/}"; printf '%s' "${d#.}"; }

while (( $# )); do
  case "$1" in
    -h|--help)       usage; exit 0 ;;
    --yazi)          YAZI=1 ;;
    --menu)          MENU=1 ;;
    --desc)          DESC="${2:-}"; shift ;;
    --dir)           DIR_OVERRIDE="${2:-}"; shift ;;
    --lobby)         MODE="lobby"
                     if [[ -n "${2:-}" && "${2:0:1}" != "-" ]]; then LOBBY_WORD="$2"; shift; fi
                     if [[ -n "${2:-}" && "${2:0:1}" != "-" ]]; then NAME="$2"; shift; fi ;;
    --note|--review) MODE="${1#--}"
                     if [[ -n "${2:-}" && "${2:0:1}" != "-" ]]; then NAME="$2"; shift; fi ;;
    --*)             # a registered lobby's own flag: --humpty, --kol-ds-ui, …
                     want="${1#--}"; hit=""
                     while read -r lp; do
                       [[ -n "$lp" && "$(lobby_flag "$lp")" == "$want" ]] && hit="$lp"
                     done < <(lobby_paths)
                     if [[ -n "$hit" ]]; then
                       MODE="lobby"; LOBBY_WORD="$want"
                       if [[ -n "${2:-}" && "${2:0:1}" != "-" ]]; then NAME="$2"; shift; fi
                     else
                       echo "clip-drop: unknown flag '$1' (lobbies: $(lobby_paths | while read -r l; do printf -- '--%s ' "$(lobby_flag "$l")"; done))" >&2
                       exit 1
                     fi ;;
    *)               POS+=("$1") ;;
  esac
  shift
done

# ~/_inbox is the HOME. A bare positional is a FOLDER NAME inside it — never a
# path (that used to land captures in the shell's cwd). --dir is the override.
ROOT="${DIR_OVERRIDE:-$HOME/_inbox}"
ROOT="${ROOT/#\~/$HOME}"
if [[ -n "${POS[1]:-}" && -z "$NAME" ]]; then
  NAME="${POS[1]##*/}"          # defensive: strip any path the user typed
  [[ -z "$MODE" ]] && MODE="folder"
fi

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
  while read -r lp; do [[ -n "$lp" ]] && items+=$'\n'"lobby: $(lobby_flag "$lp") …"; done < <(lobby_paths)
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
    lobby:*)
      target="${${choice#lobby: }% …}"
      printf 'issue name: '; read name
      if [[ -n "$name" ]]; then
        printf 'description (Enter = skip): '; read desc
        args=(--lobby "$target" "$name")
        [[ -n "$desc" ]] && args+=(--desc "$desc")
        "$0" "${args[@]}"
      else
        echo "no name — cancelled"
      fi
      pause ;;
  esac
  exit 0
fi

TS=$(date +"%Y%m%d_%H%M%S")

# --lobby: resolve WORD → a registered lobby dir, then file the capture there as
# <lobby>/inbox/<NAME>.md + <lobby>/_assets/<NAME>_<ts>.png, AND append the
# ledger row. Spec: docs/operations/systems/lobby/
if [[ "$MODE" == "lobby" ]]; then
  paths=("${(@f)$(lobby_paths)}")
  paths=(${paths:#})
  if (( ${#paths} == 0 )); then
    echo "❌ No lobby registered — add one to the '## lobby' section of files/folders.md"
    exit 1
  fi
  if [[ -z "$LOBBY_WORD" ]]; then
    echo "lobbies (clip-drop.sh --lobby <word> [name]):"
    printf '  %s\n' "${paths[@]/#$HOME/~}"
    exit 0
  fi
  matches=(${(M)paths:#*${LOBBY_WORD}*})
  if (( ${#matches} == 0 )); then
    echo "❌ No lobby matching '$LOBBY_WORD'. Registered:"
    printf '  %s\n' "${paths[@]/#$HOME/~}"
    exit 1
  elif (( ${#matches} > 1 )); then
    echo "❌ '$LOBBY_WORD' matches several — be more specific:"
    printf '  %s\n' "${matches[@]/#$HOME/~}"
    exit 1
  fi
  DIR="${matches[1]}"
  [[ -d "$DIR" ]] || { echo "❌ Registered lobby does not exist: $DIR"; exit 1; }
  NAME="${NAME:-clip_$TS}"
  # Entries live in inbox/ (2026-07-31) so INDEX.md can be the one ledger without
  # competing with entries for the lobby root. Images stay in _assets/, out of the
  # queue listing.
  INBOX="$DIR/inbox"
  ASSETS="$DIR/_assets"
  mkdir -p "$INBOX" "$ASSETS"
  FULL_PATH="$ASSETS/${NAME}_$TS.png"
  n=2
  while [[ -e "$FULL_PATH" ]]; do FULL_PATH="$ASSETS/${NAME}_${TS}_$n.png"; ((n++)); done
  BASE="${FULL_PATH##*/}"
  if pngpaste "$FULL_PATH" 2>/dev/null; then
    MD="$INBOX/$NAME.md"
    NEW=0
    [[ -f "$MD" ]] || { NEW=1
      printf '# %s\n\n**Staged:** %s · via clip-drop\n\n---\n' \
        "$NAME" "$(date +%Y-%m-%d)" > "$MD"; }
    printf '\n## %s\n![](../_assets/%s)\n' "$(date +"%Y-%m-%d %H:%M:%S")" "$BASE" >> "$MD"
    [[ -n "$DESC" ]] && printf '\n%s\n' "$DESC" >> "$MD"

    # LAW: no entry without a ledger row. An entry that exists without a row is
    # drift the moment it lands — that is how kol-website's ShowSansItalicDisplay
    # sat unrecorded for a day. Ledger is INDEX.md, or LEDGER.md (humpty's).
    LEDGER="$DIR/INDEX.md"; [[ -f "$LEDGER" ]] || LEDGER="$DIR/LEDGER.md"
    if (( NEW )) && [[ -f "$LEDGER" ]]; then
      ROW="| 🔵 | [$NAME](inbox/$NAME.md) | ${DESC:-staged via clip-drop — needs a one-line summary} | $(date +%Y-%m-%d) | \`filed\` |"
      if grep -q '^## Queue' "$LEDGER"; then
        # append under the Queue table: after its last row (last line starting "| ")
        awk -v row="$ROW" '
          /^## Queue/ { inq = 1 }
          inq && /^## / && !/^## Queue/ && !done { print row; print ""; done = 1; inq = 0 }
          { print }
          END { if (inq && !done) print row }
        ' "$LEDGER" > "$LEDGER.tmp" && mv "$LEDGER.tmp" "$LEDGER"
      else
        printf '\n%s\n' "$ROW" >> "$LEDGER"
      fi
      echo "📒 ${LEDGER##*/} row added (🔵 filed)"
    fi

    echo "✅ Saved to: $FULL_PATH"
    echo "📝 $MD"
    (( YAZI )) && exec yazi "$MD"
    exit 0
  else
    echo "❌ No image in the clipboard (or pngpaste is missing)."
    exit 1
  fi
fi

case "$MODE" in
  folder)                        # bare word = a folder inside ~/_inbox, no .md
    DIR="$ROOT/$NAME"
    MODE=""                      # image only, like a plain drop
    ;;
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
