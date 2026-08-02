---
title: Safety — what an unattended run must never do
type: reference
status: draft
updated: 2026-07-31
description: The rules that make a headless run survivable — report-don't-decide, the write-target whitelist, tool allowlists, runaway protection, and how the existing gates (git-gate, humpty modes, goal-loop) behave when nobody is watching.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/automation
related:
  - "[[INDEX|Headless agents]]"
  - "[[02-invocation|02 — invocation]]"
  - "[[operations/systems/claude-harness/04-hooks-and-tools|hooks and tools]]"
---

## The asymmetry

Interactive work has a corrector in the loop: a wrong turn gets caught on the next message. A headless run has nobody until you happen to look. So the standard is not *"can it do the right thing"* — it's **"what is the worst thing it can do, and can I live with that."**

## The one rule

**An unattended agent reports; it does not decide.**

Every use case in [[03-use-cases|03]] obeys it. The lobby triage *notices* a missing ledger row and writes a gap report — it does not file the row. The screenshot triage *suggests* a name — it does not rename. That isn't timidity; it's the only version where a wrong answer costs a `rm` instead of an investigation.

## Write-target whitelist

An unattended run may write to:

| allowed | why |
|---|---|
| `_tmp/` in the repo | gitignored, disposable by design |
| `~/_inbox/` and its subfolders | already the staging area |
| a dotfile sidecar next to its input (`.triage.md`, `.result.md`) | reviewable, deletable, obvious |

It may **not** write to: tracked source · configs · `ref/*.md` · `docs/` · any `lobby/` ledger · `.kol/llm-context/`. Those are things you'd have to *undo*, and undoing needs the git the agent isn't allowed to run.

## Tool allowlist — declare it every time

`--allowedTools` is not optional decoration. A triage job needs `Read, Grep, Glob, Write`. It does not need `Edit`, `Bash`, `WebFetch` or `Agent`. Every tool omitted is a class of accident removed.

Where a job genuinely needs a command, scope it: `Bash(repo-map.sh:*)` rather than `Bash`.

## How the existing gates behave with nobody watching

| gate | headless behaviour | verdict |
|---|---|---|
| `git-gate.sh` | git stays denied; the agent can't grant itself the window | **holds** — git is user-owned regardless |
| `doc-sync-reminder.sh` | prints a reminder into a transcript nobody reads | **inert, harmless** |
| `footer-gate.sh` | Stop hook enforcing report shape on output nobody reads | **noise** — consider exempting print mode |
| humpty modes (`jana`/`rosa`/`yona`) | armed from prompt text; a headless prompt normally carries none | **usually inert.** `rosa` would be a *deliberate* choice for a read-only sweep |
| `goal-loop.sh` | **DANGER.** It blocks Stop. In print mode a blocked stop has no user to release it | **must not be active** — see below |

### goal-loop and print mode — SOLVED 2026-07-31

`goal-loop.sh` refuses to let a turn end while a goal is active. Correct interactively; fatal headless — nobody can type `/kol-goal done`, and `/kol-goal-force` makes it stricter still. A stray `.active-goal.md` left `active` would trap every print-mode run started in that repo. Same class as the 2026-07-31 deadlock, minus the human who noticed.

**The exemption:** the hook checks `KOL_HEADLESS` **first**, before anything else can block.

```sh
[ -n "${KOL_HEADLESS:-}" ] && exit 0
```

Any wrapper running `claude -p` **must** set it — `bin/agent-drop` does. Tested: same payload blocks interactively and releases with `KOL_HEADLESS=1`, and the iteration counter is not incremented on the exempt path.

**Still true after the 2026-08-01 checklist.** The hook now also refuses `status: done` while a `- [ ]` box is unticked, which is a second way a print-mode run could be trapped — a stray goal file with unticked items would otherwise block forever. It cannot: the `KOL_HEADLESS` line is the first statement in the script, above every branch that can print a block. The checklist's own three outs (no checkboxes → unchanged, `blocked` → releases, cap → releases) apply interactively and are not what protects headless; the exemption is.

## Runaway protection

| risk | guard |
|---|---|
| `QueueDirectories` re-firing forever | the job **must** empty the queue — `mv` to `done/` |
| `WatchPaths` self-triggering | never write inside a watched path |
| a burst of files → a burst of paid runs | lockfile in the wrapper; process the queue in one run, not one run per file |
| launchd throttling on repeated failure | fail loudly inside the job, exit 0 outside |
| unbounded cost | pin `--model`; ask "max fires per hour?" before wiring anything |

## Observability

Neither existing launch agent sets `StandardOutPath` or `StandardErrorPath` — so if they fail, they fail silently. **Any headless agent must set both.** A run you can't inspect afterwards is a run you can't trust.

Minimum: append the prompt, the exit code and the result to a dated log under `~/_inbox/agent/.log`.

## The pre-flight questions

Before wiring any trigger:

- [ ] What is the **worst** thing this run can write, and is it disposable?
- [ ] What is the **maximum** number of times it can fire in an hour?
- [ ] Does the job **empty its queue** / write outside its watched path?
- [ ] Is `--allowedTools` the minimum set?
- [ ] Is there **no active goal file** in the cwd?
- [ ] Are stdout and stderr going somewhere I will actually find?
