#!/usr/bin/env bash
# goal-loop — Stop hook. While a /kol-goal is ACTIVE, block the Stop event and
# re-inject the goal so the agent keeps working (the "ralph loop"). It does not
# let the agent stop until the goal is marked done/blocked or the iteration cap
# is hit. Inert when no goal file exists.
#
# Goal state: <repo>/.kol/llm-context/.active-goal.md
#   status:  active | done | blocked | capped
#   iter:    N        (auto-incremented each block)
#   max:     N        (runaway backstop, default 30)
#   session: <id>     (OWNER. absent = pre-2026-08-01 file, behaves as before)
#   goal:    <text>
#
# OWNERSHIP, added 2026-08-01. The file is keyed off `cwd`, so two sessions in one repo
# shared ONE goal: a session that had completed its own ask and marked it `done` was
# blocked FIVE times by a goal another session wrote two minutes earlier, and the only
# sanctioned exit wrote into that other session's live state. Every documented escape
# was repo-global; KOL_HEADLESS=1 is a wrapper flag, not a per-instance bypass.
# A goal now carries the `session_id` that created it and is INERT to anyone else.
# Brief: ~/.dotfiles/lobby/inbox/goal-loop-is-repo-scoped.md
#
# Escapes: /kol-goal done · /kol-goal blocked <reason> · delete the file · iter >= max.
# Fail-open: any parse/read error exits 0 and never traps a reply.
#
# HEADLESS EXEMPTION: a wrapper running `claude -p` sets KOL_HEADLESS=1. Print
# mode has nobody to type `/kol-goal done`, so a blocked Stop would trap the run
# forever — the 2026-07-31 deadlock without the human who noticed it. A stray
# `.active-goal.md` left `active` in a repo would otherwise poison every headless
# run started there. Checked FIRST, before anything else can block.
# Contract: docs/operations/systems/headless-agents/04-safety.md
[ -n "${KOL_HEADLESS:-}" ] && exit 0

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

status = field("status")
force  = field("mode") == "force"
goal   = field("goal", "(unspecified)")

# --- OWNERSHIP: a foreign goal is inert, never a trap -------------------------------
# `session:` is written by /kol-goal from the same `session_id` this payload carries.
# Mismatch -> exit 0: the goal belongs to another live session, and blocking on it
# traps an agent that never set a goal, whose only documented exits all write into
# that other session's state. A file with NO `session:` line keeps the old behaviour
# exactly, so every goal written before 2026-08-01 still works.
owner = field("session")
if owner and owner != (data.get("session_id") or ""):
    sys.exit(0)

# --- FORCE MODE: police the exits ------------------------------------------
# /kol-goal-force means "you decide". The normal loop is escapable two ways the
# user did not intend: the agent ends a turn asking a question, or it calls
# `blocked` for a reason that is really a preference. Force mode refuses both.
#
# It never polices the iteration cap, and never polices a blocker the agent
# genuinely cannot act around — see LEGAL below. A goal loop that cannot be
# escaped by a real blocker is the 2026-07-31 deadlock: a mode gate denied every
# write, `blocked` needed a write, and 11 iterations burned with no legal move.
LEGAL = (
    "permission", "denied", "not allowed", "gate", "blocked by",
    "credential", "api key", "token", "not authenticated", "auth",
    "does not exist", "no such", "not installed", "not found on path",
    "network", "offline", "unreachable", "rate limit",
)

# The ask-shape: the agent handing the decision back instead of making it.
ASK = (
    "which would you", "which do you", "would you prefer", "do you want me",
    "should i ", "shall i ", "let me know", "your call", "up to you",
    "waiting for", "needs you", "needs your", "open question", "open issue",
    "open items", "next steps", "i need to know", "not sure which",
    "could go either way", "please confirm", "confirm before",
)

def last_assistant_text(path):
    """Last assistant message text from the JSONL transcript. Same extractor as
    claude/hooks/footer-gate.sh — kept identical on purpose."""
    text = ""
    try:
        with open(path, "r", encoding="utf-8") as fh:
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
                parts = (obj.get("message", {}) or {}).get("content", [])
                if isinstance(parts, str):
                    text = parts
                elif isinstance(parts, list):
                    chunks = [p.get("text", "") for p in parts
                              if isinstance(p, dict) and p.get("type") == "text"]
                    if chunks:
                        text = "\n".join(chunks)
    except Exception:
        return ""
    return text

if force and status == "blocked":
    # A blocker is LEGAL only when no decision the agent could make would help —
    # the capability is absent, not the judgement.
    # Read ONLY the `blocked:` field, never the whole file: the goal text itself
    # could contain a LEGAL keyword ("fix the auth flow") and false-pass the gate.
    why = field("blocked", "").lower()
    if not any(k in why for k in LEGAL):
        print(json.dumps({"decision": "block", "reason":
            "[goal-loop:force] `blocked` REFUSED. The reason given is a preference, not a "
            "blocker. A blocker is something no decision of yours could route around — a "
            "denied permission, a missing credential, a path that does not exist. Wanting "
            "the user's opinion is not one. The user pre-authorised you to decide: pick the "
            "best option, state the assumption in one line, and keep going. GOAL: %s" % goal}))
        sys.exit(0)
    sys.exit(0)                      # legal blocker → release

def as_int(v, d):
    try: return int(v)
    except Exception: return d

it, mx = as_int(field("iter", "0"), 0), as_int(field("max", "30"), 30)

# --- THE CHECKLIST: `done` is the FILE's call, not the agent's ----------------------
# Added 2026-08-01, third occurrence of one failure class. The goal was a single prose
# blob and `status` was binary, so a multi-item plan had nothing the hook could count:
# the agent wrote `status: done` and the loop released, whatever was left undone.
#   2026-07-30  `done` written at each sub-step — "that is gaming the loop"
#   2026-08-01  "wtf. why are these tasks open still? did the loop fail?" — it did not
#   2026-08-01  T1 rejected, session closed instead of moving to T2
# The user: "it should jsut move to next item right? not close out because t1 wasd
# rejected?" It could not, because it did not know there were items.
#
# Now: any `- [ ]` / `- [x]` lines in the goal file ARE the list. Marking `done` with
# boxes unticked flips the goal back to `active` and re-injects the NEXT one by name.
#
# NOT A TRAP, by three separate outs:
#   * a file with NO checkboxes behaves exactly as before (every pre-existing goal),
#   * `blocked` still releases — a real blocker means the list cannot be finished,
#   * the iteration cap is checked FIRST and is never policed, so the loop always ends.
ITEM = re.compile(r'(?m)^[ \t]*-[ \t]*\[([ xX])\][ \t]*(.+?)[ \t]*$')
items = ITEM.findall(txt)
todo  = [t for mark, t in items if mark == " "]

if items and status == "done" and todo and it < mx:
    # Flip it back and count the attempt, so the cap still bounds this path.
    newtxt = re.sub(r'(?m)^status:.*$', "status: active", txt)
    if re.search(r'(?m)^iter:', newtxt):
        newtxt = re.sub(r'(?m)^iter:.*$', "iter: %d" % (it + 1), newtxt)
    else:
        newtxt = newtxt.rstrip() + "\niter: %d\n" % (it + 1)
    try:
        open(gf, "w", encoding="utf-8").write(newtxt)
    except Exception:
        sys.exit(0)                  # fail-open: never trap on a write error
    print(json.dumps({"decision": "block", "reason":
        "[goal-loop] `done` REFUSED — %d of %d items are still unticked. An item you could "
        "not finish is not a reason to close the goal; it is a reason to MOVE ON to the next "
        "one and come back. DO THIS NEXT: %s. Tick each box in .active-goal.md as it lands. "
        "Only if something no decision of yours can route around is stopping you, run "
        "`/kol-goal blocked <reason>`. (iteration %d/%d)"
        % (len(todo), len(items), todo[0], it + 1, mx)}))
    sys.exit(0)

if status != "active":
    sys.exit(0)                      # done / blocked / capped → allow stop

# The runaway backstop is checked BEFORE any force policing and is NEVER policed.
# A loop that cannot be escaped even at the cap is the 2026-07-31 deadlock.
if it >= mx:
    open(gf, "w", encoding="utf-8").write(re.sub(r'(?m)^status:.*$', "status: capped", txt))
    sys.exit(0)

if force and not data.get("stop_hook_active"):
    # Loop-safe: only one refusal per stop-chain, so a stubborn reply can still land.
    body = last_assistant_text(data.get("transcript_path") or "").lower()
    if body and any(k in body for k in ASK):
        hit = next(k for k in ASK if k in body)
        print(json.dumps({"decision": "block", "reason":
            "[goal-loop:force] ILLEGAL — you are ending the turn with the decision handed "
            "back (\"%s\"). The user ran /kol-goal-force precisely so you would NOT do this. "
            "Make the call yourself: choose the option you'd defend, write one line saying "
            "which assumption you took, and carry on. Ask only if proceeding under ANY "
            "assumption would be unsafe or destroy work. GOAL: %s" % (hit.strip(), goal)}))
        sys.exit(0)

# increment the iteration counter and persist
if re.search(r'(?m)^iter:', txt):
    newtxt = re.sub(r'(?m)^iter:.*$', "iter: %d" % (it + 1), txt)
else:
    newtxt = txt.rstrip() + "\niter: %d\n" % (it + 1)
open(gf, "w", encoding="utf-8").write(newtxt)

nxt = ("\nNEXT ITEM: %s  (%d of %d still unticked)" % (todo[0], len(todo), len(items))
       if todo else "")
reason = ("[goal-loop] The active goal is NOT complete — keep working; do the next "
          "concrete step NOW, do not stop to ask. GOAL: %s.%s When it is fully and "
          "verifiably done, run `/kol-goal done`. If you genuinely need the user to unblock "
          "you, run `/kol-goal blocked <reason>` then stop. (iteration %d/%d)"
          % (goal, nxt, it + 1, mx))
print(json.dumps({"decision": "block", "reason": reason}))
sys.exit(0)
PYEOF
exit 0
