---
name: log-work-playbook
description: Append an entry to a live work-journal "playbook" in .kol/llm-context/playbook/ — a terse, append-only, real-timestamped running log kept DURING a multi-phase effort (one idea per line, no prose), distinct from the retrospective /log-work session log and the forward-looking /log-work-handoff. Use when the user invokes /log-work-playbook, or asks to journal work-in-progress, log a playbook entry, or start a playbook.
---

# Log Work — Playbook

A **playbook** is a live work journal: append-only, newest at the bottom, real timestamps, one idea per line, no prose. It runs *during* the work (an entry per change or decision). This skill appends one entry — or a milestone block, or scaffolds a new playbook. It is the piggyback sibling of `/log-work`:

| Skill | Writes | When | Shape |
|---|---|---|---|
| `/log-work-playbook` | `<ctx>/playbook/…md` | continuously, mid-work | append-only journal entries |
| `/log-work` | `<ctx>/session-log/…md` | at a milestone/phase close | retrospective summary |
| `/log-work-handoff` | `<ctx>/session-bridge/…md` | pausing mid-arc | forward-looking state |

**This skill does NOT touch `AGENT-CONTEXT.md`** — that's `/log-work`'s job at milestone close.

## Locate the context directory
Check in order, use the first that exists: 1. `.kol/llm-context/` (current) · 2. `.claude/llm-context/` · 3. `.llm-context/` · 4. `docs/llm-context/`. The playbook lives in `<ctx>/playbook/`. If no context dir exists, say so and stop.

## Steps

1. **Get the real time.** Run `date "+%H:%M %Z · %Y-%m-%d"`. The playbook's whole value is real timestamps — **never guess or reuse an old one.**
2. **Find or create the playbook.** Newest `<ctx>/playbook/*.md` is the active one — append to it (the common case). If none exists, or the user says "start/new playbook", `mkdir -p <ctx>/playbook` and create `<ctx>/playbook/`date +%Y-%m-%d`-<slug>.md` from the scaffold below.
3. **Match the file's own format.** If the active playbook declares an "Entry format" section, follow it exactly. Otherwise use the default entry shape below.
4. **Append at the BOTTOM** (newest last). **Never rewrite or reorder earlier entries** — append-only is the contract; the journal is a scrollback, not a summary.
5. **Report** — say `Playbook entry appended to <ctx>/playbook/<file>.md at HH:MM` (or `Playbook created …`). Do not update AGENT-CONTEXT.

## Default entry shape
One idea per line, terse. Drop any row that doesn't apply — the timestamp + `what` are the floor; `why`/`before`/`after`/`verify`/`note` are optional.

```
[HH:MM] · <phase>/<page> · <file:line>
  what → <one line>          why → <one line>
  before → <token/class>     after → <token/class>
  verify → build <✓/✗> · <check> <✓/✗>
  note → <exception / rescue / decision, if any>
```

Status legend (reuse the file's if it has one): `✓` done+verified · `~` in progress · `⤺` reverted · `▣` quarantined · `★` rescued.

## Milestone close
When the user closes a phase/page, append a milestone block, then remind them `/log-work` writes the matching session log:
```
──────────── MILESTONE: <phase/page> ──────────── [HH:MM]
  changed: N files · quarantined: N · rescued: N · build ✓
  log: session-log/<file>.md
```

## New-playbook scaffold (only when creating)
```
# Playbook — <effort title>

> **Live work journal.** Append-only, newest at the bottom, real timestamps. One idea per line, no prose.
> Milestone logs: `session-log/`.

**Goal:** <one–two lines>

**Standing rules (non-negotiable):**
- <rule>

---
## Entries

[HH:MM ZONE · YYYY-MM-DD] · setup · playbook created
  what → initialised the live playbook   why → <why>
```
