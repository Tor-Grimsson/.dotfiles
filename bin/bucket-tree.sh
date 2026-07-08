#!/usr/bin/env bash
# bucket-tree.sh — snapshot CDN bucket trees into the dotfiles. Two outputs, both generated:
#   _files/<bucket>/{tree.json, tree.full.txt}   raw — for nvim / machine consumers
#   NN-<provider>-tree.md                         readable — for Obsidian (tree view + json manifest)
#
# Grouped by provider: a B2 write refreshes 02-b2-tree.md (website + vault-media); an R2 write
# refreshes 04-r2-tree.md (kol-media). Source of truth = ~/.dotfiles; the docs→vault mirror
# carries it to Obsidian and other consumers. Read-only on every bucket:
#   B2 -> rclone lsjson -R      R2 -> the public admin list API (paginated)
#
# Usage:
#   bucket-tree.sh <bucket|provider>   snapshot one bucket or a whole provider (b2 | r2)
#   bucket-tree.sh all                 snapshot everything
#   bucket-tree.sh --for-remote <rc>   resolve an rclone remote -> provider, then snapshot it
#                                      (the bucket wrapper's post-write hook; no-op if unknown)
#   bucket-tree.sh -h | --help
set -euo pipefail

DOT="${DOT:-$HOME/.dotfiles}"
DOCS="$DOT/docs/operations/05-cdn-r2b2"
OUT_ROOT="$DOCS/_files"
TODAY="$(date +%F)"

# --- registry (bash 3.2: no associative arrays) ---
resolve()     { case "$1" in                       # bucket -> "provider|target"
  website)     echo "b2|kolkrabbi:kolkrabbi/website" ;;
  vault-media) echo "b2|kolkrabbi:kol-vault-media" ;;
  kol-media)   echo "r2|https://admin.kolkrabbi.io" ;;
  *) return 1 ;; esac; }
buckets_of()  { case "$1" in b2) echo "website vault-media" ;; r2) echo "kol-media" ;; *) return 1 ;; esac; }
provider_of() { case "$1" in website|vault-media) echo b2 ;; kol-media) echo r2 ;; *) return 1 ;; esac; }
md_of()       { case "$1" in b2) echo "02-b2-tree.md" ;; r2) echo "04-r2-tree.md" ;; *) return 1 ;; esac; }
for_remote()  { case "$1" in                       # rclone remote (wrapper $REMOTE) -> provider
  kolkrabbi:kolkrabbi/website*|kolkrabbi:kol-vault-media*) echo b2 ;;
  *) return 1 ;; esac; }

usage() { sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; }

# --- listers: emit "<size>\t<path>" lines ---
b2_list() { rclone lsjson -R --files-only "$1" | jq -r '.[] | "\(.Size)\t\(.Path)"'; }
r2_list() {
  local api="$1" cursor="" body
  while :; do
    if [ -n "$cursor" ]; then
      body=$(curl -fsS --get --data-urlencode "prefix=" --data-urlencode "cursor=$cursor" "$api/api/list")
    else
      body=$(curl -fsS --get --data-urlencode "prefix=" "$api/api/list")
    fi
    printf '%s' "$body" | jq -r '.objects[] | "\(.size)\t\(.key)"'
    cursor=$(printf '%s' "$body" | jq -r '.cursor // empty')
    [ -z "$cursor" ] && break
  done
}

# --- one bucket -> _files/<bucket>/{tree.json, tree.full.txt} ---
snapshot_bucket() {
  local b="$1" pt provider target outdir tmp
  pt=$(resolve "$b") || { echo "bucket-tree: unknown bucket '$b'" >&2; return 1; }
  provider="${pt%%|*}"; target="${pt#*|}"
  outdir="$OUT_ROOT/$b"; mkdir -p "$outdir"; tmp=$(mktemp)
  case "$provider" in b2) b2_list "$target" > "$tmp" ;; r2) r2_list "$target" > "$tmp" ;; esac
  python3 - "$outdir" "$tmp" <<'PY'
import sys, os, re, json
outdir, flat = sys.argv[1], sys.argv[2]
rows = []
with open(flat) as fh:
    for line in fh:
        line = line.rstrip("\n")
        if line:
            size, path = line.split("\t", 1)
            rows.append((path, int(size)))
rows.sort()
with open(os.path.join(outdir, "tree.full.txt"), "w") as f:   # 1:1 path inventory (drift baseline)
    for path, _ in rows:
        f.write(path + "\n")
SEG = re.compile(r"^segment_\d+\.ts$")                         # collapse hls segments in the nested view
tree, seg = {}, {}
for path, size in rows:
    parts = path.split("/"); node = tree
    for p in parts[:-1]:
        node = node.setdefault(p, {})
    if SEG.match(parts[-1]):
        seg["/".join(parts[:-1])] = seg.get("/".join(parts[:-1]), 0) + 1
    else:
        node[parts[-1]] = size
for parent, count in seg.items():
    node = tree
    for p in (parent.split("/") if parent else []):
        node = node.setdefault(p, {})
    node["segment_*.ts"] = "[%d segments]" % count
with open(os.path.join(outdir, "tree.json"), "w") as f:
    json.dump(tree, f, indent=2, sort_keys=True); f.write("\n")
print("  %s: %d objects" % (os.path.basename(outdir), len(rows)))
PY
  rm -f "$tmp"
}

# --- a provider's buckets -> NN-<provider>-tree.md (readable tree + json manifest) ---
render_provider_md() {
  local provider="$1" doc pairs="" b pt
  doc="$DOCS/$(md_of "$provider")"
  for b in $(buckets_of "$provider"); do pt=$(resolve "$b"); pairs="$pairs $b|${pt#*|}"; done
  python3 - "$DOCS" "$provider" "$doc" "$TODAY" $pairs <<'PY'
import sys, os, json
docs, provider, doc, date = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
pairs = sys.argv[5:]
NAME = {"b2": "Backblaze B2", "r2": "Cloudflare R2"}[provider]
EXPL = {"b2": "01-b2.md", "r2": "03-r2.md"}[provider]
EXPW = {"b2": "01-b2", "r2": "03-r2"}[provider]

def human(n):
    n = float(n)
    for u in ("B", "K", "M", "G"):
        if n < 1024: return ("%d%s" % (n, u)) if u == "B" else ("%.1f%s" % (n, u))
        n /= 1024
    return "%.1fT" % n

def render(node, prefix=""):
    out, keys = [], sorted(node)
    for i, k in enumerate(keys):
        last = i == len(keys) - 1
        br, ext = ("└─ ", "   ") if last else ("├─ ", "│  ")
        v = node[k]
        if isinstance(v, dict):
            out.append(prefix + br + k + "/"); out += render(v, prefix + ext)
        elif isinstance(v, str):
            out.append(prefix + br + k + " " + v)          # "segment_*.ts [N segments]"
        else:
            out.append(prefix + br + "%s  (%s)" % (k, human(v)))
    return out

secs = []
for pair in pairs:
    bucket, target = pair.split("|", 1)
    d = os.path.join(docs, "_files", bucket)
    tree = json.load(open(os.path.join(d, "tree.json")))
    n = sum(1 for _ in open(os.path.join(d, "tree.full.txt")))
    secs.append((bucket, target, n, tree))

with open(doc, "w") as f:
    f.write("---\n")
    f.write("title: %s bucket tree\n" % provider.upper())
    f.write("type: reference\nstatus: active\nupdated: %s\n" % date)
    f.write("description: Generated file tree of the %s bucket(s). Readable view for Obsidian; raw json/txt for nvim in _files/. Regenerated by bucket-tree.sh on every write.\n" % NAME)
    f.write("tags:\n  - project/dotfiles\n  - domain/cloud\n")
    f.write('related:\n  - "[[INDEX|r2b2 index]]"\n  - "[[%s|%s bucket]]"\n' % (EXPW, provider.upper()))
    f.write("---\n\n")
    f.write("# %s bucket tree\n\n" % provider.upper())
    f.write("> **Generated** by `bucket-tree.sh` — do not edit by hand. Readable view for Obsidian; "
            "raw json/txt for nvim in [`_files/`](_files/). See [%s](%s) for what these buckets are.\n"
            % (provider.upper(), EXPL))
    for bucket, target, n, tree in secs:
        body = "\n".join(render(tree)) if tree else "(empty)"
        f.write("\n## %s\n\n`%s` · **%d objects** · hls `segment_*.ts` collapsed\n\n" % (bucket, target, n))
        f.write("```\n%s\n```\n" % body)
print("  → %s" % os.path.basename(doc))
PY
}

snapshot_provider() {
  local provider="$1" b
  echo "▸ $provider"
  for b in $(buckets_of "$provider"); do snapshot_bucket "$b"; done
  render_provider_md "$provider"
}

# --- dispatch ---
arg="${1:-}"
case "$arg" in
  ""|-h|--help) usage; exit 0 ;;
  all) snapshot_provider b2; snapshot_provider r2 ;;
  b2|r2) snapshot_provider "$arg" ;;
  --for-remote) p=$(for_remote "${2:-}") || exit 0; snapshot_provider "$p" ;;
  *) p=$(provider_of "$arg") || { echo "bucket-tree: unknown target '$arg'" >&2; exit 1; }; snapshot_provider "$p" ;;
esac
