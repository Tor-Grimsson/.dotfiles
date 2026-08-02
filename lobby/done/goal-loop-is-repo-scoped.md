# The goal-loop traps a session that never set a goal

**Staged:** 2026-08-01 · from a kol-ds-ui session, re-homed from `kol-dumpty/humpty/lobby/`
**Change:** small — one field in the goal file, one comparison in the hook
**Why here:** the code is `claude/hooks/goal-loop.sh` and `claude/skills/kol-goal/SKILL.md`.
Both are dotfiles'. humpty's lobby is agent *behaviour*; this is a hook this repo owns.

---

## What the user said

> dude I just said /log-work nothing else

> what can bypass hooks? is there a way to command bypass hooks in specific instances?

Earlier in the same session, on the concurrent agent:

> there is another agent working on the lobby, thats the blocer, hes done, scan again and confirm

## What the agent did

Completed `/log-work` — the entire ask — and then could not end the turn. The `goal-loop` Stop
hook fired **five times** on a goal file authored by a **different** session:

```
GOAL: Empty the lobby queue. Sole agent in the repo (user confirmed 2026-08-01,
the rail arc is closed by the other session).
```

That goal was written at 11:49 by the other agent. This session had set its own goal earlier,
marked it `done`, and had nothing of its own outstanding.

## The root cause

The hook keyed the goal file off `cwd`:

```python
gf = os.path.join(cwd, ".kol", "llm-context", ".active-goal.md")
```

`cwd` is the repo. **Two sessions in one repo shared one goal.** No session identity existed
anywhere in the file or the hook. Every documented escape (`done` · `blocked` · delete · the
iteration cap) is repo-global, and `KOL_HEADLESS=1` is a wrapper flag for `claude -p`, not a
per-instance bypass. The exit the agent finally took **wrote into another session's live state.**

## What shipped — 2026-08-01

| Where | Change |
|---|---|
| `claude/hooks/goal-loop.sh` | reads `session:` from the goal file; **exits 0 when it is present and does not match this payload's `session_id`** — a foreign goal is inert, not a trap |
| `claude/skills/kol-goal/SKILL.md` | `/kol-goal <x>` writes `session: <id>` on create, with the reason stated so it is not dropped as boilerplate |
| backward compatibility | a file with **no** `session:` line behaves exactly as before |

Placed **after** `status`/`force` are read and **before** any blocking branch, so a foreign
goal cannot reach force mode's exit-policing either.

## Verified, all three directions

| Payload | Goal file | Result |
|---|---|---|
| `session_id: OWNER-AAA` | `session: OWNER-AAA` | **blocked** — the loop still works for its owner |
| `session_id: BBB` | `session: OWNER-AAA` | **exit 0, silent** — the stranger is released |
| `session_id: ANYBODY` | no `session:` line | **blocked** — legacy files unchanged |

## Rejected

**A `/kol-goal bypass` or a one-turn env flag.** It hands the agent a switch for the exact hook
that exists to stop it quitting. The problem was never that the loop is too strong — it is that
it fired on a goal this session never set. **Ownership, not strength.**

**Deleting the foreign goal file.** It kills the other session's loop, and status is the user's
call.

## Still open

- [ ] **No fixture.** This repo has no hook fixture suite; the three cases above were verified by
      hand against a scratch repo. humpty's `hooks/fixtures.sh` is the pattern if one is wanted.
- [ ] **The `session:` line depends on the agent writing it.** The skill instructs it; nothing
      enforces it. A goal written without the field silently keeps the old repo-wide behaviour.

---

## ✅ RESOLUTION — 2026-08-01

Closed on the user's ruling — *"status is then closed"* — which is this repo's stated
bar for 🟢.

**What met it:** `claude/hooks/goal-loop.sh` now reads `session:` from the goal file and
**exits 0 when it is present and does not match the payload's `session_id`**, placed after
`status`/`force` are read and before any blocking branch, so a foreign goal cannot reach
force mode's exit-policing either. `claude/skills/kol-goal/SKILL.md` writes the field on
create. Verified by hand in all three directions, as the table above records: owner blocked ·
stranger exits 0 · a file with no `session:` line behaves exactly as before.

**The ruling underneath it was ownership, not strength.** A bypass switch was rejected
because it hands the agent a lever on the one hook that exists to stop it quitting — the
loop was never too strong, it fired on a goal this session never set.

**Re-homed, not re-filed.** It arrived from `kol-dumpty/humpty/lobby/` the same day: a Stop
hook trapping the agent reads as agent behaviour, but both files that had to change are this
repo's. The humpty copy stays in its `archive/` on purpose — deleting it would erase where
the brief was found.

**Receipt returned** to `kol-ds-ui/lobby/outbox/goal-loop-is-repo-scoped.md`, remainder
`none`. The two boxes under *Still open* stay open by design and belong to this repo, not to
the filer.

*(Section written 2026-08-01 while closing `lobby-spec-two-gaps`, which flagged its absence.
The outcome had lived only in the ledger row — law 2 requires it here, and an entry that
lands in `done/` bare is indistinguishable from one that was quietly deleted.)*
