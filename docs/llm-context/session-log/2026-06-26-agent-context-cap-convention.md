# Session: AGENT-CONTEXT cap convention (stop the append-only bloat)

**Date:** 2026-06-26
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** AGENT-CONTEXT had grown to 99.7 KB (~25k tokens, loaded every session) because the "Last updated" chain is append-only and never pruned — a slow-motion context blowout. Trimmed this repo to 5 entries and encoded a hard cap into the `log-work` skill (global + canonical template) so the rule propagates to every init-agent-context'd repo.

## Changes Made

### Files Modified
- `docs/llm-context/AGENT-CONTEXT.md` — trimmed the chain to the **5 most recent** entries (older tail lives in `session-log/`). **99.7 KB → 69.9 KB.**
- `claude/skills/log-work/SKILL.md` (= `~/.claude/skills/log-work`, the global skill) — added the cap rule to step 4.
- `claude/packages/init-agent-context-templates/.claude/skills/log-work/SKILL.md` — same cap rule in step 5; **`_template.version` 1 → 2** (the drift signal for sync).

### The convention
- **AGENT-CONTEXT = current state**, capped at **5 entries / ~30 KB**; `session-log/` is the archive. On each `/log-work`: prepend new entry → trim to 5 → keep entries tight.

## Current State

### Working
- This repo's AGENT-CONTEXT is capped and ~30 KB lighter.
- `/log-work` (global + template) now enforces the cap going forward.

### How it propagates (the key design fact)
- `AGENT-CONTEXT.md` is **`sync: skip`** — `init-agent-context-sync` never edits it. So the cap can't be pushed onto the file; it's enforced by the **`log-work` skill**, which is `sync: replace`.
- A repo picks up the capped skill when it runs `/init-agent-context-sync` (sees v2 > v1 → replace), then **self-trims** on its next `/log-work`.
- **Pull, not push** — repos not synced stay uncapped until revisited.

## Next Steps
1. Run `/init-agent-context-sync` in the other init-agent-context'd repos as you revisit them (picks up log-work v2).
2. Watch entry verbosity — the cap limits *count*; long entries are the other half of the bloat.
