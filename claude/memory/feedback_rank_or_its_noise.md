---
name: feedback_rank_or_its_noise
description: "Structure is not hierarchy — rank every reply by consequence, most important first, or the whole thing reads as flat noise"
metadata:
  type: feedback
---

A reply must carry **hierarchy**, not just structure. Tables and checkboxes organise facts; they do
not rank them. If every row is a peer, the user has to do the ranking the reply owed him.

- **Most important row FIRST** — never chronological, never the order the work happened in. He stops reading early; the top row must be the one worth stopping on.
- **Bold the one row that changes his next action.** If no row qualifies, it is reference, not findings.
- **Rate highlighted paths `[n/5]`** — 5/5 = read this first. This was already his standing rule and dropping it is what produced the complaint.
- **Findings order worst-first**, severity visible in the row.
- **Rank by consequence to him, never by effort.** How hard something was to build is not how much it matters.
- **Always show the proposed action** — never end a reply that leaves him asking what the point of it was.

A genuinely flat reply is allowed, but say so in the lead. A fabricated hierarchy is worse than an
honest flat one.

**Why:** 2026-08-01 — on `/output`, asked what a finished build report should look like, he answered:
*"the importance leveel or the hierarcy is unclear, everything looks the same, nothing is highlighted,
no value or rating system on importance, so everything is noise"* and *"always jshow the action
proposed, never leave the user confused so he has to ask what the point is of the mmessage."* It was
correcting a four-repo build report whose seven-row table listed a protocol change, a new flag and a
tooling tweak at identical weight.

**How to apply:** before sending, ask *which single row here changes what he does next?* — put it
first and bold it. If the answer is "none", the table is reference and the lead says so. Then check
the reply names its proposed action explicitly. Sibling rules: [[feedback_lead_first]],
[[feedback_audits_are_tables]], [[feedback_two_subjects_two_sections]],
[[feedback_footer_fold_bar_too_high]].
