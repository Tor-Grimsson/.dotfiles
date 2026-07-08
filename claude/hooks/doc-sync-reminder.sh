#!/usr/bin/env bash
# PostToolUse(Edit|Write) — if the edited file is declared as a `sources:` entry in
# any doc's frontmatter, remind Claude to update that doc THIS turn. Leverages the
# docs' own source->doc map, so the nudge is precise (fires only for tracked files)
# and harness-enforced (can't drift out of attention like a boot-loaded rule).
#
# Fail-open: any error just exits 0 (never blocks an edit).

input=$(cat 2>/dev/null)

file=$(printf '%s' "$input" | python3 -c 'import sys,json
try:
    print(json.load(sys.stdin).get("tool_input", {}).get("file_path", ""))
except Exception:
    print("")' 2>/dev/null)
[ -n "$file" ] || exit 0

repo="${CLAUDE_PROJECT_DIR:-$PWD}"
docs="$repo/docs/documentation"
[ -d "$docs" ] || exit 0

rel="${file#"$repo"/}"
# escape regex metacharacters, then match a `  - <path>` frontmatter list item
esc=$(printf '%s' "$rel" | sed 's/[.[\*^$/]/\\&/g')
hits=$(grep -rlE "^[[:space:]]*-[[:space:]]*${esc}[[:space:]]*$" "$docs" --include='*.md' 2>/dev/null)
[ -n "$hits" ] || exit 0

list=$(printf '%s' "$hits" | sed "s#^${repo}/#  - #")
msg="doc-sync: you edited \`${rel}\`, declared as a source of:
${list}
Update the doc(s) this turn and bump their \`updated:\` date — sync docs on source edit, or say why not."

python3 -c 'import sys, json
print(json.dumps({"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": sys.argv[1]}}))' "$msg" 2>/dev/null

exit 0
