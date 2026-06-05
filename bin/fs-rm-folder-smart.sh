#!/bin/bash
# fs-rm-folder-smart.sh — flatten: move files out of subfolders, then remove the
# emptied folders. Name clashes auto-resolve (file.ext → file-bak1.ext).

usage() {
  cat <<'EOF'
fs-rm-folder-smart.sh — flatten nested folders, in the CURRENT directory.

Moves files OUT of subfolders and deletes the folders once empty. Processes
deepest-first, so nested trees collapse without losing files. Name clashes
auto-resolve: file.ext → file-bak1.ext, file-bak2.ext, …

USAGE
  fs-rm-folder-smart.sh [options]        # run it inside the folder you want flattened

OPTIONS
  -w, --working-dir   Move every file to the current dir (full flatten), instead of
                      up ONE level into each folder's own parent.
  -d, --depth N       Only unpack folders up to N levels deep (default: all levels).
                      N=1 → only the immediate subfolders are emptied; deeper nesting
                      is left intact.
  -n, --dry-run       Print the MOVE/RMDIR actions, change nothing.
  -h, --help          Show this.

EXAMPLES
  fs-rm-folder-smart.sh                  # flatten fully, one level per folder
  fs-rm-folder-smart.sh -w               # pull every file up to the current dir
  fs-rm-folder-smart.sh -d 1             # only empty the immediate subfolders
  fs-rm-folder-smart.sh -n -w            # preview a full flatten, touch nothing
EOF
}

FLATTEN_TO_WD=false
DRY_RUN=false
MAXDEPTH=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -w|--working-dir) FLATTEN_TO_WD=true; shift ;;
        -d|--depth)
            MAXDEPTH="$2"
            [[ "$MAXDEPTH" =~ ^[1-9][0-9]*$ ]] || { echo "--depth needs a positive integer" >&2; exit 1; }
            shift 2 ;;
        -n|--dry-run) DRY_RUN=true; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown parameter: $1" >&2; echo "Try: $0 --help" >&2; exit 1 ;;
    esac
done

export FLATTEN_TO_WD DRY_RUN

# -depth = post-order (children before parents): a folder's deeper subdirs are emptied
# and removed BEFORE the folder itself, so files always bubble up safely. We only ever
# rmdir (empty-only) — never rm -rf — so a folder still holding un-flattened deeper
# content (e.g. beyond --depth) is left intact instead of being nuked.
maxdepth_args=()
[[ -n "$MAXDEPTH" ]] && maxdepth_args=(-maxdepth "$MAXDEPTH")

find . -mindepth 1 "${maxdepth_args[@]}" -depth -type d -exec bash -c '
for d; do
  shopt -s dotglob nullglob
  for f in "$d"/*; do
    [ -d "$f" ] && continue                       # only move files/links, not dirs
    filename=$(basename "$f")
    if [[ "$filename" == *.* ]]; then ext=".${filename##*.}"; name="${filename%.*}"; else ext=""; name="$filename"; fi

    if [ "$FLATTEN_TO_WD" = true ]; then dest_dir="."; else dest_dir="$(dirname "$d")"; fi

    if [[ -e "$dest_dir/$filename" ]]; then
      i=1; while [[ -e "$dest_dir/$name-bak$i$ext" ]]; do ((i++)); done
      dest="$dest_dir/$name-bak$i$ext"
    else
      dest="$dest_dir/$filename"
    fi

    if [ "$DRY_RUN" = true ]; then echo "MOVE  $f  ->  $dest"; else mv "$f" "$dest"; fi
  done

  # remove only if now empty; leave folders that still hold deeper (un-flattened) content
  if [ "$DRY_RUN" = true ]; then echo "RMDIR $d (if empty)"; else rmdir "$d" 2>/dev/null || true; fi
done
' bash {} +
