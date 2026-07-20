---
_template:
  version: 1
  path: .kol/llm-plan/README.md
  sync: notify-only
---

# llm-plan — speculative plans

Forward-looking, not-yet-committed work for `~/.dotfiles`, peer to `llm-context/`. Kept out of `llm-context/` (which is *current* state) so plans don't bloat what loads every session.

## Convention

- **One plan per file**, `NN-slug.md` — two-digit prefix, kebab slug. Not dated (that's `session-log/`).
- `01-parking-lot.md` is the catch-all backlog for small speculative ideas; graduate an item into its **own** `NN-` file when it becomes real, standalone work.
- Nothing here is committed. When a plan becomes active work, fold it into `llm-context/AGENT-CONTEXT.md` (Open items) and mark/remove it here.

## Current plans

| File | What |
|---|---|
| `01-parking-lot.md` | The backlog — speculative ideas + deferred cleanups, each with premise / shape / tradeoffs / kill criteria. |
| `02-docs-restructure.md` | `docs/` restructure record (phase-1 done; follow-on `.obsidian` seeding + kol-vault sync-script repoint pending). |
