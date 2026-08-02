---
title: Use cases — five worked examples
type: reference
status: draft
updated: 2026-07-31
description: From a drop-folder triage that would work today to a lobby auto-triage and a nightly drift sweep — each with its trigger, its prompt, its output, and an honest note on what could go wrong.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/automation
related:
  - "[[INDEX|Headless agents]]"
  - "[[01-triggers|01 — triggers]]"
  - "[[04-safety|04 — safety]]"
---

Ordered by ambition. The first is buildable this afternoon; the last needs the safety layer settled first.

---

## 1 — Drop folder: "read this and tell me what it is" — **BUILT**

**The literal answer to the original question.** Drop anything into `~/_inbox/agent/`; an agent reads it and leaves a note beside it.

Shipped as **`bin/agent-drop`** (2026-07-31). Live-tested end to end: a scratch `.md` produced a `.result.md` naming where it belonged and what was wrong with it; a `.bin` was skipped on type and never reached the model; the queue emptied to `done/`. Run it by hand (`agent-drop`, `--dry-run`, `--init`) or arm the launchd watcher — see the INDEX.

One bug found in testing and fixed: the type-skip branch moved files **before** the dry-run check, so `--dry-run` quietly emptied part of the queue. A dry run must move nothing.

| | |
|---|---|
| trigger | launchd `QueueDirectories` on `~/_inbox/agent/` |
| prompt | *"Read `$f`. Say in five lines what it is, what it's for, and where in the estate it belongs. Write to `${f%.*}.result.md`."* |
| tools | `Read, Grep, Glob, Write` |
| output | a sibling `.result.md`, then the input moves to `done/` |
| failure mode | the agent misreads a binary as text — guard the glob to `*.md *.txt *.json` |

**Why start here:** the output is a new file next to the input. Nothing existing is touched. The worst case is a file you delete.

---

## 2 — Screenshot triage

You already capture to `~/_inbox` with `clip-drop.sh`. Captures accumulate unnamed.

| | |
|---|---|
| trigger | `QueueDirectories` on `~/_inbox/` |
| prompt | *"Look at `$f`. Suggest a kebab-case filename and one line of context. Append both to `~/_inbox/.triage.md`. Do not rename anything."* |
| tools | `Read, Write` |
| output | a triage list you skim later and act on yourself |
| failure mode | none that matters — it only ever appends to one file |

**The discipline:** it *suggests* a rename and never performs one. Naming is a judgement call, and a wrong rename is work to undo.

---

## 3 — Lobby auto-triage

The lobby is an input, not the system. A ticket landing in any of the four `lobby/inbox/` folders could start a run.

| | |
|---|---|
| trigger | `QueueDirectories` on each registered `lobby/inbox/` |
| prompt | *"A new lobby entry landed: `$f`. Read it and the lobby's ledger. Verify the entry has `Staged:`, a definition-of-done, and a ledger row. Report gaps to `lobby/inbox/.triage.md`. Change nothing else."* |
| tools | `Read, Grep, Glob, Write` |
| output | a gap report — never a state change |
| failure mode | **the state law.** Open · closed · stale · parked is the user's call. An agent that moved a ticket would break the system it was checking |

**Note the shape:** even here the agent only *reports*. `clip-drop.sh` already writes the ledger row at file time, so there is nothing for a watcher to fix — only things for it to notice.

---

## 4 — Nightly drift sweep

Not file-triggered — a timer. The estate drifts: dead nav targets, stale ref cards, docs pointing at renamed repos. Today those are found by accident, mid-task.

| | |
|---|---|
| trigger | launchd `StartInterval` (nightly) |
| prompt | *"Run `repo-map.sh` and `lobby --counts`. Check every path named in `ref/*.md` still exists. Write findings to `_tmp/drift-<date>.md`. Report only — change nothing."* |
| tools | `Read, Grep, Glob, Bash(repo-map.sh:*), Bash(lobby:*), Write` |
| output | a dated drift report |
| failure mode | a noisy report nobody reads — keep it empty-when-clean |

**Precedent:** every finding this class would have caught was found by hand this week — `kol-apparat/kol-design-system` dead in 6 skills, 26 of 27 `g-nav` targets dead, `ref-pick` silently missing 3 cards. That's the argument for it.

---

## 5 — Config validation on change

| | |
|---|---|
| trigger | `WatchPaths` on `aerospace/aerospace.toml`, `tmux/.tmux.conf`, `ghostty/config` |
| prompt | *"`$f` changed. Validate it (`aerospace reload-config --dry-run` / `tmux -f … -C`). If it fails, write the error to `_tmp/config-error.md` and notify."* |
| tools | `Read, Bash(aerospace:*)` |
| output | silence on success, a file + notification on failure |
| failure mode | **the loop.** If the job writes anywhere it watches, it re-triggers itself forever. Output must live outside the watched paths |

**Honest caveat:** you already validate by hand as part of editing, and the syntax check is one command. This earns its keep only if config edits start coming from somewhere other than your own hands.

---

## What none of these do

- No commits, no pushes, no branch changes — `git` is user-owned, and that doesn't relax because nobody's watching.
- No installs, no `brew`, no `bootstrap.sh`.
- No edits to tracked source. Outputs go to `_tmp/`, `~/_inbox/`, or a `.triage.md` — places where a wrong answer costs a `rm`.
- No renaming or moving of the user's files.
