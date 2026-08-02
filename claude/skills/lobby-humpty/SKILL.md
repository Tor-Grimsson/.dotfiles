---
name: lobby-humpty
description: Port the current conversation into humpty's lobby as a tracked ticket — a behaviour brief about the agent itself (muzzling, word-soup, ignored laws, gates that didn't fire), carrying the user's VERBATIM wording plus the evidence from this session. Writes the entry, the ledger row and the history line in one pass. Use on /lobby-humpty, or when the user says "file that against humpty", "log this as an agent-behaviour issue", "brief this".
---

# lobby-humpty — this conversation → humpty's queue

The agent-behaviour lobby. When *this agent* misbehaved — padded a status reply, ignored a clamp, manufactured work from a closed question, buried a verdict under research — the finding belongs in `humpty`, with the wording that produced it.

**Destination:** `~/dev/projects/kol-dumpty/humpty/lobby/inbox/`
**Ledger:** `LEDGER.md` at that lobby's root — humpty's ledger is `LEDGER.md`, **not** `INDEX.md`. Check both when reading any lobby.

## The rule that outranks the others

**Quote the user verbatim. Never paraphrase.** A brief's value *is* the exact wording, and an agent paraphrasing a complaint about its own behaviour launders the evidence. Quote first, annotate second, keep the two visually separate.

## Steps

1. **Name the failure** — the *behaviour*, not the topic. What did the agent do that it shouldn't have, or fail to do that it should have? Can't say it in one sentence → ask, don't invent.
2. **Collect this session's evidence** — the user's exact words, what the agent emitted, which law or clamp was in force, what it cost.
3. **Slugify** — kebab-case naming the defect: `zero-is-an-answer.md`, `research-dump.md`. Not `issue-4.md`.
4. **Write `lobby/inbox/<slug>.md`** in the shape below.
5. **Append the LEDGER row** at 🔵 `filed` + a dated `History` line. Same pass — an entry without a row is drift the moment it lands.
6. **Write the receipt in THIS repo** — `lobby/outbox/<same-slug>.md`, plus its row under **Filed elsewhere** in this repo's own ledger. Same pass again. humpty's bar for closing is a measurement, so its briefs sit longest; the receipt is the only thing that tells the filing repo one ever came back. Current repo has no `lobby/` → skip it and say so. Shape: `04-conventions.md` § A receipt.
7. **Report** what landed, where, and that it is **not** started.

## Entry shape

```markdown
# <the defect, named — not the topic>

**Staged:** YYYY-MM-DD · from a <repo> session
**Change:** <how big the ask is>

---

## What the user said

> <VERBATIM. Several quotes if the pattern repeated. Do not clean up the
>  wording, the punctuation, or the anger — it is the data.>

## What the agent did
<the emitted behaviour, plainly. Quote its output where it matters.>

## Which law was in force
<the clamp, dial level or law that should have caught it, and why it
 didn't. "None applied" is a valid and important finding.>

## What it cost
<the concrete consequence: a wrong build, N repeated corrections, a
 reply the user had to re-read, a ruling reopened.>

## The fix
<what would close it — a law change, a gate, a clamp, a hook.>

## Rejected alternative
<what you considered and why it lost.>

## Definition of done
- [ ] <checkable>
- [ ] <one of these must be a MEASUREMENT — see the bar below>
```

## humpty's bar for closing

Stricter than every other lobby, and it stays: 🟢 `closed` requires a **measurement** in `docs/documentation/06-measure/_results/` that names the brief and shows the failure no longer reproduces. An opinion does not close a humpty brief. `read` and `addressed` are not `closed` — six briefs were researched on 2026-07-30 and not one was fixed.

Whatever the verdict — closed, retired, or re-homed to another repo — **the receipt goes back the same turn**, carrying the remainder or `none`. `goal-loop-is-repo-scoped` was filed here, re-homed to dotfiles and closed there on 2026-08-01, and humpty's own ledger row is the only place that outcome is recorded.

## Do not

- Do not edit existing briefs — their value is verbatim user wording.
- Do not file a *topic* here. A design question → `/lobby-ds`; a script bug → `/lobby-dotfiles`. humpty is for how the agent **behaves**.
- Do not set a state above `filed`. Reading your own brief does not advance it.
- Do not start the fix. This is an inbox.
- Do not file without a receipt — a brief the filing repo has no record of is invisible one repo over.

Protocol: `~/.dotfiles/docs/operations/systems/lobby/02-lifecycle.md` · card: `ref-lobby`.
