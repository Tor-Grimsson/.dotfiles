#!/bin/zsh

# pdf-from-md.sh — Markdown → A4 print-ready PDF via Pandoc.
# Two engines: typst (default, fast/generic) or weasyprint (CSS control via print.css).
# Converts the files you pass, or every *.md in the current directory.

usage() {
  cat <<'EOF'
pdf-from-md.sh — Markdown → A4 PDF via Pandoc (typst or weasyprint engine).

USAGE
  pdf-from-md.sh [-e typst|weasyprint] [-c CSS] [-s SIZE] [-w] [FILE ...]

FLAGS
  -e ENGINE   typst (default) — fast, generic, no CSS. Great default typography.
              weasyprint — HTML+CSS→PDF, styled by a print.css (CSS Paged Media).
  -c CSS      Stylesheet for the weasyprint engine. Default: the print.css next to
              this script. Ignored by the typst engine.
  -s SIZE     Page size for the typst engine (a4 default; e.g. letter). weasyprint
              takes its size from the CSS @page rule instead.
  -w          Watch: re-convert whenever an input changes (needs entr). Great while
              editing a single file.
  -h, --help  This help.

ARGUMENTS
  FILE ...    One or more .md files. With none, converts every *.md in the current
              directory. Each in.md becomes in.pdf beside it.

EXAMPLES
  pdf-from-md.sh notes.md                        # → notes.pdf, A4, typst
  pdf-from-md.sh                                 # every *.md in the cwd
  pdf-from-md.sh -e weasyprint report.md         # CSS lane, default print.css
  pdf-from-md.sh -e weasyprint -c brand.css *.md # CSS lane, your stylesheet
  pdf-from-md.sh -s letter notes.md              # US Letter via typst
  pdf-from-md.sh -w notes.md                     # re-export on every save

NOTES
  Needs `pandoc` + the chosen engine (`typst` or `weasyprint`) on PATH.
  Wikilinks ([[x]]) render literally — convert docs to standard [text](path) first.
EOF
}

ENGINE="typst"
CSS="${0:A:h}/print.css"   # sibling print.css by default (weasyprint lane)
SIZE="a4"
WATCH=0

while [[ "${1:-}" == -* ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    -e) ENGINE="$2"; shift 2 ;;
    -c) CSS="${2/#\~/$HOME}"; shift 2 ;;
    -s) SIZE="$2"; shift 2 ;;
    -w) WATCH=1; shift ;;
    --) shift; break ;;
    *)  echo "❌ Unknown flag: $1" >&2; usage; exit 1 ;;
  esac
done

command -v pandoc  >/dev/null || { echo "❌ pandoc not found (brew install pandoc)" >&2; exit 1; }
command -v "$ENGINE" >/dev/null || { echo "❌ engine '$ENGINE' not found (brew install $ENGINE)" >&2; exit 1; }

# Inputs: the files you passed, or every *.md in the cwd (N = null_glob, empty if none).
if (( $# )); then FILES=("$@"); else FILES=(*.md(N)); fi
(( ${#FILES} )) || { echo "❌ No .md files (pass files, or run in a folder with some)." >&2; exit 1; }

# Watch mode: re-run this script (without -w) whenever an input changes.
if (( WATCH )); then
  command -v entr >/dev/null || { echo "❌ entr not found (brew install entr)" >&2; exit 1; }
  print -l -- "${FILES[@]}" | entr -s "${0:A} -e ${ENGINE} -c ${(q)CSS} -s ${SIZE} ${(q)FILES}"
  exit $?
fi

convert_one() {
  local in="$1" out="${1%.md}.pdf"
  case "$ENGINE" in
    typst)      pandoc "$in" -o "$out" --pdf-engine=typst -V papersize="$SIZE" ;;
    weasyprint) pandoc "$in" -o "$out" --pdf-engine=weasyprint --css="$CSS" ;;
    *)          pandoc "$in" -o "$out" --pdf-engine="$ENGINE" ;;
  esac && echo "✅ $out" || { echo "❌ failed: $in" >&2; return 1; }
}

rc=0
for f in "${FILES[@]}"; do
  [[ -f "$f" ]] || { echo "⚠️  skip (not a file): $f" >&2; continue; }
  convert_one "$f" || rc=1
done
exit $rc
