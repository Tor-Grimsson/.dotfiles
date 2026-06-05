#!/bin/bash
# batch-create-folder-move-folder.sh — for every dot-named REGULAR FILE in the
# current directory, make a folder named after its basename and move it inside.
# The [ -f ] guard makes this the safe variant: dot-named directories are skipped.

usage() {
  cat <<'EOF'
batch-create-folder-move-folder.sh — folderize every dot-named FILE in the CURRENT directory.

For each *.* entry that is a regular file, create a folder named after its
basename (extension stripped) and move the file into it. A `[ -f "$f" ]` guard
makes this skip anything that is not a regular file — notably dot-named DIRECTORIES.

USAGE
  batch-create-folder-move-folder.sh     # cd into the target folder first; operates on cwd

BEHAVIOR
  - Iterates *.* in the current directory only (NOT recursive). Dotfile-only
    names like ".gitignore" are not matched by *.* under default globbing.
  - song.mp3 -> creates ./song/ and moves song.mp3 to ./song/song.mp3.
  - my.archive.tar -> folder "my.archive" (only the LAST dot is the split point).
  - A dot-named directory such as 2024.backup/ is matched by *.* but the
    `[ -f ]` guard rejects it, so it is left untouched. A symlink to a file
    passes `-f` (which follows symlinks) and IS processed.

EXAMPLES
  batch-create-folder-move-folder.sh     # one folder per file; dot-named dirs left alone

NOTES
  - Difference vs batch-create-folder-move-file.sh: this script's `[ -f "$f" ]`
    guard limits it to regular files, so dot-named directories are SKIPPED.
    The -file variant has no guard and folderizes those directories too.
  - The name is a slight misnomer: it does not operate ON folders — the guard
    EXCLUDES folders so only files get folderized.
  - Destructive (moves files). cd into the right directory before running.
EOF
}

# Help only — fires solely on -h/--help so the bare cwd-glob run is undisturbed.
case "${1:-}" in -h|--help) usage; exit 0 ;; esac

# Glob *.* matches every name in the cwd containing a dot (files, links, AND
# dot-named directories). It is not recursive and skips leading-dot dotfiles.
for f in *.*; do
  # [ -f "$f" ]: process ONLY regular files (follows symlinks). This is the one
  # difference from the -file variant: it filters out dot-named DIRECTORIES that
  # *.* also matched, so those are left in place.
  #
  # ${f%.*} = $f with the shortest trailing .extension removed (the basename):
  #   "song.mp3" -> "song", "my.archive.tar" -> "my.archive".
  # mkdir -p makes that folder (no error if it already exists), then mv drops
  # the file inside. && chains so the guard/mkdir gate the move for that item.
  [ -f "$f" ] && mkdir -p "${f%.*}" && mv "$f" "${f%.*}/"
done
