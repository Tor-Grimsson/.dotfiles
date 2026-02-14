#!/bin/bash

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
# Scan recursively, move viruses to Quarantine, and log the output.
/opt/homebrew/bin/clamscan -r "$DOWNLOAD_PATH" \
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
