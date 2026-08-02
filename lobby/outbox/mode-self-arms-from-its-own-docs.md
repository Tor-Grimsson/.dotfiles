# Mode gates arm from their own documentation, and only clear on a user prompt

**Filed:** 2026-07-31 → **humpty**
**Entry:** `~/dev/projects/kol-dumpty/humpty/lobby/archive/mode-self-arms-from-its-own-docs.md`
**Ledger:** `~/dev/projects/kol-dumpty/humpty/lobby/LEDGER.md` — **the truth about this ticket**
**Last known:** 🟢 `verified` 2026-07-31 · superseded by a removal 2026-08-01 · synced 2026-08-01

## Why it went there

The defect was in humpty's own hook code — `hooks/humpty_track.py:30-32`, three signal
regexes that matched the harness's injected **skills catalog** rather than a user's
typed command. Found from a dotfiles session because that session had just renamed four
skills and created four more, which is what re-emits the catalog and re-armed the gate.

The catalog lines that armed it are dotfiles' own text (`- jana: … Triggered by /jana
(user-invoked only).`), but nothing in dotfiles could fix a humpty regex.

## What stays here

The three mode skills themselves live in this repo — `claude/skills/jana`, `rosa`,
`yona`. Whatever humpty decides about *enforcing* them, their SKILL.md text is dotfiles'
to keep true.

---

## ✅ RETURNED — 2026-08-01

🟢 `verified` in **humpty**, 2026-07-31 — all six DoD items met: signals anchored to
authorship (start · own-line · final-token), catalog-shaped text vetoed, two signals arm
neither, a 60-call tool budget as second backstop, and `.active-goal.md` made undeniable
so the loop always has an exit. Their bar is a measurement, and it was met: fixtures
**117 → 129**, the literal catalog arms nothing. Result file:
`docs/documentation/06-measure/_results/2026-07-31-mode-self-arming-fixed.md`.

**Then, 2026-08-01 — the gate was removed entirely.** `humpty_mode.py` quarantined, the
`PreToolUse *` registration gone; `/jana`, `/rosa` and `/yona` are plain skills again, on
the user's ruling: *"you took something sooo simple and useful and made it work against
me."* humpty recorded this as fact and **changed no state on the row** — that call is the
user's. So this ticket is closed twice over: fixed, then made moot.

**Remainder here:** 📌 **one sentence in this repo is now false.**
`claude/skills/yona/SKILL.md:23` reads *"The gate enforces this; a denied tool is the
mode working."* There is no gate as of 2026-08-01 — `/yona` is honoured by the agent
reading the skill, not by a hook denying the tool. `jana/SKILL.md` and `rosa/SKILL.md`
make no enforcement claim and need nothing.

**Not fixed here, deliberately.** Rewriting a skill's own description of how it binds is
a doctrine call, not bookkeeping — and humpty's ledger already refuses to change a row
on its own. Surfaced, not actioned.

*(Receipt written 2026-08-01, backdated from the entry — it predates the receipt
convention. This is the ticket that proves the convention was needed: it closed in
humpty on 2026-07-31, was superseded there on 2026-08-01, and dotfiles had no record of
either event until this file existed.)*
