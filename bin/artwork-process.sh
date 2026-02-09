#!/usr/bin/env bash
set -euo pipefail

# --- slugify helper ---------------------------------------------------------
slugify() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

if [ "$#" -lt 2 ]; then
  echo "Usage: artwork-process.sh <source-file> <output-folder>"
  exit 1
fi

CONFIG_FILE="$(dirname "$0")/artwork-export.yml"
SOURCE_FILE="$1"
RAW_ROOT="$2"

# Folder naming logic (from 2nd argument)
ROOT="$(slugify "$RAW_ROOT")"

# File naming logic (from source filename)
FILENAME=$(basename "$SOURCE_FILE")
FILE_BASE="${FILENAME%.*}"
SLUG="$(slugify "$FILE_BASE")"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config not found: $CONFIG_FILE" >&2
  exit 1
fi

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Source file not found: $SOURCE_FILE" >&2
  exit 1
fi

# ---- YAML reader via PyYAML -----------------------------------------------
read_yaml() {
  python3 - "$CONFIG_FILE" "$1" << 'PY'
import sys, yaml
cfg = yaml.safe_load(open(sys.argv[1], "r"))
path = sys.argv[2].split(".")
val = cfg
for p in path:
    val = val[p]
print(repr(val) if isinstance(val, (list, dict)) else val)
PY
}

MASTER_SUBDIR=$(read_yaml "paths.master_dir")
PRINT_TIF_SUBDIR=$(read_yaml "paths.print_tif_dir")
PRINT_JPG_SUBDIR=$(read_yaml "paths.print_jpg_dir")
WEB_45_SUBDIR=$(read_yaml "paths.web_45_dir")
WEB_RATIO_SUBDIR=$(read_yaml "paths.web_ratio_dir")

MASTER_DIR="$ROOT/$MASTER_SUBDIR"
PRINT_TIF_DIR="$ROOT/$PRINT_TIF_SUBDIR"
PRINT_JPG_DIR="$ROOT/$PRINT_JPG_SUBDIR"
WEB_45_DIR="$ROOT/$WEB_45_SUBDIR"
WEB_RATIO_DIR="$ROOT/$WEB_RATIO_SUBDIR"

mkdir -p "$MASTER_DIR" "$PRINT_TIF_DIR" "$PRINT_JPG_DIR" "$WEB_45_DIR" "$WEB_RATIO_DIR"

# Use provided TIFF as master; suffix set to _flat-master
MASTER_FILE="$MASTER_DIR/${SLUG}_flat-master.tif"
cp "$SOURCE_FILE" "$MASTER_FILE"

echo "Using master: $MASTER_FILE"

# ---------------- PRINT EXPORTS (TIFF) -------------------------------------
PRINT_SPECS=$(read_yaml "print.sizes")
PRINT_DPI=$(read_yaml "print.dpi")

python3 - << PY
import ast, subprocess
specs = ast.literal_eval("""$PRINT_SPECS""")
master = "$MASTER_FILE"
out_dir = "$PRINT_TIF_DIR"
slug = "$SLUG"
dpi = int("$PRINT_DPI")

for s in specs:
    name = s["name"]
    w = s["width_px"]
    h = s["height_px"]
    out = f"{out_dir}/{slug}-print-{name}.tif"
    cmd = [
        "magick", master,
        "-resize", f"{w}x{h}",
        "-density", str(dpi),
        "-compress", "LZW",
        out,
    ]
    print(" ".join(cmd))
    subprocess.run(cmd, check=True)
PY

# ---------------- PRINT EXPORTS (JPG) --------------------------------------
PRINT_JPG_QUALITY=$(read_yaml "print.jpg_quality")

python3 - << PY
import ast, subprocess
specs = ast.literal_eval("""$PRINT_SPECS""")
master = "$MASTER_FILE"
out_dir = "$PRINT_JPG_DIR"
slug = "$SLUG"
dpi = int("$PRINT_DPI")
quality = int("$PRINT_JPG_QUALITY")

for s in specs:
    name = s["name"]
    w = s["width_px"]
    h = s["height_px"]
    out = f"{out_dir}/{slug}-print-{name}.jpg"
    cmd = [
        "magick", master,
        "-flatten",
        "-resize", f"{w}x{h}",
        "-density", str(dpi),
        "-strip",
        "-colorspace", "sRGB",
        "-depth", "8",
        "-define", "jpeg:force-baseline=true",
        "-quality", str(quality),
        "jpeg:" + out,
    ]
    print(" ".join(cmd))
    subprocess.run(cmd, check=True)
PY

# ---------------- WEB EXPORTS (4:5 Ratio Folder) ---------------------------
WEB_45_SPECS=$(read_yaml "web_4_5.sizes")
WEB_45_QUALITY=$(read_yaml "web_4_5.quality")

python3 - << PY
import ast, subprocess

specs = ast.literal_eval("""$WEB_45_SPECS""")
master = "$MASTER_FILE"
out_dir = "$WEB_45_DIR"
slug = "$SLUG"
quality = int("$WEB_45_QUALITY")

for s in specs:
    long_edge = int(s["long_edge"])
    width = long_edge
    height = int(long_edge * 1.25)

    out = f"{out_dir}/{slug}-{long_edge}-4x5.jpg"

    cmd = [
        "magick", master,
        "-flatten",
        "-resize", f"{width}x{height}^",
        "-gravity", "center",
        "-extent", f"{width}x{height}",
        "-strip",
        "-colorspace", "sRGB",
        "-depth", "8",
        "-define", "jpeg:force-baseline=true",
        "-quality", str(quality),
        "jpeg:" + out,
    ]

    print(" ".join(cmd))
    subprocess.run(cmd, check=True)
PY

# ---------------- WEB EXPORTS (Original Ratio Folder) ----------------------
WEB_RATIO_SPECS=$(read_yaml "web_ratio.sizes")
WEB_RATIO_QUALITY=$(read_yaml "web_ratio.quality")

python3 - << PY
import ast, subprocess

specs = ast.literal_eval("""$WEB_RATIO_SPECS""")
master = "$MASTER_FILE"
out_dir = "$WEB_RATIO_DIR"
slug = "$SLUG"
quality = int("$WEB_RATIO_QUALITY")

for s in specs:
    long_edge = int(s["long_edge"])
    
    out = f"{out_dir}/{slug}-{long_edge}-ratio.jpg"

    cmd = [
        "magick", master,
        "-flatten",
        "-resize", f"x{long_edge}",
        "-strip",
        "-colorspace", "sRGB",
        "-depth", "8",
        "-define", "jpeg:force-baseline=true",
        "-quality", str(quality),
        "jpeg:" + out,
    ]

    print(" ".join(cmd))
    subprocess.run(cmd, check=True)
PY