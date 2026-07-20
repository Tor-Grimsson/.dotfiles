---
_template:
  version: 1
  path: .kol/llm-context/README.md
  sync: notify-only
---

# LLM Context — dotfiles

Agent-context protocol for the `~/.dotfiles` repo. Read this directory before working here.

## Files
- **ARCHITECTURE.md** — load-bearing decisions. Read first; don't revisit without reason.
- **AGENT-CONTEXT.md** — current state: layout, key files, consistency seams, open items.
- **HISTORY.md** — *why* things are the way they are (decision history).
- **../llm-plan/** — speculative / not-yet-committed plans (peer folder, one `NN-slug.md` per plan).
- **session-log/** — chronological per-session records (newest = latest context).
- **session-bridge/** — short-lived handoffs for work paused mid-arc.

## Startup protocol
1. Read `ARCHITECTURE.md` → `AGENT-CONTEXT.md` → newest file in `session-log/`.
2. If a `session-bridge/handoff-*.md` is newer than the latest session log, read it too.
3. Update `AGENT-CONTEXT.md` and add a `session-log/` entry when you finish significant work.

The `scaffold-llm-context` skill (in `claude/skills/`) scaffolds this structure — no automated re-sync skill exists (`init-agent-context-sync` was quarantined 2026-07-05, unused). The kol-docs framework lives as the `kol-docs-{fm,md,lib}` packages in `claude/packages/`, scaffolded into a target repo by the separate `scaffold-docs-system` skill.

## The two rules that bite hardest (full list in AGENT-CONTEXT → Contracts)
- **Never run git** — the user owns the repo. Read files; don't `git` anything.
- **Never run provisioning** — `brew bundle`/`install`/`upgrade`, `bootstrap.sh`. Prepare files; the user runs them.
