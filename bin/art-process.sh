#!/usr/bin/env bash
# art-process.sh — config-driven artwork export pipeline. Takes one flattened
# master TIFF and fans it out into print + web deliverables (print TIFF, print
# JPG, web 4:5 crops, web original-ratio) sized and tuned by art-export.yml.
set -euo pipefail

usage() {
  cat <<'EOF'
art-process.sh — explode one master TIFF into print + web deliverables.

Copies the source as the canonical master, then renders four export families
(print TIFF, print JPG, web 4:5, web original-ratio) at the sizes/quality/dpi
defined in art-export.yml, into a slugified folder tree named after <output-folder>.

USAGE
  art-process.sh <source-file> <output-folder>

ARGUMENTS
  <source-file>     Path to the flattened master TIFF to process (must exist).
  <output-folder>   Name of the destination root. Slugified (lowercased,
                    non-alphanumerics → dashes), so "My Print 01" → "my-print-01".

OPTIONS
  -h, --help        Show this and exit.

EXAMPLES
  art-process.sh ~/art/raven-flat.tif "Raven 01"
                    # → ./raven-01/{master,print-tif,print-jpg,web-4-5,web-ratio}/...

NOTES
  Deps: ImageMagick 7 (the `magick` binary), python3 with PyYAML, ffmpeg NOT used.
  Config: art-export.yml sits next to this script and drives EVERYTHING tunable —
    output subdir names (paths.*), print sizes A4–A1 + dpi + jpg_quality (print.*),
    web 4:5 long edges + quality (web_4_5.*), web ratio long edges + quality (web_ratio.*).
  Output layout (under the slugified <output-folder> root):
    master/      <slug>_flat-master.tif         (verbatim copy of the source)
    print-tif/   <slug>-print-<A4|A3|A2|A1>.tif  (LZW, 300dpi)
    print-jpg/   <slug>-print-<A4|A3|A2|A1>.jpg  (flattened, sRGB, baseline)
    web-4-5/     <slug>-<edge>-4x5.jpg           (center-cropped to 4:5)
    web-ratio/   <slug>-<edge>-ratio.jpg         (height-fit, original aspect)
EOF
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac

# --- slugify helper ---------------------------------------------------------
# Lowercase, collapse any run of non-alphanumerics to a single dash, trim
# leading/trailing dashes. Used for both the output root and the file basenames
# so every emitted path is filesystem- and URL-safe.
slugify() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

# Require both positional args; without them there is nothing to process.
if [ "$#" -lt 2 ]; then
  echo "Usage: art-process.sh <source-file> <output-folder>"
  exit 1
fi

# Config lives alongside the script, so it travels with it regardless of cwd.
CONFIG_FILE="$(dirname "$0")/art-export.yml"
SOURCE_FILE="$1"
RAW_ROOT="$2"

# Output root folder name comes from the 2nd arg, slugified.
ROOT="$(slugify "$RAW_ROOT")"

# Per-file slug comes from the source filename minus its extension; this becomes
# the prefix on every exported asset.
FILENAME=$(basename "$SOURCE_FILE")
FILE_BASE="${FILENAME%.*}"
SLUG="$(slugify "$FILE_BASE")"

# Fail fast if the config or the source master is missing — better than producing
# a half-built tree.
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config not found: $CONFIG_FILE" >&2
  exit 1
fi

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Source file not found: $SOURCE_FILE" >&2
  exit 1
fi

# ---- YAML reader via PyYAML -----------------------------------------------
# Pull a single value out of art-export.yml by dotted key path (e.g.
# "print.sizes"). Scalars print bare; lists/dicts print as a Python repr() so the
# downstream python3 heredocs can ast.literal_eval() them straight back into objects.
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

# Resolve the five output subdir names from config (paths.*) so renaming a folder
# is a one-line edit in the YAML, not a code change.
MASTER_SUBDIR=$(read_yaml "paths.master_dir")
PRINT_TIF_SUBDIR=$(read_yaml "paths.print_tif_dir")
PRINT_JPG_SUBDIR=$(read_yaml "paths.print_jpg_dir")
WEB_45_SUBDIR=$(read_yaml "paths.web_45_dir")
WEB_RATIO_SUBDIR=$(read_yaml "paths.web_ratio_dir")

# Each export family gets its own subdir under the slugified root.
MASTER_DIR="$ROOT/$MASTER_SUBDIR"
PRINT_TIF_DIR="$ROOT/$PRINT_TIF_SUBDIR"
PRINT_JPG_DIR="$ROOT/$PRINT_JPG_SUBDIR"
WEB_45_DIR="$ROOT/$WEB_45_SUBDIR"
WEB_RATIO_DIR="$ROOT/$WEB_RATIO_SUBDIR"

mkdir -p "$MASTER_DIR" "$PRINT_TIF_DIR" "$PRINT_JPG_DIR" "$WEB_45_DIR" "$WEB_RATIO_DIR"

# The source TIFF IS the master — copy it verbatim (no transform) so the
# canonical full-resolution file is preserved inside the output tree. The
# _flat-master suffix flags that it is expected to be a pre-flattened TIFF.
MASTER_FILE="$MASTER_DIR/${SLUG}_flat-master.tif"
cp "$SOURCE_FILE" "$MASTER_FILE"

echo "Using master: $MASTER_FILE"

# ---------------- PRINT EXPORTS (TIFF) -------------------------------------
# Archival/print-shop TIFFs at each paper size from print.sizes (A4–A1), 300dpi,
# LZW-compressed (lossless). One TIFF per size.
PRINT_SPECS=$(read_yaml "print.sizes")
PRINT_DPI=$(read_yaml "print.dpi")

python3 - << PY
import ast, subprocess
# specs is a list of {name, width_px, height_px} dicts read back from YAML.
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
        # No "^"/"!" → fit INSIDE the WxH box preserving aspect (longest edge wins,
        # never upscales past the box). The px dims in the YAML are the 300dpi
        # pixel sizes of each ISO paper format.
        "-resize", f"{w}x{h}",
        "-density", str(dpi),     # stamp print resolution metadata (300dpi)
        "-compress", "LZW",       # lossless compression — safe for archival/print
        out,
    ]
    print(" ".join(cmd))
    subprocess.run(cmd, check=True)
PY

# ---------------- PRINT EXPORTS (JPG) --------------------------------------
# Same paper sizes as the TIFFs, but as proofing/share-friendly JPEGs: flattened,
# stripped of metadata, sRGB, 8-bit, baseline-encoded at print.jpg_quality.
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
        "-flatten",               # composite layers/alpha onto a flat canvas (JPEG has no alpha)
        "-resize", f"{w}x{h}",    # fit inside the paper-size box, aspect preserved
        "-density", str(dpi),     # carry 300dpi into the JPEG metadata
        "-strip",                 # drop EXIF/color-profile/comment chunks → smaller file
        "-colorspace", "sRGB",    # normalize to web/standard sRGB
        "-depth", "8",            # 8 bits/channel (JPEG standard)
        "-define", "jpeg:force-baseline=true",  # baseline (not progressive) for max compatibility
        "-quality", str(quality),
        "jpeg:" + out,            # explicit jpeg: prefix forces the encoder regardless of extension
    ]
    print(" ".join(cmd))
    subprocess.run(cmd, check=True)
PY

# ---------------- WEB EXPORTS (4:5 Ratio Folder) ---------------------------
# Social/portrait web crops forced to a 4:5 aspect (e.g. Instagram portrait).
# Each entry's long_edge is the WIDTH; height is derived as width*1.25. The image
# is scaled to fill then center-cropped, so the 4:5 frame is always exactly filled.
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
    height = int(long_edge * 1.25)   # 4:5 ratio → height is 1.25× the width

    out = f"{out_dir}/{slug}-{long_edge}-4x5.jpg"

    cmd = [
        "magick", master,
        "-flatten",
        # "^" = resize to COVER the WxH box (fill, may overflow one edge), as
        # opposed to fit-inside. Pairs with -extent below to crop the overflow.
        "-resize", f"{width}x{height}^",
        "-gravity", "center",                   # crop anchor = center of the image
        "-extent", f"{width}x{height}",         # hard-crop to exactly WxH → true 4:5
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
# Web JPEGs that KEEP the master's native aspect ratio — no cropping. Each
# long_edge here sets the target HEIGHT; width follows from the source aspect.
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
        # "x{H}" → set HEIGHT to long_edge, width auto-computed from aspect.
        # Original ratio is preserved (no extent/crop).
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