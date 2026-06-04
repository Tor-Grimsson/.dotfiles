#!/usr/bin/env bash
set -euo pipefail

# --- slugify helper ---------------------------------------------------------
slugify() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

CONFIG_FILE="${1:-artwork_export.yml}"
SOURCE_FILE="${2:?Usage: $0 [config.yml] source_master.tif}"
RAW_ROOT="${3:-$(basename "$SOURCE_FILE" | sed 's/\.[^.]*$//')}"
ROOT="$(slugify "$RAW_ROOT")"
SLUG="$ROOT"

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
PRINT_SUBDIR=$(read_yaml "paths.print_dir")
WEB_SUBDIR=$(read_yaml "paths.web_dir")

MASTER_DIR="$ROOT/$MASTER_SUBDIR"
PRINT_DIR="$ROOT/$PRINT_SUBDIR"
WEB_DIR="$ROOT/$WEB_SUBDIR"

mkdir -p "$MASTER_DIR" "$PRINT_DIR" "$WEB_DIR"

# Use provided TIFF as master; just copy, no re-export
MASTER_FILE="$MASTER_DIR/${SLUG}_print-master.tif"
cp "$SOURCE_FILE" "$MASTER_FILE"

echo "Using master: $MASTER_FILE"

# ---------------- PRINT EXPORTS (A-series) ---------------------------------
PRINT_SPECS=$(read_yaml "print.sizes")
PRINT_DPI=$(read_yaml "print.dpi")

python3 - << PY
import ast, subprocess
specs = ast.literal_eval("""$PRINT_SPECS""")
master = "$MASTER_FILE"
out_dir = "$PRINT_DIR"
slug = "$SLUG"
dpi = int("$PRINT_DPI")
for s in specs:
    name = s["name"]
    w = s["width_px"]
    h = s["height_px"]
    out = f"{out_dir}/{slug}_print-{name}.tif"
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

# ---------------- WEB EXPORTS (simple, clean sRGB JPGs) --------------------
WEB_SPECS=$(read_yaml "web.sizes")
WEB_QUALITY=$(read_yaml "web.quality")

python3 - << PY
import ast, subprocess, math

specs = ast.literal_eval("""$WEB_SPECS""")
master = "$MASTER_FILE"
out_dir = "$WEB_DIR"
slug = "$SLUG"
quality = int("$WEB_QUALITY")

for s in specs:
    long_edge = int(s["long_edge"])
    width = long_edge
    height = int(long_edge * 1.25)   # 4:5 box

    out = f"{out_dir}/{slug}-{long_edge}.jpg"

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