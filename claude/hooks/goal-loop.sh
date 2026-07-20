#!/usr/bin/env bash
# goal-loop — Stop hook. While a /kol-goal is ACTIVE, block the Stop event and
# re-inject the goal so the agent keeps working (the "ralph loop"). It does not
# let the agent stop until the goal is marked done/blocked or the iteration cap
# is hit. Inert when no goal file exists.
#
# Goal state: <repo>/.kol/llm-context/.active-goal.md
#   status: active | done | blocked | capped
#   iter:   N        (auto-incremented each block)
#   max:    N        (runaway backstop, default 30)
#   goal:   <text>
#
# Escapes: /kol-goal done · /kol-goal blocked <reason> · delete the file · iter >= max.
# Fail-open: any parse/read error exits 0 and never traps a reply.
input=$(cat 2>/dev/null)
py=$(command -v python3) || exit 0

"$py" - "$input" <<'PYEOF'
import sys, json, os, re

try:
    data = json.loads(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1] else {}
except Exception:
    sys.exit(0)

cwd = data.get("cwd") or os.getcwd()
gf = os.path.join(cwd, ".kol", "llm-context", ".active-goal.md")
if not os.path.isfile(gf):
    sys.exit(0)                      # no active goal → allow stop

try:
    txt = open(gf, encoding="utf-8").read()
except Exception:
    sys.exit(0)

def field(name, default=""):
    m = re.search(r'(?m)^%s:\s*(.*)$' % re.escape(name), txt)
    return m.group(1).strip() if m else default

if field("status") != "active":
    sys.exit(0)                      # done / blocked / capped → allow stop

def as_int(v, d):
    try: return int(v)
    except Exception: return d

it, mx = as_int(field("iter", "0"), 0), as_int(field("max", "30"), 30)
goal = field("goal", "(unspecified)")

if it >= mx:                         # runaway backstop — release the loop
    open(gf, "w", encoding="utf-8").write(re.sub(r'(?m)^status:.*$', "status: capped", txt))
    sys.exit(0)

# increment the iteration counter and persist
if re.search(r'(?m)^iter:', txt):
    newtxt = re.sub(r'(?m)^iter:.*$', "iter: %d" % (it + 1), txt)
else:
    newtxt = txt.rstrip() + "\niter: %d\n" % (it + 1)
open(gf, "w", encoding="utf-8").write(newtxt)

reason = ("[goal-loop] The active goal is NOT complete — keep working; do the next "
          "concrete step NOW, do not stop to ask. GOAL: %s. When it is fully and "
          "verifiably done, run `/kol-goal done`. If you genuinely need the user to unblock "
          "you, run `/kol-goal blocked <reason>` then stop. (iteration %d/%d)"
          % (goal, it + 1, mx))
print(json.dumps({"decision": "block", "reason": reason}))
sys.exit(0)
PYEOF
exit 0
