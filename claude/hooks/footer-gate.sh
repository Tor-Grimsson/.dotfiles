#!/usr/bin/env bash
# Stop hook — HARD GATE on the end-of-message footer discipline.
#
# The UserPromptSubmit reinforcement (agent-reinforce.sh) is soft: it fires at the
# START of a turn, so by the end of a long tool-heavy reply it has drifted out of
# attention. THIS hook fires when the reply is FINISHED and BLOCKS it (forcing a
# re-emit) when the trailing lines break the footer rule. A reminder can be ignored;
# a block cannot.
#
# Blocks when the finished reply:
#   1. has any non-empty content AFTER the footer line, or
#   2. ends (last ~8 lines) with a trailing offer — "want me to…", "let me know…", or
#   3. carries a bare status/recap line ("X untouched", "created/updated at",
#      "session log written") in its last ~8 lines instead of folding it into the footer.
#
# Loop-safe: respects `stop_hook_active` (blocks at most once per stop-chain).
# Fail-open: any parse/read error exits 0 and never traps a reply.

input=$(cat 2>/dev/null)
py=$(command -v python3) || exit 0

"$py" - "$input" <<'PYEOF'
import sys, json, re

try:
    data = json.loads(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1] else {}
except Exception:
    sys.exit(0)

# Loop guard: if we already blocked once in this stop-chain, let it through.
if data.get("stop_hook_active"):
    sys.exit(0)

tp = data.get("transcript_path") or ""
if not tp:
    sys.exit(0)

# Pull the text of the LAST assistant message from the JSONL transcript.
text = ""
try:
    with open(tp, "r", encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
            except Exception:
                continue
            if obj.get("type") != "assistant":
                continue
            msg = obj.get("message", {}) or {}
            parts = msg.get("content", [])
            if isinstance(parts, str):
                text = parts
            elif isinstance(parts, list):
                chunks = [p.get("text", "") for p in parts
                          if isinstance(p, dict) and p.get("type") == "text"]
                if chunks:
                    text = "\n".join(chunks)
except Exception:
    sys.exit(0)

if not text.strip():
    sys.exit(0)

lines = text.rstrip("\n").split("\n")
nonempty = [l for l in lines if l.strip()]

# One-liners / short replies are exempt — the footer rule is for substantive replies.
if len(nonempty) <= 2:
    sys.exit(0)

FOOTER = re.compile(r'show noise|to expand', re.I)

def block(reason):
    print(json.dumps({"decision": "block", "reason": "[footer-gate] " + reason}))
    sys.exit(0)

# 1) Nothing after the footer line.
footer_idx = None
for i, l in enumerate(lines):
    if FOOTER.search(l):
        footer_idx = i
if footer_idx is not None:
    after = [l for l in lines[footer_idx + 1:] if l.strip()]
    if after:
        block('Content appears AFTER the footer line. The footer must be the LAST line — '
              'fold whatever is below it into the footer counts or delete it, then re-emit.')

# Only scrutinise the trailing zone the user complains about: the last 8 non-empty lines.
footer_line = lines[footer_idx] if footer_idx is not None else None
tail = nonempty[-8:]

OFFER = re.compile(
    r'^\s*[-*>]*\s*(want me to|would you like|do you want|should i|shall i|'
    r'let me know|i can (also|go|now)|if you.?d like|feel free to)\b', re.I)
STATUS = re.compile(
    r'\b(untouched|nothing (?:to commit|installed|changed|to install)|no changes|'
    r'created at|updated at|session log (?:created|written|updated|added)|'
    r'staged for you)\b', re.I)
# Open-items / next-steps / "your turn" / call-to-action headers + strong user-directed
# imperatives in the trailing zone. These pull the user back in — the exact thing the
# footer exists to suppress. Anchored at line start (optional bullet/bold prefix).
CTA = re.compile(
    r'^\s*[-*>#]*\s*\**\s*'
    r'(your turn|open items?|open questions?|next steps?|to-?dos?|action items?|'
    r'follow[- ]?ups?|left to do|still (?:to do|pending)|'
    r"you(?:'ll| will)? (?:need|have|want) to|you (?:should|must|need to)|"
    r"remember to|don'?t forget|make sure to)\b", re.I)

for l in tail:
    if footer_line is not None and l is footer_line:
        continue
    if FOOTER.search(l):          # any footer-like line is exempt from the token checks
        continue
    if OFFER.search(l):
        block('The reply ends with a trailing offer ("want me to…" / "let me know…"). '
              'End on the last real point — delete that line and re-emit.')
    if STATUS.search(l):
        block('A bare status/recap line ("X untouched" / "created-updated at" / '
              '"session log written") is sitting in the trailing prose instead of the '
              'ONE footer line. Fold it into the footer counts (or drop it) and re-emit.')
    if CTA.search(l):
        block('An open-items / next-steps / "your turn" / call-to-action block is in the '
              'trailing prose. That pulls the user back in — the exact thing the footer '
              'exists to prevent. Fold it into the ONE footer line (a count/token) or move '
              'it into the doc/log, then re-emit. Nothing in the reply may prompt the user to act.')

sys.exit(0)
PYEOF
exit 0
