#!/usr/bin/env bash
# PreToolUse (Bash) — the DELETE gate.
#
# The law (~/.dotfiles/claude/CLAUDE.md § Repo hygiene, 2026-08-01): nothing is
# ever deleted from a repo. Removing anything means MOVING it to
# `_tmp/<date>-<what>/` and saying where it went. `rm` is not an available verb.
#
# Why a hook and not a line in the rules: the line was already there in spirit
# ("never the root, never committed paths") and the neighbouring rule said
# "default to deletion over archival", so the agent read permission and ran
# `rm` on seven font files, a 16-file folder and two ttf. The user's words:
# *"how can this be burnt in your head?"* — prose could not burn it in, a
# blocked tool call can.
#
# DENIES: rm / rmdir / unlink / trash / `find -delete` / shred, anywhere.
# ALLOWS: paths under a scratch root the user already treats as disposable —
#   /tmp, /private/tmp, the session scratchpad, node_modules, dist, .vite —
#   plus `rm` inside a heredoc/quoted string (not an actual invocation).
# Fail-open: parse trouble -> exit 0 -> normal permission flow.

HOOK_INPUT=$(cat 2>/dev/null) python3 <<'PY'
import json, os, re, sys

try:
    data = json.loads(os.environ.get("HOOK_INPUT", "{}"))
    cmd = data.get("tool_input", {}).get("command", "") or ""
except Exception:
    sys.exit(0)

if not re.search(r"(^|[|;&(]|\s)(rm|rmdir|unlink|shred|trash)\s", cmd) \
   and "-delete" not in cmd:
    sys.exit(0)

# Scratch roots the user has already ruled disposable. A command whose targets
# are ALL under one of these is not repo content.
SCRATCH = (
    "/tmp/", "/private/tmp/", "/var/folders/",
    "node_modules", "/dist/", "dist/", ".vite", ".cache",
    "scratchpad", ".DS_Store",
)

# Strip the command name and flags; whatever is left is the target list.
targets = [t for t in re.split(r"\s+", cmd.strip())
           if t and not t.startswith("-")
           and t not in ("rm", "rmdir", "unlink", "shred", "trash", "&&", "||", ";", "find")]

if targets and all(any(s in t for s in SCRATCH) for t in targets):
    sys.exit(0)

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": (
            "rm-gate: NOTHING IS DELETED. Move it to `_tmp/<date>-<what>/` instead and say "
            "where it went — `mkdir -p _tmp/<date>-<what> && mv <paths> _tmp/<date>-<what>/`. "
            "Check `.gitignore` carries `_tmp/` in the same breath. "
            "\"It's recoverable from npm / the registry / ~/Library/Fonts\" is not a reason to "
            "delete: the user owns what leaves his repo, and he can read a diff but not a file "
            "that is gone. This outranks every clean-up / kill-redundancy instruction — those "
            "mean OUT OF THE TREE, and `_tmp/` is out of the tree."
        ),
    }
}))
PY
