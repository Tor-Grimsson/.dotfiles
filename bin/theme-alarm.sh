#!/bin/bash

# theme-alarm.sh — a real clock-time wake-up bundle: theme + Focus + Spotify +
# a Telegram nudge, fired daily by launchd. Companion to os-mode.sh (which only
# does relative delays, not a real alarm-clock time).

usage() {
  cat <<'EOF'
theme-alarm.sh — schedule (or run) a wake-up bundle: theme + Focus + Spotify + Telegram.

USAGE
  theme-alarm.sh --time HH:MM [--focus NAME] [--playlist URI] [--telegram]
      Writes/updates the launchd plist for a DAILY alarm at HH:MM, then prints
      the command to load it. Does not touch anything else — no theme flips,
      no Focus, no Spotify, until the scheduled time (or --run/--test).

  theme-alarm.sh --run [--focus NAME] [--playlist URI] [--telegram]
      Fires the bundle immediately. This is what the launchd job actually
      calls at the scheduled time. --test is an alias for --run, for a manual
      dry-run from Raycast without waiting for morning.

OPTIONS
  --focus NAME      Run a Shortcuts automation by name (`shortcuts run NAME`) —
                     e.g. a "Set Focus" shortcut you've already built in the
                     Shortcuts app. This script can't create the shortcut for
                     you; it only calls one that already exists.
  --playlist URI    A Spotify URI (spotify:playlist:... / spotify:album:... /
                     spotify:track:...) to start playing via the Spotify app.
  --telegram        Also send a nudge through the same bot tg-inbox.sh uses
                     (needs TG_BOT_TOKEN in ~/.secrets, same as tg-inbox.sh).

EXAMPLES
  theme-alarm.sh --time 07:15 --focus "Personal" --playlist "spotify:playlist:xxxx" --telegram
  theme-alarm.sh --test --playlist "spotify:playlist:xxxx"

NOTES
  --time only ever writes the plist + prints the load command — it never runs
  `launchctl` itself (you load it, same as every other launchd job in this repo).
EOF
}

PLIST_PATH="$HOME/.dotfiles/macos/launchd/com.kolkrabbi.theme-alarm.plist"
SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

do_focus() {
  [ -n "$1" ] || return 0
  shortcuts run "$1" >/dev/null 2>&1 || echo "theme-alarm.sh: 'shortcuts run \"$1\"' failed — does that shortcut exist?" >&2
}

do_playlist() {
  [ -n "$1" ] || return 0
  osascript -e "tell application \"Spotify\" to play track \"$1\"" >/dev/null 2>&1 \
    || echo "theme-alarm.sh: Spotify play failed for '$1'" >&2
}

do_telegram() {
  local token="${TG_BOT_TOKEN:-}"
  [ -n "$token" ] || { echo "theme-alarm.sh: --telegram needs TG_BOT_TOKEN in ~/.secrets (same as tg-inbox.sh)" >&2; return 1; }
  curl -fsS "https://api.telegram.org/bot${token}/sendMessage" \
    --data-urlencode "chat_id=${TG_CHAT_ID:-6300800383}" \
    --data-urlencode "text=⏰ theme-alarm fired — get up." >/dev/null
}

run_bundle() {
  local focus="" playlist="" telegram=0
  while [ $# -gt 0 ]; do
    case "$1" in
      --focus) focus="$2"; shift 2 ;;
      --playlist) playlist="$2"; shift 2 ;;
      --telegram) telegram=1; shift ;;
      *) echo "theme-alarm.sh: unknown arg '$1' (see -h)" >&2; exit 1 ;;
    esac
  done
  "$SELF" -d  # wake = force Light, reuses os-mode.sh
  do_focus "$focus"
  do_playlist "$playlist"
  [ "$telegram" -eq 1 ] && do_telegram
}

write_plist() {
  local time="$1"; shift
  local hour="${time%%:*}" minute="${time##*:}"
  hour=$((10#$hour)); minute=$((10#$minute))
  cat > "$PLIST_PATH" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.kolkrabbi.theme-alarm</string>
	<key>ProgramArguments</key>
	<array>
		<string>$SELF</string>
		<string>--run</string>
$(for a in "$@"; do printf '\t\t<string>%s</string>\n' "$a"; done)
	</array>
	<key>StartCalendarInterval</key>
	<dict>
		<key>Hour</key>
		<integer>$hour</integer>
		<key>Minute</key>
		<integer>$minute</integer>
	</dict>
</dict>
</plist>
PLIST
  echo "wrote $PLIST_PATH (daily at $time)"
  echo "load it:  launchctl bootstrap gui/\$(id -u) $PLIST_PATH"
  echo "reload after editing:  launchctl bootout gui/\$(id -u)/com.kolkrabbi.theme-alarm; launchctl bootstrap gui/\$(id -u) $PLIST_PATH"
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  --time)
    time="$2"; shift 2
    write_plist "$time" "$@"
    ;;
  --run|--test)
    shift
    run_bundle "$@"
    ;;
  *) echo "theme-alarm.sh: unknown arg '${1:-}' (see -h)" >&2; exit 1 ;;
esac
