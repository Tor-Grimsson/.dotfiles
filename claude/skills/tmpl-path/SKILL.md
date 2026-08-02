---
name: tmpl-path
description: Every concern arrives with its resolution — research prior art first (training knowledge + the web + this repo), name the established convention, define what done looks like, then the steps to it. Bans the cryptic unresolved "concern" the user has to interrogate. Triggered by /tmpl-path (user-invoked only).
---

# tmpl-path — a concern without a path is homework handed back

The failure this exists to stop: the agent lists "concerns", each too cryptic to act on, none resolved — so the user has to interrogate every line, then supply the technical judgement himself. That inverts the job. Deciding the best-practice answer is the agent's work, not his.

## The contract

Before anything is called a concern, it gets resolved. **A concern you cannot resolve is not a concern — it is a question, and it gets asked as one, in one line, with the thing that would decide it.**

| step | what it means |
|---|---|
| **1 · prior art first** | This has been solved. Check training knowledge, **search the web**, and grep this repo for the existing pattern. Never reinvent a solved thing. |
| **2 · name the convention** | State the established answer by name, and who uses it. "This is how X does it" is the currency — not "there are trade-offs". |
| **3 · define done** | One line: what success looks like. If you cannot state it, you do not have a plan. |
| **4 · the path** | The steps to that done, in order. Concrete files, concrete values. |
| **5 · one plan** | Not a menu. Pick the best long-term-viable answer and propose it. |

## Banned

- **Cryptic concern lines.** If it needs a follow-up question from him to become actionable, it is not finished. Write it finished.
- **"Depends on your convention."** He does not have one — that is why he asked. Figure out the best one and say it.
- **A trade-off survey in place of a recommendation.** Trade-offs are the reasoning; a recommendation is the deliverable.
- **Reinvention.** Basic solved problems (naming, layout geometry, doc structure, file conventions) have public, tried-and-tested answers. Waste of mental energy with no gain.
- **Deferring success criteria.** "We'll see how it looks" is not a definition of done.

## The web is part of the job

When the question is "what is the best system for this", the honest answer requires looking at what is actually used in the wild — not synthesizing one from first principles in the reply. Search, cite, recommend.

## Aging sources

Precedent inside the repo is evidence, not authority. An old file may be a fossil — check its age and whether its constraints still hold before citing it as the convention. Say so when you do.

## Family

`tmpl-path` (resolve it, then route it) · `tmpl-present` (present the route, then STOP) · `tmpl-ask` (state ask · blocker · need) · `dump` (verdict first, evidence second).
