#!/usr/bin/env bash
# glow-open.sh <file.md> — render a markdown file with glow in a new terminal window.
# Engine for the "Open in glow" Finder Quick Action (macos/services/). Works standalone too.
set -euo pipefail
[ -n "${1:-}" ] || { echo "usage: glow-open.sh <file.md>" >&2; exit 1; }

# command typed into the new window's login shell (printf %q keeps spaces/quotes safe).
# NOTE: must go through a real shell — iTerm's `command` parameter exec's directly
# (no `;`, no builtins) and its bare PATH won't resolve glow on either machine.
cmd="glow -p $(printf %q "$1")"

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
