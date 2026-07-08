#!/usr/bin/env bash
# UserPromptSubmit — inject standing-behaviour reinforcement on a cadence, so it
# survives long tool-heavy sessions instead of drifting out of attention. Replaces
# the old agent-reinforce skill bundle (agent-output-format + -rules + -memory),
# which could only re-load at /agent-init and /log-work — never mid-session.
#
# Cadence per session (keyed by session_id): FULL text on turn 1, COMPACT re-ground
# every 5th turn after. Text lives in reinforce-{full,compact}.txt beside this
# script. Fail-open: any error exits 0 (never blocks a prompt).

input=$(cat 2>/dev/null)

sid=$(printf '%s' "$input" | python3 -c 'import sys,json
try:
    print(json.load(sys.stdin).get("session_id","") or "nosid")
except Exception:
    print("nosid")' 2>/dev/null)
[ -n "$sid" ] || sid="nosid"

f="${TMPDIR:-/tmp}/claude-reinforce-${sid}.count"
n=$(cat "$f" 2>/dev/null); n=$((n + 1)); printf '%s' "$n" > "$f" 2>/dev/null

dir=$(dirname "$0")
file=""
if [ "$n" -eq 1 ]; then file="$dir/reinforce-full.txt"
elif [ $((n % 5)) -eq 0 ]; then file="$dir/reinforce-compact.txt"
fi
[ -n "$file" ] || exit 0

msg=$(cat "$file" 2>/dev/null)
[ -n "$msg" ] || exit 0

python3 -c 'import sys, json
print(json.dumps({"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": sys.argv[1]}}))' "$msg" 2>/dev/null
exit 0
