#!/usr/bin/env bash
# pdf-notes.sh — concatenate notes/**/*.md (sorted) into a single notes.pdf.

usage() {
  cat <<'EOF'
pdf-notes.sh — bundle notes/**/*.md into one notes.pdf.

Recursively collects every Markdown file under ./notes/, concatenates them in
sorted (deterministic) path order with a comment banner before each, and renders
the lot to notes.pdf via pandoc.

USAGE
  pdf-notes.sh                  # run it where a ./notes/ directory lives

ARGUMENTS
  (none)

BEHAVIOR
  - Globs notes/ recursively for *.md, sorted by path (NUL-safe).
  - Inserts `<!-- path -->` before each file so sources stay traceable in the
    combined Markdown.
  - Always writes notes.pdf in the cwd (overwrites if present).

EXAMPLES
  pdf-notes.sh                  # → notes.pdf

NOTES
  - Dep: pandoc (plus a PDF engine, e.g. a LaTeX install, for PDF output).
  - Input dir and output name are hard-coded (notes/ → notes.pdf).
EOF
}

case "${1:-}" in -h|--help) usage; exit 0 ;; esac

OUT="notes.pdf"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Collect markdown files in deterministic order (NUL-delimited so paths with
# spaces/newlines survive). The banner comment keeps each source traceable.
find notes -name '*.md' -print0 | sort -z | while IFS= read -r -d '' file; do
  printf '\n\n<!-- %s -->\n\n' "$file" >> "$TMP_DIR/combined.md"
  cat "$file" >> "$TMP_DIR/combined.md"
  printf '\n' >> "$TMP_DIR/combined.md"
  printf 'Added %s\n' "$file"
done

pandoc "$TMP_DIR/combined.md" -o "$OUT"

echo "Wrote $OUT"
