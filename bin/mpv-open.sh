#!/usr/bin/env bash
# mpv-open.sh <video> — play a video/audio file with mpv in a new terminal window.
# Engine for the "Open in mpv" Finder Quick Action (macos/services/). Works standalone too.

usage() {
  cat <<'EOF'
mpv-open.sh — play a media file with `mpv` in a NEW terminal window.

Engine for the "Open in mpv" Finder Quick Action (macos/services/), but works
standalone too. Opens iTerm if installed, otherwise Terminal, and runs `mpv` on
the file — mpv pops its own video window; the terminal carries mpv's console and
returns to a prompt when you quit mpv with `q`.

USAGE
  mpv-open.sh <video>

ARGUMENTS
  <video>   Path to the file to play (webm/mp4/mkv/mov/… anything mpv reads).
            Spaces/quotes are safe.

EXAMPLES
  mpv-open.sh clip.webm
  mpv-open.sh "~/Movies/my video.mp4"

NOTES
  Requires `mpv` (brew install mpv). macOS only — drives iTerm/Terminal via
  AppleScript (osascript).
EOF
}

set -euo pipefail

# Only -h/--help is intercepted; any other first arg is treated as the file path.
case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac

[ -n "${1:-}" ] || { echo "usage: mpv-open.sh <video>" >&2; exit 1; }

# command typed into the new window's login shell (printf %q keeps spaces/quotes safe).
# NOTE: must go through a real shell — iTerm's `command` parameter exec's directly
# (no `;`, no builtins) and its bare PATH won't resolve mpv on either machine.
cmd="mpv $(printf %q "$1")"

if [ -d /Applications/iTerm.app ]; then
  osascript - "$cmd" <<'APPLE'
on run argv
  tell application "iTerm"
    set newWindow to (create window with default profile)
    tell current session of newWindow to write text (item 1 of argv)
    activate
  end tell
end run
APPLE
else
  osascript - "$cmd" <<'APPLE'
on run argv
  tell application "Terminal"
    do script (item 1 of argv)
    activate
  end tell
end run
APPLE
fi
