#!/bin/bash

# --- INSTRUCTIONS & USAGE ---
# 1. Save this script and make it executable: chmod +x rm-fold-smart.sh
# 2. Run normally to move files up one level: ./rm-fold-smart.sh
# 3. Use the -w flag to move all files to the current working directory: ./rm-fold-smart.sh -w
# ----------------------------

# Set default behavior: move files up one level (parent directory)
FLATTEN_TO_WD=false

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -w|--working-dir) 
            FLATTEN_TO_WD=true 
            shift 
            ;;
        *) 
            echo "Unknown parameter: $1"
            echo "Usage: $0 [-w|--working-dir]"
            exit 1 
            ;;
    esac
done

# We must export this variable so it is accessible inside the subshell 
# created by the 'find -exec bash -c' command.
export FLATTEN_TO_WD

# Use find to locate all directories starting from the current path.
# -mindepth 1 ensures we don't try to move the current directory (.) into itself.
find . -type d -mindepth 1 -exec bash -c '
for d; do
  # dotglob: include hidden files; nullglob: prevent errors if folder is empty
  shopt -s dotglob nullglob
  
  for f in "$d"/*; do
    # Skip if the path is a directory (we only want to move files/links)
    [ -d "$f" ] && continue

    filename=$(basename "$f")
    
    # Logic to split filename and extension for "smart" renaming
    if [[ "$filename" == *.* ]]; then
        ext=".${filename##*.}"
        name="${filename%.*}"
    else
        ext=""
        name="$filename"
    fi

    # Determine destination based on the flag
    # If -w was used, dest_dir is the root (.). Otherwise, it is the parent folder.
    if [ "$FLATTEN_TO_WD" = true ]; then
      dest_dir="."
    else
      dest_dir="$(dirname "$d")"
    fi
    
    dest="$dest_dir/$filename"

    # Handle Naming Conflicts
    if [[ -e "$dest" ]]; then
      i=1
      # Loop until a unique "filename-bakN.ext" is found
      while [[ -e "$dest_dir/$name-bak$i$ext" ]]; do
        ((i++))
      done
      mv "$f" "$dest_dir/$name-bak$i$ext"
    else
      # No conflict, move file normally
      mv "$f" "$dest_dir/"
    fi
  done

  # Attempt to remove the directory after its contents are processed.
  # If -w is NOT used, this only works if the directory is truly empty.
  # Replace the rmdir line at the bottom with this:
    rm -rf "$d" 2>/dev/null
done
' bash {} +