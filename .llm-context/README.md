---
_template:
  version: 1
  path: .llm-context/README.md
  sync: notify-only
---

# LLM Context — dotfiles

Agent-context protocol for the `~/.dotfiles` repo. Read this directory before working here.

## Files
- **ARCHITECTURE.md** — load-bearing decisions. Read first; don't revisit without reason.
- **AGENT-CONTEXT.md** — current state: layout, key files, consistency seams, open items.
- **history.md** — *why* things are the way they are (decision history).
- **plan.md** — speculative / not-yet-committed ideas.
- **session-log/** — chronological per-session records (newest = latest context).
- **session-bridge/** — short-lived handoffs for work paused mid-arc.

## Startup protocol
1. Read `ARCHITECTURE.md` → `AGENT-CONTEXT.md` → newest file in `session-log/`.
2. If a `session-bridge/handoff-*.md` is newer than the latest session log, read it too.
3. Update `AGENT-CONTEXT.md` and add a `session-log/` entry when you finish significant work.

The `init-agent-context` / `init-agent-context-sync` skills (in `claude/skills/`) scaffold and re-sync this structure. The kol-docs framework is bundled at `claude/skills/kol-docs/_framework/`.

## The two rules that bite hardest (full list in AGENT-CONTEXT → Contracts)
- **Never run git** — the user owns the repo. Read files; don't `git` anything.
- **Never run provisioning** — `brew bundle`/`install`/`upgrade`, `bootstrap.sh`. Prepare files; the user runs them.
