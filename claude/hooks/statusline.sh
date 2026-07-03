#!/usr/bin/env bash
# Status line: ponytail mode badge + model + cwd + context-window usage + token usage.
# The ponytail badge logic is mirrored here (not sourced) from the plugin's own script
# so a plugin update can't silently change/break this statusline:
#   ~/.claude/plugins/marketplaces/ponytail/hooks/ponytail-statusline.sh

input=$(cat)
sep=" $(printf '\033[2m\342\224\202\033[0m') "
out=""
add() { [ -n "$1" ] && out="${out:+$out$sep}$1"; }

# ── ponytail mode badge ──────────────────────────────────────────────────────
flag="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.ponytail-active"
if [ -f "$flag" ]; then
  mode=$(head -n1 "$flag" | tr -d '[:space:]')
  if [ -z "$mode" ] || [ "$mode" = "full" ]; then
    add "$(printf '\033[38;5;108m[PONYTAIL]\033[0m')"
  else
    add "$(printf '\033[38;5;108m[PONYTAIL:%s]\033[0m' "$(printf '%s' "$mode" | tr '[:lower:]' '[:upper:]')")"
  fi
fi

# ── model (session info) ─────────────────────────────────────────────────────
add "$(printf '%s' "$input" | jq -r '.model.display_name // empty')"

# ── cwd, ~-relative ───────────────────────────────────────────────────────────
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
add "${cwd/#$HOME/~}"

# ── context-window usage (pre-calculated by Claude Code) ─────────────────────
used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
[ -n "$used_pct" ] && add "$(printf 'ctx %.0f%%' "$used_pct")"

# ── token usage (input+output tokens counted so far this session) ────────────
in_tok=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // empty')
out_tok=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // empty')
if [ -n "$in_tok" ] && [ -n "$out_tok" ]; then
  tok_fmt=$(awk -v n="$((in_tok + out_tok))" 'BEGIN { if (n >= 1000) printf "%.1fk", n / 1000; else printf "%d", n }')
  add "tok $tok_fmt"
fi

# ── plan rate-limit quota (Settings → Usage: 5h session / 7d weekly) ──────────
now=$(date +%s)

five_pct=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$five_pct" ]; then
  five_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
  reset_str=""
  if [ -n "$five_reset" ]; then
    five_epoch=$(printf '%s' "$five_reset" | jq -Rr 'fromdateiso8601? // empty')
    if [ -n "$five_epoch" ]; then
      mins=$(( (five_epoch - now) / 60 ))
      [ "$mins" -lt 0 ] && mins=0
      if [ "$mins" -ge 60 ]; then
        reset_str=" (resets $((mins / 60))h$((mins % 60))m)"
      else
        reset_str=" (resets ${mins}m)"
      fi
    fi
  fi
  add "$(printf '5h %.0f%%%s' "$five_pct" "$reset_str")"
fi

week_pct=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$week_pct" ]; then
  week_reset=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
  reset_str=""
  if [ -n "$week_reset" ]; then
    week_epoch=$(printf '%s' "$week_reset" | jq -Rr 'fromdateiso8601? // empty')
    [ -n "$week_epoch" ] && reset_str=" (resets $(date -r "$week_epoch" '+%a %H:%M'))"
  fi
  add "$(printf '7d %.0f%%%s' "$week_pct" "$reset_str")"
fi

printf '%s\n' "$out"
