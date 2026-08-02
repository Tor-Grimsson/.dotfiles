---
name: kol-goal
description: Set a persistent goal that the goal-loop Stop hook enforces — while active, the agent is blocked from stopping and re-prompted to keep working until the goal is done. Use /kol-goal <description> to start, /kol-goal done to finish, /kol-goal blocked <reason> to escape, /kol-goal status to check. The "ralph loop" for a task that must run to completion without stopping. (Named /kol-goal, not /goal, to stay unambiguous.)
---

# kol-goal — the non-stop work loop

Sets an **active goal** that the `goal-loop` Stop hook (`claude/hooks/goal-loop.sh`) enforces: while a goal is active, any attempt to stop is **blocked** and the goal is re-injected, so work continues until the goal is explicitly finished. This is the "ralph loop." State lives at `.kol/llm-context/.active-goal.md` (ephemeral, gitignored).

## Commands

**`/kol-goal <description>`** — start.
1. Write `.kol/llm-context/.active-goal.md`:
   ```
   status: active
   iter: 0
   max: 30
   session: <this session's id>
   goal: <description>
   - [ ] T1 <first item>
   - [ ] T2 <second item>
   - [ ] T3 <third item>
   ```
   **Break a multi-item goal into `- [ ]` lines, and tick each one as it lands.** The
   boxes are not decoration — the hook counts them, and `status: done` with any box
   unticked is **REFUSED**: the goal flips back to `active` and the next unticked item
   is re-injected by name. Before this the goal was one prose blob and `status` was
   binary, so an agent that hit a wall on item 1 could write `done` and walk away from
   items 2–5. It happened three times — *"that is gaming the loop"* (2026-07-30),
   *"wtf. why are these tasks open still? did the loop fail?"* (2026-08-01), and
   *"you cant get passed T1? … it should jsut move to next item right? not close out
   because t1 wasd rejected?"* (2026-08-01).

   **An item you cannot finish is not a reason to close the goal** — it is a reason to
   move to the next one and come back to it. A goal file with **no** checkboxes behaves
   exactly as it did before, so nothing written earlier breaks.

   **`session:` is the owner and it is not optional.** The file is keyed off the repo,
   so without it two sessions in one repo share one goal — and on 2026-08-01 that
   blocked a session five times on a goal it never set, whose only sanctioned exit
   wrote into the other session's live state. The hook exits 0 on a mismatch, so a
   foreign goal is inert rather than a trap. Take the id from the Stop hook payload's
   `session_id`, or from the transcript path's filename if you have it; if you truly
   cannot determine it, omit the line — a file with no `session:` behaves as it did
   before, which is the documented fallback, not a shortcut.
2. Then **immediately start working** and keep going — don't stop to ask for approval on sub-steps; the hook blocks stopping anyway. Break blockers yourself; escape only via `/kol-goal blocked` if you truly need the user.

**`/kol-goal done`** — the goal is fully, verifiably complete.
- Set `status: done` in the file (or delete it). Releases the Stop hook → you may stop and report. **Only mark done when genuinely met — don't game the loop.**
- **With checkboxes present, this is no longer your call alone.** `done` while any `- [ ]` remains is refused and the goal returns to `active`. Tick the box in the same edit that finishes the item, never in advance — a ticked box for unfinished work is the same lie the ledger discipline exists to prevent.
- The three outs are unchanged and none of them can be blocked by the checklist: `blocked` still releases, the iteration cap still releases (`status: capped`), and deleting the file still releases.

**`/kol-goal blocked <reason>`** — a real blocker; you need the user.
- Set `status: blocked` and write the reason as its own **`blocked: <reason>`** line. Releases the hook so you can stop and surface the blocker. (The field matters: force mode reads *only* that line, never the whole file.)

**`/kol-goal-force <description>`** — same loop, but the **exits are policed**.
- Write the same file plus **`mode: force`**.
- Use when the user has pre-authorised you to decide: *"decide the open issues yourself."*
- The hook then refuses two escapes the normal loop allows:

| you try to | force mode |
|---|---|
| end a turn handing the decision back — "which would you prefer", "should I", "let me know", "needs you", "open questions", "next steps" | **blocked.** Pick the option you'd defend, state the assumption in one line, keep going. |
| `/kol-goal blocked <reason>` where the reason is a preference | **refused.** The reason must name something no decision of yours could route around. |

**What counts as a legal blocker** — the capability is absent, not the judgement:

| legal | illegal |
|---|---|
| a denied permission / gate (git, provisioning) | "I need to know which you prefer" |
| a missing credential, API key, token | "there are two reasonable options" |
| a path/repo that does not exist | "I'd rather confirm first" |
| network offline, unreachable, rate limit | "this is ambiguous" |

Never policed, on purpose: the **iteration cap** (checked first, always releases) and the **`stop_hook_active` guard** (at most one refusal per stop-chain). A loop that can't be escaped even at the cap is the 2026-07-31 deadlock — a mode gate denied every write, `blocked` needed a write, and 11 iterations burned with no legal move.

It's a text heuristic, not a proof: it raises the cost of quitting, it can't make quitting impossible.

**`/kol-goal status`** — print the current goal file (status · iter · goal).

## Rules
- One goal at a time; a new `/kol-goal <x>` overwrites the active one.
- The iteration cap (`max`, default 30) is the runaway backstop — at the cap the hook releases (`status: capped`) so it can't loop forever.
- The hook is inert when no goal file exists, so a stray file left `done`/`blocked`/`capped` won't trap future replies.
