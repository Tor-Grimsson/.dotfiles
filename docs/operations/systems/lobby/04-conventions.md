---
title: Entry and ledger shape
type: reference
status: active
updated: 2026-08-01
description: What a lobby entry looks like, what a ledger row carries, the resolution section, the outbox receipt and its returned section, and the done/ vs archive/ split.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|Lobby]]"
  - "[[02-lifecycle|the ticket protocol]]"
  - "[[03-tooling|skills + scripts]]"
---

## An entry

`<lobby>/inbox/<kebab-slug>.md`. **No YAML frontmatter** — a lobby is a work queue, not a docs-framework vault. A plain header block instead:

```markdown
# <One-line title: the ask, not the symptom>

**Staged:** 2026-07-31 · from a <repo> session
**Change:** <the size of it — "two files, one sentence each" / "new component">

---

## The problem, in one case
<the concrete failure. Not a category — the actual thing that went wrong,
with the cost. A reader who wasn't there must be able to picture it.>

## The fix
<what to do. Name files and line numbers where you can.>

## Rejected alternative
<what you considered and why it lost. Stops the next reader re-proposing it.>

## Definition of done
- [ ] <checkable>
- [ ] <checkable>
```

The `Definition of done` block is what lets an agent later prove the bar was met rather than assert it.

**Slug** = kebab-case, describes the ask. `agent-init-docs-index.md`, not `issue-3.md`. For `/lobby-ds` component specs the slug is the PascalCase component name — that convention predates this and stays.

### The staged date — the field is `staged:`, at both ends

The one field the protocol reads *mechanically*, so its name is not a matter of local taste. It is what [[02-lifecycle|02-lifecycle]] § Staleness measures and what `/lobby-hygiene` dates a back-filled receipt from.

| where the entry is | the field | written as |
|---|---|---|
| plain header block (the default above) | `**Staged:**` | `**Staged:** 2026-07-31 · from a <repo> session` |
| carrying frontmatter — the `/lobby-ds` component-spec exception | `staged:` | `staged: 2026-07-31` |
| **reading** an entry written before 2026-08-01 | `date:` | **accepted as an alias, never emitted.** A reader falls back to it; a writer that emits it is a defect |

`/lobby-ds` is the one entry shape with frontmatter, because a component spec carries structured fields the DS queue reads (`component:`, `source:`, `deps:`) — the same carve-out as its PascalCase slug. That exception is *the reason this rule had to be written down*: it emitted `date:`, the rule read `staged:`, and 113 entries fell through the gap in silence.

**A writer emits `staged:` in the same action it emits the ledger row** (law 5). An entry with neither field is unmeasurable, and the audit is entitled to date it from file mtime and say so in the entry.

## Evidence

Screenshots and files go in `<lobby>/_assets/`, referenced from the entry. A screenshot in a lobby entry is **evidence, not decoration** — a reader is expected to open it. `clip-drop.sh` names them `<NAME>_<timestamp>.png` and appends the embed, so re-running it on the same NAME stacks evidence rather than overwriting.

## A ledger row

```markdown
| | Entry | About | Staged | State |
|---|---|---|---|---|
| 🔵 | [slug](inbox/slug.md) | one line, what it asks | 2026-07-31 | `filed` — from a kol-ds-ui session |
```

| column | carries |
|---|---|
| emoji | the state, scannable — 🔵 🟡 🟠 🟢 ⚪ ⚫, plus 🔴 for `needs-ruling` and 📌 for `remainder` |
| Entry | a **relative link** to the file, so the ledger navigates |
| About | one line. What it asks for, not what it complains about |
| Staged | the `staged:` date. Staleness is unmeasurable without it |
| State | the word, plus the provenance or the blocker |

## The resolution section

Appended to the entry **before** it moves out of `inbox/`:

```markdown
## ✅ RESOLUTION — 2026-07-31

<what shipped, and the evidence that meets this repo's bar:
a version, a changeset, a measurement file, or "user confirmed <date>".>
```

No resolution section, no move. An entry that arrives in `done/` bare is indistinguishable from one that was quietly deleted.

## A receipt

`<filing-repo>/lobby/outbox/<same-slug>.md` — written by the writer skill in the **same turn** as the entry it mirrors ([[02-lifecycle|02-lifecycle]] law 5). Same slug at both ends, so the pair is greppable.

```markdown
# <the entry's own title>

**Filed:** 2026-07-31 → **kol-ds-ui**
**Entry:** `~/dev/projects/kol-ds-ui/lobby/inbox/<slug>.md`
**Ledger:** `~/dev/projects/kol-ds-ui/lobby/INDEX.md` — **the truth about this ticket**
**Last known:** 🔵 `filed` · synced 2026-07-31

## Why it went there
<one line. The reader is this repo's next agent, who did not file it.>

## What stays here
<the work this repo still owns, or `nothing`. Written at filing time as a
 prediction; rewritten at return time as a fact.>
```

On close, the **destination's** closing agent appends to that stub and rewrites the header's `Last known` line:

```markdown
---

## ✅ RETURNED — 2026-08-01

🟢 `closed` in **dotfiles** — <one line: what shipped, and the evidence that met their bar>
**Remainder here:** <what this repo must still do, or `none`>
```

`Remainder here:` is the load-bearing field and it is never omitted — `none` is a complete answer, an empty one is not. A receipt whose remainder is not `none` carries 📌 and is the first thing `ag-init` reports at boot.

## `done/` vs `archive/`

| folder | holds | test |
|---|---|---|
| `done/` | 🟢 closed — the ask was **met** | something shipped |
| `archive/` | ⚪ parked and ⚫ retired, plus ownership notes and deferrals | a decision was made *not* to do it, or it was never ours |

The distinction matters when reading history: `done/` is a record of work, `archive/` is a record of judgement. Collapsing them loses which rulings were made and why.

`archive/` holds **two** judgements, and the ledger row is what tells them apart:

| | state | the judgement | what the row owes |
|---|---|---|---|
| ⚪ | `parked` | not now | the reason, and what would unpark it |
| ⚫ | `retired` | not ever | the reason — and where it exists, **the number**. A retired entry that only says "won't do" is indistinguishable from an abandoned one |

Both keep a resolution section before the move (§ The resolution section) — for ⚫ it records what was *learned*, since nothing shipped.

## The ledger's own sections

Every lobby's `INDEX.md` carries, in order: the header block (how to file, how to read, link to this spec) · **States** (the table, including this repo's bar for 🟢) · **Queue** with a count · **Closed** · **Archived** · **Filed elsewhere** (the `outbox/` rows — destination · last-known state · remainder) · **History** (append-only, dated).

**Filed elsewhere** is the only section describing tickets this ledger does *not* govern, so every row names the destination ledger that does. Its rows carry a **Remainder** column instead of a State one — the state is someone else's to report, the remainder is this repo's to do.

The States table is repeated in each lobby on purpose. A ledger that makes you leave it to understand its own symbols is a ledger nobody reads.
