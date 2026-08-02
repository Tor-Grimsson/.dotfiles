# Two gaps in the lobby spec — ⚪ means two things, and `staged:` exists nowhere

**Staged:** 2026-08-01 · **Filed from:** a kol-ds-ui session
**Affects:** `docs/operations/systems/lobby/02-lifecycle.md` · `04-conventions.md`

Found while squaring kol-ds-ui's lobby and auditing all four ledgers. Both are
spec-level: neither can be fixed inside a consumer repo, because both are about
what the shared protocol says.

---

## Gap 1 — ⚪ carries two opposite meanings

| Where | ⚪ means | Finality |
|---|---|---|
| `02-lifecycle.md:33` (the ladder) | `parked` — *"deliberately not-now, reason recorded"* | **revisitable.** A not-yet |
| `humpty/lobby/LEDGER.md` (5 rows) | `retired` — *"closed without a fix, with the number written down"* | **terminal.** An answer |

humpty's own ledger states the distinction it needs and the spec does not carry:

> *"Retired is not 'we gave up'. It is the ledger's second honest ending: closed
> without a fix, with the number written down."*

Those are different endings wearing one glyph. A reader sweeping four ledgers
cannot tell a deferred ticket from a settled one, and `/lobby-hygiene`'s ageing
pass would surface a **retired** entry as a stale candidate — which is exactly
wrong, because retired is the opposite of stale: it is finished.

`01-registry.md:53` says humpty's dialect is *"absorbed rather than
overwritten"*, and its `verified` bar is indeed documented in the per-repo table.
`retired` was not given the same treatment — it is absorbed in practice and
absent from the spec.

**What done looks like:** either a sixth state in the ladder with its own glyph,
or a per-repo terminal-state row beside the `bar for 🟢` table. Both are the
user's call; the defect is that the ladder currently claims a meaning humpty
contradicts.

---

## Gap 2 — the staleness rule reads a field no entry carries

`02-lifecycle.md` § Staleness:

> *"Every entry carries a **`staged:`** date in its header and a **Staged** column
> in the ledger. Without it 'stale' is a word nobody can act on."*

And `/lobby-hygiene` lists *"entries past the ageing threshold → surface with
dates"* as an audit output.

**Measured in kol-ds-ui 2026-08-01, before this session's backfill: `staged:`
appeared in 0 of 113 entry files.** They carried `date:` instead — the field the
`/lobby-ds` writer skill actually emits. The ledger's Queue table has its Staged
column, so the *rows* were fine and the *files* were not, which is why nothing
ever noticed: the drift is invisible from the ledger, and the ledger is what law
1 says to read.

So the ageing pass has never been able to run mechanically on the largest lobby
in the estate. Not a missed threshold — a field lookup that returns nothing.

**Already done here, so this ticket is only the spec half:** all 116 kol-ds-ui
entries were backfilled with `staged:` this session, derived from each entry's own
`date:` (7 pre-frontmatter files got frontmatter, two of them dated from mtime
because their bodies carried no date — noted in the entries).

**What done looks like:** the writer skills emit `staged:` (not `date:`), or the
spec names `date:` as an accepted alias and `/lobby-hygiene` reads either. One
line in `04-conventions.md` § entry shape settles which.

---

## Also noticed, not a gap in the spec

`~/.dotfiles/lobby/done/goal-loop-is-repo-scoped.md` has **no `## ✅ RESOLUTION`
section** — its outcome lives only in the LEDGER row. `02-lifecycle.md:104`
(law 2) requires the section before the move to `done/`. One file, mechanical.

## Not in scope

Nothing about the receipt/`outbox` half — that half works. It was added
2026-08-01 and this session used it end to end across three tickets in two
repos without hitting a rough edge.

---

## ✅ RESOLUTION — 2026-08-01

Both gaps closed. User instruction: *"close stale rule, do #1 … then close lobby
items"* — this repo's bar for 🟢 is his confirmation, and that is it.

### Gap 1 — ⚫ `retired` is now the sixth state

Ruled the **first** shape the entry offered: a state of its own, not a per-repo
terminal-state row. A per-repo row would have *documented* the collision and left
⚪ meaning two things in the shared ladder, which is the defect itself.

The test that decided it: `researched` and `verified` are humpty **renaming rungs
the ladder already had** — safe, because the glyph still means one thing.
`retired` renames nothing. It is a second ending, and folding it onto `parked`
made one glyph mean *revisitable* and *terminal* at once. That reasoning is now
written into `01-registry.md` § Sibling ledgers as a general rule: a dialect word
with **no rung to map onto** is a gap in the standard, not local flavour.

| file | what changed |
|---|---|
| `02-lifecycle.md` | ⚫ added to the ladder; ⚪ marked *revisitable*, ⚫ *terminal*; a **`parked` is not `retired`** section quoting humpty's own line back at the spec |
| `04-conventions.md` | `archive/` now documented as holding **two** judgements, with what each row owes — ⚫ owes the reason and, where it exists, **the number** |
| `05-lookup.md` · `INDEX.md` | state table + both tree diagrams |
| `01-registry.md` | the absorption lesson above |
| humpty `LEDGER.md` | States row + **5 rows migrated ⚪ → ⚫**, plus 2 History prose glyphs and a History line |
| the 3 other ledgers | ⚫ row added — the States table is repeated in each lobby on purpose |

**No state was reclassified** (law 3). Every migrated row already read `retired`
in its own State column; only the glyph moved. Verified: 6 ⚫ in humpty, 0 ⚪
data rows left anywhere.

### Gap 2 — `staged:` is the field, `date:` is a read-only alias

Settled where the entry said it should be — `04-conventions.md` § entry shape,
now a subsection **The staged date** with a three-row table: `**Staged:**` in a
plain header block, `staged:` in frontmatter (the `/lobby-ds` carve-out), and
`date:` **accepted when reading, never emitted**.

The cause was inside one file. `lobby-ds/SKILL.md` step 3 said *"with a
`**Staged:** YYYY-MM-DD` line"* while the template three lines below it emitted
`date:` — and the template is what gets copied. `/lobby-dotfiles`,
`/lobby-humpty` and `/lobby-web` were correct all along, which is why this only
ever bit the DS lobby.

| file | what changed |
|---|---|
| `lobby-ds/SKILL.md` | template emits `staged:`, with the reason in a comment; step 3 rewritten to point at the spec and name the frontmatter exception |
| `lobby-hygiene/SKILL.md` | reads `**Staged:**` / `staged:` / legacy `date:` and says which; mtime fallback; **terminal states never age** |
| `02-lifecycle.md` § Staleness | the measured failure recorded (0 of 113), plus a table of **which states age** |

**Only live entries age** — 🔵 🟡 🟠. 🟢 and ⚫ never do: *retired is the opposite
of stale, not a species of it.* ⚪ `parked` is surfaced under its own heading with
its date and nothing else, because the ask still stands but a parked row is not
an invitation (law 3).

### The side item

`done/goal-loop-is-repo-scoped.md` had no `## ✅ RESOLUTION` — written from its
ledger row and the receipt already returned to kol-ds-ui. Fixed.

### Noticed, not fixed

`lobby-ds/SKILL.md` still emits `status: draft` (`draft → recreated → promoted`)
while kol-ds-ui's 2026-08-01 backfill squared `status:` to the **folder**
(`filed` / `closed` / `parked`) across 106 entries. Same shape of defect as gap 2
— the writer emits a vocabulary the protocol doesn't read — but it is a third
gap, not one this ticket was filed for. Left for a ruling.
