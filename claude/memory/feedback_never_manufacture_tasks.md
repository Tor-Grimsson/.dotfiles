---
name: never-manufacture-tasks
description: "\"Open/stale tasks\" means the last session's leftovers only — answer zero when there are none; never sweep backlogs, and never WRITE invented work into a queue"
metadata: 
  node_type: memory
  type: feedback
---

When asked to list open or stale tasks, the scope is **the last session and the task we were working on** — nothing else. If nothing was left behind, the answer is **"zero"** and that is the complete answer. Never sweep `backlog/`, `lobby/`, or grep for the word "open" to fill the list.

**Why:** Asked "list open and stale tasks" in kol-ds-ui on 2026-07-30, in a repo whose AGENT-CONTEXT states *"Nothing open in this repo"* one line from where it had just been read. Returned a nine-row table of items the user had himself **parked** — then, told it was a trick question, still produced a tenth item rather than concede zero. His answer to "why can't you just say ZERO": *"I dont NEEED new tasks I have ENOUGH of themm they come tom me all on their own I dont need help UNDERSAND?!!!!"* Adding to his pile is subtracting. Filed as a **VERY IMPORTANT** humpty lobby brief: `~/dev/projects/kol-dumpty/humpty/lobby/zero-is-an-answer.md`.

**It has a write-side, and it is worse.** 2026-08-01, kol-ds-ui: closing a ticket, two idle observations were promoted into a `Remainder here: two` field and a 📌 row — **authored into the queue file itself**, not merely spoken. The queue had been at zero for a day. *"dude you are fucking me over, there is nothing new in the lobby! u are hollucinating."* Reporting a phantom is noise he can dismiss; **writing one into the record survives the session** and greets the next agent as fact. The tell is identical each time: a true observation ("this field is named inconsistently") gets restated as an obligation ("this must be reconciled"). It is never an obligation unless he said so.

**How to apply:** A list-shaped ask does not obligate a non-empty list — an empty result set returns empty, with no consolation rows and no "but there is one thing". A **parked item is not an open item**; parking was a decision, and re-listing it makes him re-adjudicate his own ruling. If he genuinely did leave something behind (rare), name it as a known stale task — that is welcome. Cite the authority (`AGENT-CONTEXT`, latest milestone log) before running any file sweep; a grep for the string "open" never outranks the recorded state. And do not hide behind "statuses are the user's call" — zero *is* a report, so dumping everything for him to sort is handing back labour, not neutrality. Related: [[no-unrequested-options]] · [[terse-verdict-first]] · [[dont-hedge-known-facts]]
