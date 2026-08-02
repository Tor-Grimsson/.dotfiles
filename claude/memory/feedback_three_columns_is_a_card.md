---
name: feedback_three_columns_is_a_card
description: Count the columns before rendering parallel facts — 3+ columns, a wrapping cell, or >5 rows means the T-card stack from format module 07, never a markdown table
metadata:
  type: feedback
---

Before rendering any block of parallel facts, **count the columns**. A markdown table is
only legal at **2 columns with every cell on one line**. Otherwise it renders as the
T-card stack — `T1 🔺 title`, ≤2 indented detail lines of ≤10 words, a ~40-cell `─` rule
closing every card, **two blank lines on both sides of every rule**, a rule opening the
stack above `T1`. Spec: `kol-dumpty/humpty/docs/documentation/08-formats/07-the-card.md`
(v1.3.0) — **read it, do not reconstruct it from memory.**

| Render as | When |
|---|---|
| markdown table | 2 columns, every cell fits one line |
| **T-card stack** | **3+ columns**, any wrapping cell, or more than 5 rows |
| box table | `$humpty box` is on — that dialect wins |

**This is also the listing format in PLANS**, not just replies (module 07 v1.4.0, his
ruling 2026-08-01: *"ok nice, this should always be the listing of tasks and statuses in
plans"*). Any document that enumerates work — a plan, a backlog, an audit inventory, a
handoff's open items — lists tasks and statuses as cards. Two differences there: the handle
**persists across sessions**, so never renumber when an item closes (strike it or mark it
done in place), and a plan may carry more than one 🔺.

The T-number is the point: he can say *"do T2"* without retyping the task. Rank highest
first, so T1 is both first and most important. Marks are `🔺` high · `🔸` med · `▫` low —
**never the lobby circles** (🔵🟡🟠🟢⚪🔴), which are too visually heavy and already mean
*state* in the ledger system.

**Why:** 2026-08-01 — a `/lobby-list` report went out as a 4-column outbox table and a
wrapping 2-column drift table. He replied: *"is terrible, lobby has N many items , why the
fuck make this layout instead of the numbered cards T1 T2 T3 etc"*. The module had been
written **that same day** off an identical failure (*"terrible output, worst one yet"*) and
its trigger is deterministic — this was not a judgement call I got wrong, it was a spec I
did not check. This terminal does not render a 3-column table as a table: it flattens it to
stacked `label: value` lines with no blank line between rows, and a long cell bleeds into
the next one.

**How to apply:** when a reply enumerates items — lobby entries, receipts, findings, files,
versions — count the columns of the block you are about to write. Three or more, or any
cell you would not want wrapped: build cards instead. Do this *before* writing the block,
not as a cleanup pass. Related: [[feedback_audits_are_tables]] (the enumeration must be
structured at all), [[feedback_message_format_drift]] (the shape erodes late in long
sessions), [[feedback_rank_or_its_noise]] (highest first), [[docs-lookup-first]].
