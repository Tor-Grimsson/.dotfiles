#!/bin/zsh

# fs-reveal.sh — open a Finder window at PATH (default: current directory).
# Plain mode reveals the path. -f/--float opens a NEW window and, on AeroSpace
# setups that auto-assign Finder to a fixed workspace, pulls that one window back
# to the CURRENT workspace and floats it — targeted by its AeroSpace window-id.

usage() {
  cat <<'EOF'
fs-reveal.sh — open a Finder window at PATH (default: current directory).

USAGE
  fs-reveal.sh [-f|--float] [PATH]

MODES
  (default)     Open Finder at PATH via macOS `open`. A directory opens as a
                window; a file is revealed (selected) in its containing folder.
  -f, --float   Open a NEW Finder window at PATH, then — for AeroSpace users
                whose config auto-assigns Finder to a fixed workspace (e.g.
                `on-window-detected` → `move-node-to-workspace W`) — move that
                one window back to the CURRENTLY focused workspace and set it
                floating. Acts only on the new window (by its window-id).

ARGUMENTS
  PATH   Directory or file. Default: current directory ($PWD). A leading `~` is
         expanded. Must exist. In -f mode a file floats its parent folder.

EXAMPLES
  fs-reveal.sh                # Finder at the current dir
  fs-reveal.sh ~/dev          # Finder at ~/dev
  fs-reveal.sh notes.md       # reveal (select) notes.md in its folder
  fs-reveal.sh -f             # new FLOATING Finder window here, on this workspace
  fs-reveal.sh -f ~/dev       # ditto, at ~/dev

NOTES
  -f needs `aerospace` on PATH; without it, it just opens a new window (no move).
  Bypasses the blanket Finder-to-W rule per-window without editing aerospace.toml.
EOF
}

FLOAT=0
case "${1:-}" in
  -h|--help)  usage; exit 0 ;;
  -f|--float) FLOAT=1; shift ;;
esac

# Resolve PATH: default cwd, expand a leading ~, make absolute, require existence.
TARGET="${1:-$PWD}"
TARGET="${TARGET/#\~/$HOME}"
TARGET="${TARGET:a}"
if [[ ! -e "$TARGET" ]]; then
  echo "❌ No such path: $TARGET" >&2
  exit 1
fi

# ── Plain mode: dir → open a window; file → reveal it in its folder ───────────
if (( ! FLOAT )); then
  if [[ -d "$TARGET" ]]; then open "$TARGET"; else open -R "$TARGET"; fi
  exit 0
fi

# ── Float mode ───────────────────────────────────────────────────────────────
# Finder windows show folders, so a file floats its parent (:h = dirname in zsh).
DIR="$TARGET"
[[ -d "$DIR" ]] || DIR="${TARGET:h}"

open_new_window() {
  osascript -e "tell application \"Finder\" to make new Finder window to (POSIX file \"$DIR\" as alias)" >/dev/null
}

# No aerospace → just open a plain new window and stop (nothing to bypass).
if ! command -v aerospace >/dev/null 2>&1; then
  open_new_window
  echo "ℹ️  aerospace not found — opened a new window without float/move."
  exit 0
fi

WS=$(aerospace list-workspaces --focused --format '%{workspace}')
# --all can't be combined with --app-bundle-id, so enumerate everything and filter.
finder_ids() {
  aerospace list-windows --all --format '%{window-id}|%{app-bundle-id}' \
    | awk -F'|' '$2=="com.apple.finder"{print $1}'
}

# Remember the Finder windows that already exist, so we can spot the new one.
typeset -A seen
for id in ${(f)"$(finder_ids)"}; do [[ -n "$id" ]] && seen[$id]=1; done

open_new_window

# aerospace needs a beat to detect the new window (and its own rule to fire).
NEWID=""
for _ in {1..30}; do
  for id in ${(f)"$(finder_ids)"}; do
    if [[ -n "$id" && -z "${seen[$id]}" ]]; then NEWID=$id; break 2; fi
  done
  sleep 0.1
done

if [[ -z "$NEWID" ]]; then
  echo "⚠️  Opened the window but couldn't identify it via aerospace; left as-is." >&2
  exit 0
fi

# Undo the blanket assignment for THIS window: back to the current workspace, float it.
aerospace move-node-to-workspace "$WS" --window-id "$NEWID"
aerospace layout floating --window-id "$NEWID"
echo "✅ Floating Finder window ($DIR) on workspace $WS  [window-id $NEWID]"
