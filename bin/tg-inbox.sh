#!/usr/bin/env bash
# tg-inbox.sh — poll a personal Telegram bot and route each message to its home.
#
#   #t <text>   → Todoist task
#   #e <text>   → calendar event via `gcalcli quick`
#   #n <text>   → note appended to the Obsidian vault inbox
#   (no tag)    → note (catch-all)
#
# Secrets come from Bitwarden (run `bwu` once to unlock), never the repo.
# Designed for a launchd timer (`--once`) or a manual run. bash-3.2 safe.
#
# Usage:
#   bwu && tg-inbox.sh            # one poll, route new messages
#   tg-inbox.sh --once           # same (explicit)
#   tg-inbox.sh --selftest       # offline: assert the routing parser
#   tg-inbox.sh --help
set -euo pipefail

# ── Config ──────────────────────────────────────────────────────────────────
TG_CHAT_ID="6300800383"                                   # only obey this chat
TG_ITEM="Telegram"                                        # bw item (Secure Note); bot token in the notes field
TODOIST_ITEM="Todoist"                                    # bw item (Secure Note); API token in the notes field
VAULT_INBOX="$HOME/dev/projects/kol-vault/kol-inbox/inbox.md"   # note destination ($HOME → both machines, §1)
STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/tg-inbox/offset"
# Media → the kol-vault-media bucket's "lobby" lane (never local-in-vault, keeps the vault git-light).
# A dedicated lobby path so maintenance pipelines (purge-after-review, relocate) operate on it as a unit.
MEDIA_BUCKET="${MEDIA_BUCKET:-kolkrabbi:kol-vault-media}"
MEDIA_CDN_BASE="${MEDIA_CDN_BASE:-https://f005.backblazeb2.com/file/kol-vault-media}"
MEDIA_LOBBY="${MEDIA_LOBBY:-lobby}"

usage() { sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; }

# ── Routing parser (pure, testable) ─────────────────────────────────────────
# classify "<text>"  →  prints "<kind>\t<payload>"  (kind: task|event|note)
classify() {
  local t="$1" tag rest
  tag="${t%% *}"; rest="${t#* }"
  [ "$rest" = "$t" ] && rest=""          # no space → no payload after the tag
  case "$tag" in
    '#kol-td'|'#t')  printf 'task\t%s'  "$rest" ;;   # → Todoist
    '#kol-cal'|'#e') printf 'event\t%s' "$rest" ;;   # → calendar (gcalcli)
    '#kol-ob'|'#n')  printf 'note\t%s'  "$rest" ;;   # → Obsidian vault inbox
    *)               printf 'note\t%s'  "$t"    ;;   # untagged → note, whole message
  esac
}

selftest() {
  local out fail=0
  check() { out="$(classify "$1")"; [ "$out" = "$2" ] && echo "ok: $1" || { echo "FAIL: '$1' → '$out' (want '$2')"; fail=1; }; }
  check '#t buy milk'          $'task\tbuy milk'
  check '#kol-td buy milk'     $'task\tbuy milk'
  check '#e dentist thu 2pm'   $'event\tdentist thu 2pm'
  check '#kol-cal dentist 2pm' $'event\tdentist 2pm'
  check '#n cool idea'         $'note\tcool idea'
  check '#kol-ob cool idea'    $'note\tcool idea'
  check 'random thought'       $'note\trandom thought'
  check '#t'                   $'task\t'
  [ "$fail" -eq 0 ] && echo "selftest passed" || { echo "selftest FAILED"; return 1; }
}

# ── Destinations ────────────────────────────────────────────────────────────
route_task()  { curl -fsS -X POST "https://api.todoist.com/api/v1/tasks" \
                  -H "Authorization: Bearer $TODOIST_TOKEN" -H "Content-Type: application/json" \
                  -d "$(jq -n --arg c "$1" '{content:$c}')" >/dev/null; }
route_event() { command -v gcalcli >/dev/null && gcalcli quick "$1" >/dev/null 2>&1; }
route_note()  { mkdir -p "$(dirname "$VAULT_INBOX")"
                printf -- '- %s %s\n' "$(date '+%Y-%m-%d %H:%M')" "$1" >> "$VAULT_INBOX"; }

# Media: getFile → download to a temp → upload to the bucket lobby → embed the CDN URL.
# Nothing binary touches the vault/git (matches the git-light media law). Returns 1 on fail.
route_media() {
  local file_id="$1" mkind="$2" caption="$3" fp ext fname dir url ts cap
  fp="$(tg "getFile?file_id=$file_id" | jq -r '.result.file_path // empty')"
  [ -n "$fp" ] || return 1
  ext="${fp##*.}"; [ "$ext" = "$fp" ] && ext="bin"
  fname="$(date '+%Y%m%d-%H%M%S')-${mkind}.${ext}"
  dir="$(mktemp -d)"   # name the file correctly, then upload INTO the lobby dir (basename preserved)
  curl -fsS "https://api.telegram.org/file/bot$TG_BOT_TOKEN/$fp" -o "$dir/$fname" || { rm -rf "$dir"; return 1; }
  BUCKET_REMOTE="$MEDIA_BUCKET" bucket up "$dir/$fname" "$MEDIA_LOBBY/" >/dev/null 2>&1 || { rm -rf "$dir"; return 1; }
  rm -rf "$dir"
  url="$MEDIA_CDN_BASE/$MEDIA_LOBBY/$fname"
  ts="$(date '+%Y-%m-%d %H:%M')"; cap=""; [ -n "$caption" ] && cap=" $caption"
  printf -- '- %s ![](%s)%s\n' "$ts" "$url" "$cap" >> "$VAULT_INBOX"
}

tg() { curl -fsS "https://api.telegram.org/bot$TG_BOT_TOKEN/$1" "${@:2}"; }
react() { tg setMessageReaction -d "chat_id=$1" -d "message_id=$2" \
            -d 'reaction=[{"type":"emoji","emoji":"👍"}]' >/dev/null 2>&1 || true; }

# ── Poll once ───────────────────────────────────────────────────────────────
poll() {
  [ -f "$HOME/.secrets" ] && . "$HOME/.secrets"   # local export route (preferred); BW is the fallback below
  TG_BOT_TOKEN="${TG_BOT_TOKEN:-$(bw get notes "$TG_ITEM"     2>/dev/null || true)}"
  TODOIST_TOKEN="${TODOIST_TOKEN:-$(bw get notes "$TODOIST_ITEM" 2>/dev/null || true)}"
  [ -n "$TG_BOT_TOKEN" ]  || { echo "no Telegram token — run 'bwu' first (or export TG_BOT_TOKEN)" >&2; exit 1; }
  [ -n "$TODOIST_TOKEN" ] || { echo "no Todoist token — run 'bwu' first (or export TODOIST_TOKEN)" >&2; exit 1; }

  mkdir -p "$(dirname "$STATE_FILE")"
  local offset; offset="$(cat "$STATE_FILE" 2>/dev/null || true)"; offset="${offset:-0}"

  local resp; resp="$(tg "getUpdates?offset=$offset&timeout=0")"
  local n; n="$(printf '%s' "$resp" | jq '.result | length')"
  [ "$n" -eq 0 ] && { echo "no new messages"; return 0; }

  printf '%s' "$resp" | jq -c --argjson me "$TG_CHAT_ID" '
    .result[] | select(.message.chat.id == $me) | {
      id: .message.message_id,
      text: (.message.text // ""),
      caption: (.message.caption // ""),
      mkind: (if .message.photo then "photo" elif .message.video then "video"
              elif .message.document then "document" elif .message.voice then "voice" else "" end),
      file_id: ((.message.photo // [] | last | .file_id) // .message.video.file_id
                // .message.document.file_id // .message.voice.file_id // "")
    }' \
  | while IFS= read -r row; do
      local mid text caption mkind file_id kind payload
      mid="$(printf '%s' "$row"     | jq -r '.id')"
      text="$(printf '%s' "$row"    | jq -r '.text')"
      caption="$(printf '%s' "$row" | jq -r '.caption')"
      mkind="$(printf '%s' "$row"   | jq -r '.mkind')"
      file_id="$(printf '%s' "$row" | jq -r '.file_id')"
      # Media-bearing message → download + embed (caption rides along as the note text).
      if [ -n "$mkind" ] && [ -n "$file_id" ]; then
        if route_media "$file_id" "$mkind" "$caption"; then
          react "$TG_CHAT_ID" "$mid"; echo "routed [media:$mkind]"
        else
          echo "media download failed: $mkind ($mid)" >&2
        fi
        continue
      fi
      [ -z "$text" ] && continue
      IFS=$'\t' read -r kind payload <<EOF
$(classify "$text")
EOF
      case "$kind" in
        task)  route_task  "$payload" ;;
        event) route_event "$payload" ;;
        note)  route_note  "$payload" ;;
      esac
      react "$TG_CHAT_ID" "$mid"
      echo "routed [$kind]: $payload"
    done

  # advance past every fetched update (even ignored ones) so we never re-poll them
  local maxid; maxid="$(printf '%s' "$resp" | jq '[.result[].update_id] | max // empty')"
  [ -n "$maxid" ] && echo $((maxid + 1)) > "$STATE_FILE"
}

case "${1:---once}" in
  -h|--help)  usage ;;
  --selftest) selftest ;;
  --once|"")  poll ;;
  *) echo "unknown arg: $1" >&2; usage; exit 2 ;;
esac
