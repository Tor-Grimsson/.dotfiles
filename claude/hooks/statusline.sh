#!/usr/bin/env bash
# Status line: humpty dial badge + model + cwd + context-window usage + token usage.
# The humpty badge reads the plugin's state file directly (not sourced) so a plugin
# update can't silently change/break this statusline. State contract:
#   ${CLAUDE_CONFIG_DIR:-~/.claude}/.humpty-active — key=value lines, muzzle=1..4

input=$(cat)
sep=" $(printf '\033[2m\342\224\202\033[0m') "
out=""
add() { [ -n "$1" ] && out="${out:+$out$sep}$1"; }

# ── humpty dial badge — solid block in the tmux active-window yellow ─────────
flag="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.humpty-active"
if [ -f "$flag" ]; then
  lvl=$(sed -n 's/^muzzle=//p' "$flag" | head -n1 | tr -d '[:space:]')
  case "$lvl" in
    1) name="loose" ;; 3) name="strict" ;; 4) name="muzzle" ;; *) name="" ;;
  esac
  # 256-color 214/234 — this renderer approximates truecolor badly (learned live),
  # so the badge is the SOURCE of the yellow: tmux's window-status-current-style
  # was matched to it (bg=#ffaf00 = colour214) on 2026-08-01, not the other way round.
  add "$(printf '\033[1;48;5;214;38;5;234m humpty-dumpty%s \033[0m' "${name:+:$name}")"
fi

# ── agent-grant badge — git-read + download window open (bin/agent-grant) ────
gflag="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.agent-grant"
if [ -f "$gflag" ]; then
  g_exp=$(head -n1 "$gflag" | tr -d '[:space:]')
  g_now=$(date +%s)
  if [ "$g_exp" -gt "$g_now" ] 2>/dev/null; then
    add "$(printf '\033[1;33m[GRANT git %dm]\033[0m' $(( (g_exp - g_now + 59) / 60 )))"
  else
    rm -f "$gflag"
  fi
fi

# ── model (session info) — gruvbox purple ────────────────────────────────────
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
[ -n "$model" ] && add "$(printf '\033[38;5;175m%s\033[0m' "$model")"

# ── cwd, ~-relative — gruvbox blue ───────────────────────────────────────────
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -n "$cwd" ] && add "$(printf '\033[38;5;109m%s\033[0m' "${cwd/#$HOME/\~}")"

# ── context-window usage — gruvbox aqua ──────────────────────────────────────
used_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
[ -n "$used_pct" ] && add "$(printf '\033[38;5;108mctx %.0f%%\033[0m' "$used_pct")"

# ── token usage (input+output tokens counted so far this session) ────────────
in_tok=$(printf '%s' "$input" | jq -r '.context_window.total_input_tokens // empty')
out_tok=$(printf '%s' "$input" | jq -r '.context_window.total_output_tokens // empty')
if [ -n "$in_tok" ] && [ -n "$out_tok" ]; then
  tok_fmt=$(awk -v n="$((in_tok + out_tok))" 'BEGIN { if (n >= 1000) printf "%.1fk", n / 1000; else printf "%d", n }')
  add "$(printf '\033[38;5;179mtok %s\033[0m' "$tok_fmt")"   # gruvbox yellow
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
  add "$(printf '\033[38;5;208m5h %.0f%%%s\033[0m' "$five_pct" "$reset_str")"   # gruvbox orange
fi

# (7d weekly quota field removed 2026-07-28 — user request)

printf '%s\n' "$out"
