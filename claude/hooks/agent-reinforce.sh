#!/usr/bin/env bash
# UserPromptSubmit — inject standing-behaviour reinforcement on a cadence, so it
# survives long tool-heavy sessions instead of drifting out of attention. Replaces
# the old agent-reinforce skill bundle (agent-output-format + -rules + -memory),
# which could only re-load at /agent-init and /log-work — never mid-session.
#
# Cadence per session (keyed by session_id): FULL text on turn 1, COMPACT re-ground
# every 3rd turn after. Text lives in reinforce-{full,compact}.txt beside this
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
elif [ $((n % 3)) -eq 0 ]; then file="$dir/reinforce-compact.txt"
fi

msg=""
[ -n "$file" ] && msg=$(cat "$file" 2>/dev/null)

# agent-grant window (bin/agent-grant, flag = expiry epoch): while open, inject
# EVERY turn — it overrides the NO-GIT rule for reads and the agent must know.
gf="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.agent-grant"
if [ -f "$gf" ]; then
  exp=$(head -n1 "$gf" 2>/dev/null | tr -d '[:space:]')
  gnow=$(date +%s)
  case "$exp" in
    ''|*[!0-9]*) rm -f "$gf" ;;
    *)
      if [ "$gnow" -lt "$exp" ]; then
        grant="[grant] AGENT-GRANT WINDOW OPEN ($(( (exp - gnow + 59) / 60 ))m left): the user has temporarily allowed READ-ONLY git (log/show/diff/status/blame/branch/remote/…) plus downloads (git clone/fetch, wget, curl). The NO-GIT rule is suspended for READS this window — use it for what the task needs. Write git (add/commit/push/checkout/merge/…) remains forbidden, always."
        if [ -n "$msg" ]; then msg="$msg

$grant"; else msg="$grant"; fi
      else
        rm -f "$gf"
      fi
      ;;
  esac
fi

[ -n "$msg" ] || exit 0

python3 -c 'import sys, json
print(json.dumps({"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": sys.argv[1]}}))' "$msg" 2>/dev/null
exit 0
