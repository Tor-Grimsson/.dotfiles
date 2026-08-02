---
name: lobby-hygiene
description: The lobby lifecycle discipline — keep any repo's lobby/ queue true to its own law (queue = live tasks only, resolutions filed same-turn, the ledger (INDEX.md or LEDGER.md) is the truth, statuses are the USER's call). Use when finishing work that originated from a lobby entry, when asked about lobby/queue state, or on /lobby-hygiene to audit-and-square a lobby. Born from the 2026-07-30 breach (work closed without bookkeeping, raw-file sweep mislabeled a parked entry as open).
---

# lobby-hygiene — the ticket never lags the work

The lobby pattern (any kol repo): `lobby/` at repo root is the intake queue
addressed to THAT repo's agent. **`lobby/inbox/` holds the live entries**;
`lobby/INDEX.md` (or `LEDGER.md`) is the ledger; `done/` holds closed entries,
`archive/` notes/rejects/deferrals, and **`outbox/` the receipts for tickets
this repo filed elsewhere**. Read side: `/lobby-list` · `bin/lobby`
(`prefix Ctrl+K`). Write side: `/lobby-dotfiles` · `/lobby-humpty` ·
`/lobby-web` · `/lobby-ds` · `/lobby-icon`. Router: `/lobby`.

## The laws

1. **The ledger is the truth — never a raw-file sweep.** A file's status lives
   in its ledger row, not in your reading of its content. Before touching or
   reporting anything lobby, read the ledger first — `lobby/INDEX.md`, or
   `lobby/LEDGER.md` where that's the name. A raw `ls` of `inbox/` is not an audit.
2. **`inbox/` holds LIVE tasks only** (user ruling 2026-07-30). Resolved/decided
   entries → `done/`; ownership/deferral/context notes → `archive/`; each
   carries a `## ✅ RESOLUTION — <date>` section appended before the move.
3. **The ticket closes the same turn the work closes — at BOTH ends.** Finishing
   an entry's substance obligates the bookkeeping in the SAME pass: resolution
   section → file move → ledger updated (queue row removed, count fixed,
   Closed/Archived line added) → **the receipt returned** to the repo named in
   the entry's `from a <repo> session` line. That means: append
   `## ✅ RETURNED — <date>` to its `lobby/outbox/<slug>.md`, rewrite the
   `Last known` line, and name the **remainder** — what that repo still owes,
   or `none`. The field is never omitted. No stub there (filed before the
   receipt existed)? Write one, dated from the entry's `staged:` line.
   Work closed with the ticket left open is the breach this skill exists to
   prevent; work closed with the **filer never told** is the one it kept
   committing anyway — `agent-init-docs-index` closed in dotfiles on
   2026-08-01 with a remainder only kol-ds-ui can do, and kol-ds-ui has no
   record that it ever filed it.
   **And no entry without a row, no ticket without a receipt** — either one
   missing is drift the moment it lands.
4. **The agent closes on evidence; everything else is the USER's call.**
   *Narrowed 2026-08-01.* It read "open / closed / stale / parked is the USER's
   call", and that literal reading produced a queue of **four rows with zero
   outstanding agent work** — the rule written to stop the agent declaring
   victory stopped it filing anything.
   - **The agent MUST close** a ticket whose asked-for thing exists and is
     verified, citing the proof its repo requires. Leaving finished work in the
     queue is drift, same class as an orphan file.
   - **Only the user may** park, declare stale, reopen, or settle a design
     decision. A `parked` row means parked — it is not an invitation.
   - The agent never promotes an entry to "open issue" and never invents a row.
5. **A lobby is a portal, not a tracker.** *"its just a build and info portal"* —
   an intake for a brief and the place its outcome is recorded, **not** a list of
   open work. `live` means outstanding **agent** work, never *unconfirmed*.
   **A remaining DECISION is not a lobby item:** the ticket closes and the choice
   moves to the repo's focus file (`AGENT-CONTEXT.md` § awaiting rulings). No item
   lives in both places.
6. **The lobby is a work queue, not docs.** It sits outside `docs/`
   deliberately and does not follow the docs-framework conventions. Don't
   frontmatter-police it; match each lobby's own INDEX format.

## /lobby-hygiene — the audit-and-square pass

1. Read the ledger — `lobby/INDEX.md`, **or `lobby/LEDGER.md`** (humpty uses that
   name; check both). Stop if no lobby — say so, one line.
2. Diff ledger vs reality, both directions:
   - **FINISHED ROWS IN A LIVE TABLE — drift, and the first thing to look for.**
     A queue row whose work is verifiably shipped (cite version/file/log), or
     whose entry already carries a completed resolution, or whose only remainder
     is a **user decision** → **close it and file it**, same pass. Move the
     decision to the focus file. This is law 4, not a judgement call, and it is
     the check the 2026-08-01 brief exists to add.
   - a receipt at 🟢 with `Remainder here: none` still printed in the live
     table → same thing: it is history, move it out;
   - files in `lobby/inbox/` with no queue row, or rows pointing at moved/
     missing files → ledger drift, repair the ledger. (A lobby that predates
     the `inbox/` split may still have loose `.md` at the root — same check.)
   - entries in `done/`/`archive/` missing resolution sections → note them;
   - entries past the **ageing threshold** — 30–90 days since `staged:` is
     ageing, >90 is a stale candidate. Surface with dates. **Never move one:**
     stale is the user's call (law 4).
     **Read the date from `**Staged:**` or the frontmatter `staged:`; fall back
     to the legacy `date:` alias and say you did.** Neither → date from file
     mtime and note that in the entry. The rule read `staged:` while `/lobby-ds`
     emitted `date:`, so this pass silently found nothing in 113 files.
     **Only live entries age — 🔵 🟡 🟠 in `inbox/`.** 🟢 `closed` and ⚫
     `retired` are finished and never appear in this list; surfacing a retired
     brief as stale reopens a question its own row already answered with a
     reason. ⚪ `parked` gets its own heading with its date — the ask still
     stands, but a parked row is not an invitation (law 4).
3. **Audit `outbox/` too — the receipts, both directions:**
   - a stub at 🔵 whose destination ledger says 🟢 → **re-sync it** (the
     destination ledger wins; a receipt is a dated copy, never a second truth);
   - a `done/` entry here whose filing repo has **no stub at all** → write the
     receipt now, dated from the entry's `staged:` line, straight to
     `## ✅ RETURNED`;
   - a returned stub whose `Remainder here:` field is **missing or empty** →
     that is not `none`, it is unanswered. Surface it.
   The re-sync half is mechanical and needs no ruling. Naming a **remainder**
   is a judgment call and goes to the user like any other.
4. Execute only what law 2–3 already authorize (user-ruled resolutions, receipt
   re-syncs); everything judgment-shaped goes to the user as a table: entry ·
   ledger status · evidence · proposed move.
5. Report: queue count before → after, receipts re-synced, moves made, calls
   left to the user.

## The state vocabulary

🔵 `filed` · 🟡 `read` · 🟠 `addressed` · 🟢 `closed` · ⚪ `parked`, plus two
orthogonal **flags**: 🔴 `needs-ruling` (blocked on the user) and 📌
`remainder` (closed *there*, still owed *here* — `outbox/` only). `read` and
`addressed` are never `closed`. humpty keeps its own words (`researched`,
`verified`, `retired`) under the same emoji, and its bar for 🟢 is a
**measurement** — the estate's strictest. Each lobby's ledger states its own
bar; read it there, not here.

Full protocol: `~/.dotfiles/docs/operations/systems/lobby/02-lifecycle.md`.

## Report shape

One table (entry · status per the LEDGER · action), one footer line. Never
the words "open issue" for anything the user hasn't called open.
