#!/usr/bin/env bash
# bucket-drift.sh — flag drift between a saved file-list baseline and a live rclone remote.
# Read-only on the remote (rclone lsf only); reuses diff, no diff engine.
# HLS segment_*.ts is filtered out (every .m3u8 references hundreds).
set -euo pipefail

usage() {
  cat <<'EOF'
bucket-drift.sh — diff a local baseline against a live bucket lane.

Usage:
  bucket-drift.sh <remote> <baseline>            check: diff live vs baseline (exit 1 on drift)
  bucket-drift.sh <remote> <baseline> --update   refresh the baseline from live

  <remote>    full rclone remote+path, e.g. kolkrabbi:kol-vault-media
              or kolkrabbi:kolkrabbi/website
  <baseline>  flat file-list snapshot to compare against / write

Read-only on the remote. segment_*.ts is excluded.
EOF
}

case "${1:-}" in -h|--help|"") usage; exit 0 ;; esac

remote="$1"
baseline="${2:?need a baseline file path}"
mode="${3:-check}"

live="$(rclone lsf -R "$remote" --filter '- segment_*.ts' | sort)"

if [ "$mode" = "--update" ]; then
  printf '%s\n' "$live" > "$baseline"
  echo "baseline updated: $baseline ($(printf '%s\n' "$live" | grep -c .) entries)"
  exit 0
fi

[ -f "$baseline" ] || { echo "no baseline at $baseline — run with --update first" >&2; exit 2; }

if out="$(diff <(sort "$baseline") <(printf '%s\n' "$live"))"; then
  echo "✓ in sync: $remote"
else
  echo "⚠ DRIFT: $remote"
  printf '%s\n' "$out" | grep -E '^[<>]' | sed 's/^< /  only in baseline: /; s/^> /  only on bucket:   /'
  exit 1
fi
