---
title: The ticket protocol — states, the blocking flag, and per-repo bars
type: reference
status: active
updated: 2026-08-01
description: One state ladder shared by every lobby, two orthogonal flags (needs-ruling, remainder), a bar for closing that each repo sets for itself, and the outbox return receipt — plus the same-turn law in both directions, staleness, and who is allowed to decide what.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/workflow
related:
  - "[[INDEX|Lobby]]"
  - "[[01-registry|the four lobbies]]"
  - "[[04-conventions|entry + ledger shape]]"
---

## Why one ladder and one flag

Two dialects existed before this. **humpty** tracked *evidence* — `filed → researched → addressed → verified`. **kol-ds-ui** tracked *authority* — `NEEDS RULING`, `USER RULING`, `parked`.

They were never competing models. They are **perpendicular axes**: one says how far the work has got, the other says whose call it is. Collapsing them into a single list loses information either way. So the protocol keeps both — a ladder for progress, a flag for authority.

## The ladder

Universal. Where the file lives is **derived from the state**, never chosen separately.

| | state | means | lives in |
|---|---|---|---|
| 🔵 | `filed` | captured, unread | `inbox/` |
| 🟡 | `read` | understood — the ledger row restates it in the agent's own words | `inbox/` |
| 🟠 | `addressed` | a change shipped that is *meant* to close it | `inbox/` |
| 🟢 | `closed` | met this repo's bar; `## ✅ RESOLUTION — <date>` appended | `done/` |
| ⚪ | `parked` | deliberately not-now, reason recorded — **revisitable** | `archive/` |
| ⚫ | `retired` | closed **without** a fix, with the reason written down — **terminal** | `archive/` |

**`read` is never `closed`.** This is humpty's hardest-won distinction, generalised: six briefs were consumed into research on 2026-07-30 and not one of them was fixed. A ledger that collapsed those into "done" would have been lying. Understanding a ticket ships nothing.

**`addressed` is not `closed` either.** A change *meant* to fix something is a hypothesis until it meets the bar.

**`parked` is not `retired`.** Both live in `archive/` and for a year they wore one glyph, which is how a *finished* ticket became indistinguishable from a *deferred* one. They are opposite endings:

> *"Retired is not 'we gave up'. It is the ledger's second honest ending: closed without a fix, with the number written down."* — humpty's LEDGER, which carried the distinction before the spec did.

⚪ `parked` is a **not-yet**: the ask still stands, the moment was wrong. ⚫ `retired` is a **not-ever**, and it costs more than parking — the reason is the deliverable. A brief retired because no instrument can measure it, or because the shape happened once and never recurred, is *answered*; carrying it as open forever is the dishonesty the ledger exists to prevent.

The practical consequence is in § Staleness: **a retired entry can never be a stale candidate**, because stale is the opposite of finished.

## The flag

| | flag | means |
|---|---|---|
| 🔴 | `needs-ruling` | **blocked on the user's call** |

Orthogonal — it sits on any state, and the entry stays wherever that state puts it. This is kol-ds-ui's `NEEDS RULING` generalised so any lobby can block a ticket without inventing a state for it. An agent that meets 🔴 stops and asks; it does not reason its way past the flag.

## What a lobby is FOR — a portal, not a tracker

**A lobby is a build-and-info portal: an intake for a brief, and the place its outcome is recorded.** It is not a list of open work. The user, 2026-08-01:

> *"we cant keep lobby items open just because they havent been implemented, thats not what the lobby does, its just a build and info portal"*

The distinction is load-bearing, because the opposite reading produced a queue of four rows with **zero** outstanding agent work: one entry shipped and verified days earlier but parked at 🟠, two receipts 🟢 with `Remainder here: none` still printed live, and one whose upstream fix had already shipped and been consumed. The user had to read all four to discover there was nothing to do. That is `never-manufacture-tasks` on a new surface — not inventing work, but failing to retire finished work, which reads identically to him.

## The bar for 🟢 closed — purpose served

**When the thing the entry asked for exists and is verified, the ticket closes.** The resolution is appended, the evidence is cited, and the row leaves the live table the same turn. **Confirmation is how a ticket is disputed, not how it is closed** — the user reopens it if the work was wrong.

The old bar (*"the user confirms it"*) was written to stop the agent declaring victory. Read literally it stopped the agent **filing anything**, which is the failure above. It is replaced, not softened: every repo keeps its own standard of proof, and the evidence requirement is unchanged.

| repo | what counts as proof the purpose was served |
|---|---|
| **humpty** | a **measurement** in `docs/documentation/06-measure/_results/` that names the brief and shows the failure no longer reproduces. Not an opinion. (Its `verified`, unchanged.) |
| **kol-ds-ui** | a shipped version / changeset cited in the resolution |
| **kol-website** | the change shipped and verified in the running app, cited by file and line |
| **dotfiles** | the change shipped and verified by running it, cited by file |

Each lobby's `INDEX.md` states its own proof standard so a reader never has to come here for it.

### Two questions the old bar conflated

| Question | Who answers it | Where it lives |
|---|---|---|
| **Was the asked-for thing built?** | the agent, with evidence | the ticket — and answering it closes the ticket |
| **Is the design decision right?** | **only the user** | the repo's focus file (`AGENT-CONTEXT.md` § awaiting rulings) — **never a lobby row** |

**A decision is never a lobby item.** If what remains is a choice rather than a build, the ticket closes and the choice moves to the focus file. No item lives in both places, and no ticket is held open waiting for an opinion.

**A receipt at 🟢 whose `Remainder here:` is `none` leaves the live table the turn it lands.** It is history; keeping it visible is the same defect one column over.

**This does not license silent closing.** The 2026-07-30 breach was work closed with no bookkeeping. Purpose-served closing still writes the resolution, the evidence and the ledger row — it changes *who may close*, never *whether it is recorded*.

## The return receipt — `outbox/`

Everything above describes the ticket travelling **one way**. It doesn't come back, and that is a hole with a real casualty:

> `~/.dotfiles/lobby/done/agent-init-docs-index.md` was **filed from a kol-ds-ui session**, closed in dotfiles on 2026-08-01. Its own resolution ends *"The per-repo half stays open by design"* — an authoring job that only kol-ds-ui can do. kol-ds-ui filed it, kol-ds-ui owns the remainder, and **nothing in kol-ds-ui records either fact.** Its agent boots with no way to learn it.

So the queue is mirrored. `inbox/` is what other repos sent **here**; `outbox/` is what this repo sent **elsewhere**, and what came back.

```
<repo>/lobby/
├── inbox/     tickets addressed to THIS repo   ← other repos wrote these
└── outbox/    receipts for tickets this repo FILED elsewhere
```

### The receipt is a copy, not a second truth

**The destination ledger is the truth about a ticket's state.** An outbox stub is a *receipt of last-known state*, it carries a `synced:` date, and it names its source so any reader can go check. A receipt that disagrees with the destination ledger is stale, never right — this is law 1 applied across the repo boundary rather than weakened by it.

### The remainder flag

| | flag | means |
|---|---|---|
| 📌 | `remainder` | the destination is **done** with it; **this** repo is not |

Orthogonal to the ladder, exactly like 🔴 `needs-ruling` — a ticket can be 🟢 `closed` at its destination and still 📌 here. That combination is the entire reason `outbox/` exists, and it is what a booting agent must be told first.

### The two moments a receipt is written

| moment | who writes | what lands |
|---|---|---|
| **filing** | the writer skill, in the **filing** repo | `outbox/<slug>.md` at 🔵 `filed`, plus the origin ledger row — same turn as the entry itself (law 5, applied to both ends) |
| **closing** | whoever closes the ticket, in the **destination** repo | a `## ✅ RETURNED — <date>` section appended to that stub, its state flipped, and **the remainder named** — same turn as the resolution (law 2, applied in both directions) |

Between those two moments the receipt honestly says *filed, no news*. It does not guess.

### Reading it

`ag-init` / `agent-init` read `lobby/outbox/` at boot and report two classes, in this order: **returned with a remainder** (📌 — this repo owes work it never asked for a reminder about), then **still open elsewhere** (🔵 🟡 🟠 — filed, no news, so don't re-file it). Everything 🟢 with no remainder is history and stays silent.

**No hook.** A `PreToolUse` mirror of `doc-sync-reminder.sh` was considered and dropped for the same reason `agent-init-docs-index.md` dropped one: a grep on every edit forever, to deliver less than a folder read once at boot. The boot path is cheaper and earlier.

## The laws

1. **The ledger is the truth — never a raw file sweep.** A file's state lives in its ledger row. Before touching or reporting anything lobby, read the ledger first. `ls inbox/` is not an audit.
2. **The ticket closes the same turn the work closes — at both ends.** Resolution section → file move → ledger row updated (queue row removed, count fixed, Closed/Archived line added) → **the origin repo's `outbox/` receipt returned**, in the *same pass* as the substance. This is the breach the discipline exists to prevent, and the return half is the breach it kept having anyway: two tickets closed on 2026-08-01 and neither filing repo was told.
3. **The agent closes on evidence; everything else is the USER's call.** *Narrowed 2026-08-01 — it read "open · closed · stale · parked is the USER's call", and that literal reading is what produced a queue of four finished rows.*
   - **The agent may close** a ticket whose asked-for thing exists and is verified, with the proof its repo requires cited in the resolution. That is purpose-served, and it is an obligation, not a permission — leaving finished work in the queue is drift.
   - **Only the user may** park an entry, declare one stale, reopen anything, or settle a design decision. A `parked` row means parked; it is not an invitation.
   - The agent still never promotes an entry to "open issue" and never invents a queue row.
4. **`inbox/` holds live entries only** — live meaning *outstanding agent work*, never *unconfirmed*. Resolved → `done/`. Ownership, deferral and context notes → `archive/`. Each carries its resolution section *before* the move. **A row whose work is verified, or whose only remainder is a user decision, is not live** — it closes and the decision moves to the focus file.
5. **No entry without a ledger row — and no ticket without a receipt.** Whatever writes the file writes the row, in the same action; whatever files a ticket *elsewhere* writes the `outbox/` stub in the filing repo, in that same action. An entry that exists without a row is drift the moment it lands — that is exactly how `ShowSansItalicDisplay` sat unrecorded in kol-website for a day. A ticket sent with no receipt is the same drift, one repo over.
6. **A lobby is a work queue, not docs.** It sits outside `docs/` deliberately. Don't frontmatter-police it.
7. **The destination ledger is the truth; the receipt is a dated copy.** An `outbox/` stub never overrides the ledger it points at. When they disagree the receipt is stale — re-sync it, don't argue with it.

## Staleness

Every entry carries a **`staged:`** date in its header and a **Staged** column in the ledger. Without it "stale" is a word nobody can act on — and for a year it was, because the *rule* read `staged:` while the writers emitted `date:`. Measured in kol-ds-ui 2026-08-01: **`staged:` appeared in 0 of 113 entry files**, so the ageing pass had never once run on the largest lobby in the estate. Not a missed threshold — a field lookup that returned nothing, invisible from the ledger because the ledger's Staged *column* was populated correctly all along. The field name is settled in [[04-conventions|04-conventions]] § An entry; a reader accepts the `date:` alias, a writer never emits it.

**Only a live entry ages.** The clock runs on 🔵 🟡 🟠 in `inbox/` — a ticket that has been sitting.

| state | ages? | why |
|---|---|---|
| 🔵 🟡 🟠 | **yes** | live queue: filed and not yet closed is exactly what staleness measures |
| 🟢 `closed` | never | it shipped |
| ⚫ `retired` | never | it was answered. **Retired is the opposite of stale, not a species of it** — surfacing a retired brief as a stale candidate is the single worst output the audit can produce, because it reopens a question the ledger already closed with its reason |
| ⚪ `parked` | **for review, never as stale** | the ask still stands, so age is genuinely informative — but law 3 governs: a parked row is surfaced under its own heading with its date and nothing else. *"A `parked` row means parked — it is not an invitation."* |

| age since `staged:` | what it means |
|---|---|
| < 30 days | normal |
| 30–90 days | **ageing** — surfaced by `/lobby-hygiene` as a candidate, with evidence |
| > 90 days | **stale candidate** — same, flagged harder |

The threshold surfaces candidates. **It never moves anything.** Law 3 holds: the ruling is the user's, and an agent that files an entry as stale on its own has broken the system it was asked to maintain.

## The audit pass

`/lobby-hygiene` diffs ledger against reality, both directions:

- ledger rows whose work is verifiably shipped (cite the version, commit, or log) → **candidates**, listed to the user with evidence; the close call is theirs unless the resolution is already user-ruled on record;
- files in `inbox/` with no ledger row, or rows pointing at moved or missing files → **ledger drift**, repair the ledger;
- entries in `done/` or `archive/` with no resolution section → note them;
- entries past the ageing threshold → surface with dates;
- **receipts out of sync** — an `outbox/` stub at 🔵 whose destination ledger says 🟢, or a destination `done/` entry whose origin repo has no receipt at all → **re-sync the receipt** (law 7: the destination wins). This half is mechanical and needs no ruling; naming the *remainder* does, and goes to the user.

Report: queue count before → after, moves made, calls left to the user. Never the words "open issue" for anything the user has not called open.
