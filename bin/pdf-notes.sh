#!/usr/bin/env bash
set -euo pipefail

OUT="notes.pdf"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Collect markdown files in deterministic order
find notes -name '*.md' -print0 | sort -z | while IFS= read -r -d '' file; do
  printf '\n\n<!-- %s -->\n\n' "$file" >> "$TMP_DIR/combined.md"
  cat "$file" >> "$TMP_DIR/combined.md"
  printf '\n' >> "$TMP_DIR/combined.md"
  printf 'Added %s\n' "$file"
done

pandoc "$TMP_DIR/combined.md" -o "$OUT"

echo "Wrote $OUT"
