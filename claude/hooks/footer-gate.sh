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

# The footer is identified by its SHAPE, not by a closing phrase: a whole line of
# two or more `·`-separated `label: value` tokens, optionally wrapped in backticks.
# (Was `show noise|to expand` until 2026-08-01 — the user removed that phrase as
# noise, so the detector moved to the grammar the footer already had.)
FOOTER = re.compile(r'^\s*`?\s*[\w/+-]+:\s*[^·|`]+(?:·\s*[\w/+-]+:\s*[^·|`]+)+`?\s*$')

def block(reason):
    print(json.dumps({"decision": "block", "reason": "[footer-gate] " + reason}))
    sys.exit(0)

# 1) Nothing after the footer line — EXCEPT module 05, `where we are`.
#
# Spec: kol-dumpty/humpty/docs/documentation/08-formats/05-where-we-are.md (the user's
# own design, 2026-07-31). It sits below the footer behind a break of two ------ rule
# lines, then ONE fenced block carrying ARC / DONE N-of-NN / NEXT. Anything else after
# the footer is the trailing prose this gate exists for and is still blocked.
RULE = re.compile(r'^_{6,}$')
footer_idx = None
for i, l in enumerate(lines):
    if FOOTER.search(l):
        footer_idx = i
if footer_idx is not None:
    after = [l for l in lines[footer_idx + 1:] if l.strip()]
    if after:
        # The module opens with a FENCE (so the breather's blank lines survive) and
        # carries the breather's two ______ rule lines inside it — the same shape the
        # header card has. Anything else after the footer is still trailing prose.
        legal = (after[0].strip().startswith('```')
                 and len([l for l in after if RULE.match(l.strip())]) >= 2)
        if not legal:
            block('Content appears AFTER the footer line. The footer must be the LAST line — '
                  'fold whatever is below it into the footer counts or delete it, then re-emit. '
                  '(The only exception is the `where we are` block: ONE fence carrying the '
                  'breather — two blank lines, two ______ rules, two blank lines — then '
                  'ARC/DONE/NEXT.)')

# Only scrutinise the trailing zone the user complains about: the last 8 non-empty lines.
footer_line = lines[footer_idx] if footer_idx is not None else None
tail = nonempty[-8:]

# OFFER, CTA and STATUS were DELETED 2026-08-01 after the first corpus measurement
# they ever had. `_files/gate-fp.py` over 4,469 real reply/response pairs:
#
#     FG status   coverage 1.5%   FP 2.0%
#     FG offer    coverage 1.2%   FP 1.4%
#     FG cta      coverage 0.2%   FP 0.5%
#
# The bar every other lever in this system is held to is coverage >= 15%. D2, D3, D4
# and D6 were all retired on it the same day; keeping these three would have been a
# second standard for the same job. They fired on runbook lines ("You'll need to run
# bootstrap-cli.sh"), on prerequisites ("Make sure to source the CLI half first"), on
# a footer token of its own ("open questions: 0"), and on the single architectural
# fork CLAUDE.md explicitly permits.
#
# WHAT SURVIVES is rule 1 above: nothing after the footer except module 05. It is the
# only rule here with no measured false positive, and it is the footer contract itself
# rather than a guess about phrasing.
#
# Full result: kol-dumpty/humpty/docs/documentation/06-measure/_results/
#              2026-08-01-every-reply-content-gate-is-under-the-bar.md
sys.exit(0)
PYEOF
exit 0
