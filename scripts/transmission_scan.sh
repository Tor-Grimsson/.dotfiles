#!/bin/bash

# transmission_scan.sh — ClamAV scan + junk-cleanup hook, run by Transmission on
# torrent completion. Config-driven: takes NO args, reads TR_* env vars instead.

usage() {
  cat <<'EOF'
transmission_scan.sh — virus-scan & clean a finished torrent (Transmission hook).

Runs ON COMPLETION, set as Transmission's "script-torrent-done-filename". Takes
NO arguments — Transmission passes the torrent via environment variables. It
ClamAV-scans the download, moves any infected files to a _Quarantine folder,
deletes obvious junk (.exe/.lnk/.url/.nfo), and posts a macOS notification.

USAGE
  (not run by hand) — configure as Transmission's torrent-done script.

ENVIRONMENT (set by Transmission)
  TR_TORRENT_DIR    Directory the torrent was downloaded into.
  TR_TORRENT_NAME   The torrent's top-level file/folder name.

ARTIFACTS (written next to the download)
  <dir>/clamav_scan.log   Scan log.
  <dir>/_Quarantine/      Where infected files are moved.

NOTES
  Requires `clamav` (brew install clamav) — keep its DB fresh with `freshclam`.
  macOS only for the completion notification (osascript).
EOF
}

# Allow a human to read the docs; Transmission never passes args, so this is a no-op there.
case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac

# --- 1. SETUP VARIABLES ---
# Transmission tells us where the file is automatically:
DOWNLOAD_PATH="$TR_TORRENT_DIR/$TR_TORRENT_NAME"
# We will put the Virus Log & Quarantine folder inside the download folder
LOG_FILE="$TR_TORRENT_DIR/clamav_scan.log"
QUARANTINE_DIR="$TR_TORRENT_DIR/_Quarantine"

# Create Quarantine folder if it is missing
if [ ! -d "$QUARANTINE_DIR" ]; then
    mkdir -p "$QUARANTINE_DIR"
fi

# --- 2. RUN VIRUS SCAN ---
# Scan recursively; --move relocates infected files into _Quarantine (not delete,
# so a false positive is recoverable). --quiet + --no-summary keep the log lean.
clamscan -r "$DOWNLOAD_PATH" \
  --move="$QUARANTINE_DIR" \
  --log="$LOG_FILE" \
  --no-summary \
  --quiet

# --- 3. CLEAN UP JUNK (Optional) ---
# This deletes .exe, .lnk, .url, and .nfo files inside your download immediately.
# It keeps your "complete" folder nice and clean.
find "$DOWNLOAD_PATH" -type f \( -name "*.exe" -o -name "*.lnk" -o -name "*.url" -o -name "*.nfo" \) -delete

# --- 4. NOTIFY USER ---
osascript -e "display notification \"Scanned & Cleaned: $TR_TORRENT_NAME\" with title \"Transmission\""
