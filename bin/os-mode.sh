#!/bin/bash

# os-mode.sh — set or toggle macOS Light/Dark appearance, or schedule a
# relative delayed flip. For a real clock-time wake-up alarm, see theme-alarm.sh.

usage() {
  cat <<'EOF'
os-mode.sh — set or toggle macOS Light/Dark appearance.

USAGE
  os-mode.sh                     # toggle Light <-> Dark, right now
  os-mode.sh -d | --day          # force Light now
  os-mode.sh -n | --night        # force Dark now
  os-mode.sh -t | --timer 3h30m  # flip (toggle) after a relative delay, backgrounded

EXAMPLES
  os-mode.sh
  os-mode.sh -n
  os-mode.sh -t 45m
  os-mode.sh --timer 1h30m

NOTES
  Uses System Events' appearance-preferences "dark mode" property (osascript) —
  no extra dependency. -t/--timer parses Nh/Nm (3h30m, 45m, 2h) and backgrounds a
  single sleep-then-flip (nohup'd, survives the calling process exiting — e.g.
  a silent-mode Raycast hotkey). It's a one-shot RELATIVE delay, not a real
  clock-time alarm.
EOF
}

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

set_mode() { # $1 = true|false
  osascript -e "tell application \"System Events\" to tell appearance preferences to set dark mode to $1"
}

toggle_mode() {
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to (not dark mode)'
}

parse_duration() { # "3h30m" / "45m" / "2h" -> seconds
  local input="$1" hours=0 minutes=0
  [[ "$input" =~ ([0-9]+)h ]] && hours="${BASH_REMATCH[1]}"
  [[ "$input" =~ ([0-9]+)m ]] && minutes="${BASH_REMATCH[1]}"
  echo $(( hours * 3600 + minutes * 60 ))
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  -d|--day)   set_mode false ;;
  -n|--night) set_mode true ;;
  -t|--timer)
    [ -n "${2:-}" ] || { echo "os-mode.sh: -t/--timer needs a duration (e.g. 3h30m)" >&2; exit 1; }
    seconds=$(parse_duration "$2")
    [ "$seconds" -gt 0 ] || { echo "os-mode.sh: couldn't parse duration '$2' (want Nh/Nm, e.g. 3h30m)" >&2; exit 1; }
    nohup bash -c "sleep $seconds; '$SELF'" >/dev/null 2>&1 &
    disown
    echo "theme will flip in $2 (background pid $!)"
    ;;
  "") toggle_mode ;;
  *) echo "os-mode.sh: unknown arg '$1' (see -h)" >&2; exit 1 ;;
esac
