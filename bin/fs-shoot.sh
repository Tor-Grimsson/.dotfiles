#!/bin/bash
# fs-shoot.sh — shoot files/folders into a destination folder (created if missing).
# Never overwrites: name clashes auto-resolve (file.ext → file-bak1.ext), same
# convention as fs-rm-folder-smart.sh. Workhorse behind "shoot to …" Quick Actions.

usage() {
  cat <<'EOF'
fs-shoot.sh — move files/folders into a destination folder, clash-safe.

Creates the destination if it doesn't exist. Never overwrites: a name clash
auto-resolves to file-bak1.ext, file-bak2.ext, … (folders: folder-bak1, …).
This is the workhorse behind "shoot to folder" Finder Quick Actions — see
qa-make.sh for stamping those out.

USAGE
  fs-shoot.sh [options] <dest-folder> <file-or-folder> [...]

OPTIONS
  -n, --dry-run   Print the MKDIR/MOVE actions, change nothing.
  -h, --help      Show this.

EXAMPLES
  fs-shoot.sh ~/_trash draft1.md draft2.md   # fake-trash without using real Trash
  fs-shoot.sh ./_keep *.tif                  # stage keepers while culling a folder
  fs-shoot.sh -n ~/archive project-folder    # preview, touch nothing

NOTES
  - Folders move whole (the folder itself, not its contents).
  - Skips anything already in the destination; refuses to move the destination
    into itself. Missing sources are skipped with a warning, the rest proceed.
EOF
}

DRY_RUN=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -n|--dry-run) DRY_RUN=true; shift ;;
        -h|--help) usage; exit 0 ;;
        -*) echo "Unknown parameter: $1" >&2; echo "Try: $0 --help" >&2; exit 1 ;;
        *) break ;;
    esac
done

[[ "$#" -ge 2 ]] || { usage >&2; exit 1; }

dest="$1"; shift
if [ ! -d "$dest" ]; then
    if [ "$DRY_RUN" = true ]; then echo "MKDIR $dest"; else mkdir -p "$dest"; fi
fi
# absolute path for the self/already-there guards (empty on dry-run if dest doesn't exist yet)
dest_abs="$(cd "$dest" 2>/dev/null && pwd)" || dest_abs=""

for src in "$@"; do
    [ -e "$src" ] || { echo "SKIP  $src (no such file)" >&2; continue; }
    src_dir="$(cd "$(dirname "$src")" && pwd)"
    src_abs="$src_dir/$(basename "$src")"

    if [ -n "$dest_abs" ]; then
        [ "$src_abs" = "$dest_abs" ] && { echo "SKIP  $src (is the destination)" >&2; continue; }
        [ "$src_dir" = "$dest_abs" ] && { echo "SKIP  $src (already in destination)" >&2; continue; }
        case "$dest_abs/" in "$src_abs"/*) echo "SKIP  $src (destination is inside it)" >&2; continue ;; esac
    fi

    filename="$(basename "$src")"
    # split extension for files only — folders keep their full name (dots and all)
    if [ ! -d "$src" ] && [[ "$filename" == *.* ]]; then
        ext=".${filename##*.}"; name="${filename%.*}"
    else
        ext=""; name="$filename"
    fi

    if [ -e "$dest/$filename" ]; then
        i=1; while [ -e "$dest/$name-bak$i$ext" ]; do ((i++)); done
        target="$dest/$name-bak$i$ext"
    else
        target="$dest/$filename"
    fi

    if [ "$DRY_RUN" = true ]; then echo "MOVE  $src  ->  $target"; else mv "$src" "$target"; fi
done
