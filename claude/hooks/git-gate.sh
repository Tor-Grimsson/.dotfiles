#!/usr/bin/env bash
# PreToolUse (Bash) — the git/download gate. Replaces the old settings.json
# permissions.deny git rules so the block can be lifted at runtime: bin/agent-grant
# (tmux prefix g) opens a time-boxed window; flag = ~/.claude/.agent-grant (expiry epoch).
#
# Window closed: any git → deny, reason names the unlock command.
# Window open:   read-only git (+ clone/fetch) and downloads (wget/curl) auto-allow
#                when the whole command is recognisably read-only; git writes
#                (commit/push/add/…) stay denied; odd mixtures fall back to the
#                normal permission prompt ("ask"). Non-git commands: no opinion.
# Fail-open: parse trouble → exit 0 → normal permission flow.
# ponytail: naive top-level split on |/;/&&/|| — a wrong split can only downgrade
# to "ask"/"deny", never widen an allow. Bare-path /usr/bin/git dodges the gate
# but still lands on the normal permission prompt.

# heredoc = python's stdin (the program), so the hook JSON is captured here and
# handed over via env — json.load(sys.stdin) inside the heredoc would read nothing
HOOK_INPUT=$(cat 2>/dev/null) \
GRANT_FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.agent-grant" \
python3 <<'PY'
import json, os, re, sys, time

flag = os.environ.get("GRANT_FLAG", "")

def grant_active():
    try:
        exp = int(open(flag).readline().strip())
    except Exception:
        return False
    if time.time() < exp:
        return True
    try:
        os.remove(flag)
    except OSError:
        pass
    return False

try:
    data = json.loads(os.environ.get("HOOK_INPUT", "{}"))
    cmd = data.get("tool_input", {}).get("command", "") or ""
except Exception:
    sys.exit(0)

if not re.search(r"\b(git|wget|curl)\b", cmd):
    sys.exit(0)

READ = {"log", "show", "diff", "status", "blame", "branch", "remote", "rev-parse",
        "ls-files", "ls-remote", "ls-tree", "cat-file", "shortlog", "describe",
        "reflog", "grep", "clone", "fetch", "version", "--version", "help"}
# branch/remote are read-only ONLY without their write flags/verbs
WRITEY = {"-d", "-D", "-m", "-M", "-c", "-C", "--delete", "--move", "--copy",
          "add", "remove", "rename", "set-url", "set-head", "set-branches",
          "prune", "update", "--edit-description"}
FILTERS = {"head", "tail", "grep", "wc", "cat", "sort", "uniq", "awk", "sed",
           "tr", "cut", "column"}
DOWNLOAD = {"wget", "curl"}

def verdict(decision, reason):
    print(json.dumps({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": decision,
        "permissionDecisionReason": reason}}))
    sys.exit(0)

def git_sub(seg):
    toks = seg.split()[1:]
    skip = False
    for t in toks:
        if skip:
            skip = False
            continue
        if t in ("-C", "-c", "--git-dir", "--work-tree"):
            skip = True
            continue
        if t.startswith("-") and t not in ("--version",):
            continue
        return t, toks
    return "", toks

segs = [s.strip() for s in re.split(r"\|\||&&|;|\||\n", cmd) if s.strip()]
git_segs = [s for s in segs if re.match(r"^git(\s|$)", s)]

# $(…) / `…` / <(…) can hide arbitrary commands inside a read-only-looking line
has_subst = re.search(r"\$\(|`|<\(", cmd) is not None

if git_segs:
    if not grant_active():
        verdict("deny", "git is gated — user opens a window with: agent-grant 15 (tmux: prefix g)")
    if has_subst:
        verdict("ask", "grant window open, but the command embeds a substitution — confirm")
    for s in git_segs:
        sub, toks = git_sub(s)
        if sub not in READ:
            verdict("deny", f"grant window is read-only — 'git {sub or '?'}' stays blocked (writes are the user's)")
        if sub in ("branch", "remote") and any(t in WRITEY for t in toks[1:]):
            verdict("deny", f"grant window is read-only — 'git {sub}' with a write flag stays blocked")
    for s in segs:
        first = s.split()[0]
        if first == "git" or first in FILTERS or first in DOWNLOAD:
            continue
        verdict("ask", "grant window open, but the command mixes in more than git-read/filters — confirm")
    verdict("allow", "agent-grant window open — read-only git allowed")

if grant_active() and not has_subst and all(s.split()[0] in DOWNLOAD | FILTERS for s in segs):
    verdict("allow", "agent-grant window open — download allowed")

sys.exit(0)
PY
exit 0
