#!/bin/bash
# batch-create-folder-move-file.sh — for every dot-named entry in the current
# directory, make a folder named after its basename and move the entry inside.

usage() {
  cat <<'EOF'
batch-create-folder-move-file.sh — folderize every dot-named entry in the CURRENT directory.

For each entry matching *.* (a name containing a dot), create a folder named
after the entry's basename (extension stripped) and move the entry into it.
NO type guard — this acts on whatever *.* matches, including dot-named DIRECTORIES.

USAGE
  batch-create-folder-move-file.sh       # cd into the target folder first; operates on cwd

BEHAVIOR
  - Iterates *.* in the current directory only (NOT recursive). Dotfile-only
    names like ".gitignore" are not matched by *.* under default globbing.
  - song.mp3 -> creates ./song/ and moves song.mp3 to ./song/song.mp3.
  - my.archive.tar -> folder "my.archive" (only the LAST dot is the split point).
  - A dot-named directory such as 2024.backup/ IS matched and gets nested into
    a new 2024/ folder. Use the -folder variant to skip directories.

EXAMPLES
  batch-create-folder-move-file.sh       # one folder per file, named from the file

NOTES
  - Difference vs batch-create-folder-move-folder.sh: that script adds a
    `[ -f "$f" ]` guard, so it processes ONLY regular files and SKIPS dot-named
    directories. This script has no guard and folderizes directories too.
  - Destructive (moves files). cd into the right directory before running.
EOF
}

# Help only — fires solely on -h/--help so the bare cwd-glob run is undisturbed.
case "${1:-}" in -h|--help) usage; exit 0 ;; esac

# Glob *.* matches every name in the cwd containing a dot (files, links, AND
# dot-named directories). It is not recursive and skips leading-dot dotfiles.
for f in *.*; do
  # ${f%.*} = $f with the shortest trailing .extension removed (the basename):
  #   "song.mp3" -> "song", "my.archive.tar" -> "my.archive".
  # mkdir -p makes that folder (no error if it already exists), then mv drops
  # the entry inside. && chains so a failed mkdir aborts the move for that item.
  mkdir -p "${f%.*}" && mv "$f" "${f%.*}/"
done
