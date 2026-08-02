# lobby — dotfiles

Intake queue for **dotfiles**: tooling, scripts, configs, the ref cards.
Not documentation — a work queue, deliberately outside `docs/`.

**This file is the ledger. The ledger is the truth, never a raw `ls`.**

| | |
|---|---|
| file one | `clip-drop.sh --dotfiles NAME` · `/lobby-dotfiles` (from any repo) |
| read it | `/lobby-list` · `bin/lobby` · `prefix Ctrl+K` |
| the spec | `docs/operations/systems/lobby/` |

## States

| | state | means | lives in |
|---|---|---|---|
| 🔵 | `filed` | captured, unread | `inbox/` |
| 🟡 | `read` | understood — the row below restates it | `inbox/` |
| 🟠 | `addressed` | a change shipped that is *meant* to close it | `inbox/` |
| 🟢 | `closed` | met the bar; resolution appended | `done/` |
| ⚪ | `parked` | deliberately not-**now**, reason recorded — revisitable | `archive/` |
| ⚫ | `retired` | closed without a fix, not-**ever** — terminal, and never ages | `archive/` |
| 🔴 | `needs-ruling` | **flag, not a state** — blocked on the user's call | wherever it is |
| 📌 | `remainder` | **flag, not a state** — closed at its destination, still owed **here** | `outbox/` |

**`read` is never `closed`.** Understanding a ticket ships nothing.
**Bar for 🟢 closed in this repo — purpose served:** the change shipped and was verified
by running it, cited by file. *(Was "the user confirms it" until 2026-08-01; read
literally it held finished work in the queue — `docs/operations/systems/lobby/02-lifecycle.md`
§ The bar for 🟢 closed.)* **The agent closes on that evidence.** Parking, declaring
stale, reopening and any design decision stay the **user's call** — and a remaining
decision is not a lobby row at all: the ticket closes, the choice moves to the focus file.

## Queue — 1 entry

| | Entry | About | Staged | State |
|---|---|---|---|---|
| 🔵 | [llm-rules-bulletin-in-scaffold](inbox/llm-rules-bulletin-in-scaffold.md) | the scaffolded `LLM_RULES.md` template has **no BULLETIN section**, so kol-website — the one repo symlinked to it — structurally cannot receive a cross-repo announcement, while kol-ds-ui's *local* copy has one and uses it for exactly this (`kol-theme@0.12.0` colorless links). Trigger: theme **0.24.0** deleted `.text-body` / `--kol-fg-body` with no fallback. Also asks that **kol-ds-ui be moved onto the symlink** — 3 of 4 repos hold a regular file, and the per-repo content (its bulletin entries, its `.kol/` startup protocol) needs somewhere to live first | 2026-08-01 | `filed` — from a kol-ds-ui session |

## Closed

| | Entry | About | Staged | Closed | State |
|---|---|---|---|---|---|
| 🟢 | [lobby-spec-two-gaps](done/lobby-spec-two-gaps.md) | two spec-level defects in the lobby protocol: **⚪ meant `parked` in `02-lifecycle.md` but `retired` in humpty's LEDGER** — same glyph, one revisitable and one terminal, so `/lobby-hygiene` would surface a *finished* ticket as stale; and **the staleness rule read `staged:`, a field that appeared in 0 of 113 kol-ds-ui entries** (they carried `date:`, which is what `/lobby-ds` emitted), so the ageing pass had never been able to run on the largest lobby | 2026-08-01 | 2026-08-01 | `closed` — ⚫ `retired` is the sixth state (5 humpty rows migrated); `staged:` settled in `04-conventions.md` with `date:` a read-only alias, and both writer skills fixed |
| 🟢 | [agent-init-docs-index](done/agent-init-docs-index.md) | point `/ag-init` + `/agent-init` at `docs/documentation/INDEX.md` so an agent boots knowing the repo's **laws**, not just its history — two files, one sentence each | 2026-07-31 | 2026-08-01 | `closed` — step 3 + step 8 applied to both skills |
| 🟢 | [g-nav-dead-targets](done/g-nav-dead-targets.md) | `gapparat` · `gclient` · most of `gdev` point at `kol-apparat/` and `kol-client/`, which no longer exist — **26 of 27 targets dead**. Repoint or retire | 2026-07-31 | 2026-08-01 | `closed` — deleted, superseded by tmux bookmarks |
| 🟢 | [goal-loop-is-repo-scoped](done/goal-loop-is-repo-scoped.md) | the `goal-loop` Stop hook keyed its goal file off `cwd`, so **two sessions in one repo shared one goal** — a session that had marked its own goal `done` was blocked **5×** by a goal another wrote 2 minutes earlier, and its only sanctioned exit wrote into that session's live state | 2026-08-01 | 2026-08-01 | `closed` — `session:` ownership in `goal-loop.sh` + `kol-goal/SKILL.md`; owner blocked · stranger exits 0 · legacy file unchanged |

## Archived

_(none yet — ownership, deferral and context notes land in `archive/`)_

## Filed elsewhere

Tickets this ledger does **not** govern — each row names the destination ledger that
does. The **Remainder** is this repo's to do; the state is theirs to report.

| | Receipt | Destination | Last known | Remainder here |
|---|---|---|---|---|
| 📌 | [mode-self-arms-from-its-own-docs](outbox/mode-self-arms-from-its-own-docs.md) | **humpty** — `~/dev/projects/kol-dumpty/humpty/lobby/LEDGER.md` | 🟢 `verified` 2026-07-31, then the gate **removed** 2026-08-01 · synced 2026-08-01 | `claude/skills/yona/SKILL.md:23` says *"The gate enforces this"* — there is no gate as of 2026-08-01. `jana` and `rosa` make no such claim |

## History

| Date | Event |
|---|---|
| 2026-08-01 | **`lobby-spec-two-gaps` filed from kol-ds-ui** — the second cross-repo brief in. Both gaps were found by auditing all four ledgers at once, which is the first time that has been done; neither is visible from inside a single lobby. Also noted in the entry: this repo's own `done/goal-loop-is-repo-scoped.md` carries no `## ✅ RESOLUTION` section, which law 2 requires |
| 2026-07-30 | lobby created by `clip-drop.sh`'s registry |
| 2026-07-31 | `agent-init-docs-index` filed from a kol-ds-ui session — the first real cross-repo brief into dotfiles |
| 2026-07-31 | restructured: entries moved to `inbox/`, this INDEX became the ledger, emoji states adopted |
| 2026-07-31 | `g-nav-dead-targets` filed — the first ticket written **through** the new system rather than into it |
| 2026-08-01 | both entries closed — **the first drain**. `g-nav` deleted outright (user's call, bookmarks supersede it); the `/ag-init` docs-index sentence applied to both skill files |
| 2026-08-01 | **`outbox/` created and `Filed elsewhere` added.** The receipt half of the protocol — a ticket filed from here into another repo now leaves a stub that its closer writes back to, and `/ag-init` reads at boot. Backfilled: **`mode-self-arms-from-its-own-docs`**, filed into humpty from a dotfiles session on 2026-07-31, verified there the same day, and then **superseded on 2026-08-01 when humpty removed the mode gate entirely** — neither event was recorded in this repo until now. It carries the first 📌 remainder in dotfiles: `yona/SKILL.md:23` claims a gate that no longer exists. Spec: `docs/operations/systems/lobby/02-lifecycle.md` § The return receipt |
| 2026-08-01 | **`llm-rules-bulletin-in-scaffold` filed from kol-ds-ui** — the third cross-repo brief in. Found while asking a plain question: *"we send a message about it through the symlink LLM_RULES.md? isnt that the path?"* The instinct was right about the mechanism and wrong about the reach — kol-ds-ui's BULLETIN is a **local** file, and the shared template kol-website symlinks has no such section, so the one repo wired to inherit an announcement is the one that cannot. Carries a second ask: **put kol-ds-ui on the symlink too**, which needs the per-repo-content question answered before it is a one-line change |
| 2026-08-01 | **`lobby-spec-two-gaps` closed — the protocol gained a state and lost a silent field mismatch.** ⚫ `retired` is now the ladder's sixth rung: humpty had run it for a year absorbed onto ⚪, the glyph the ladder had already given `parked`, so one symbol meant *revisitable* and *terminal* at once across four ledgers and the ageing pass would have surfaced a **finished** brief as stale. Ruled a state of its own rather than a per-repo row, because a per-repo row documents the collision instead of removing it — **5 humpty rows migrated, no state reclassified** (each already read `retired` in its own column; only the glyph moved). Gap 2 was one file contradicting itself: `lobby-ds/SKILL.md` step 3 promised a `**Staged:**` line while its own template three lines below emitted `date:`, and the template is what gets copied — which is why `staged:` appeared in **0 of 113** DS entries while the other three writer skills were correct all along. `staged:` is now the field at both ends, `date:` a read-only alias, and **only live entries age**. Also closed here: `done/goal-loop-is-repo-scoped.md` finally carries the `## ✅ RESOLUTION` law 2 requires. **`inbox/` is empty.** |
| 2026-08-01 | **`goal-loop-is-repo-scoped` re-homed from `kol-dumpty/humpty/lobby/`, fixed and closed the same hour.** It was filed against humpty because a Stop hook trapping the agent reads as agent behaviour, but the two files that had to change — `claude/hooks/goal-loop.sh`, `claude/skills/kol-goal/SKILL.md` — are both this repo's. **Ownership, not strength:** a goal now carries the `session_id` that created it and is inert to every other session; a file with no `session:` line behaves exactly as before. Closed on the user's ruling, which is this repo's stated bar |
