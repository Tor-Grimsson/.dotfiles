---
title: Invocation — the claude -p contract
type: reference
status: draft
updated: 2026-07-31
description: How a trigger actually starts an agent — the print-mode flags, passing the triggering file in, choosing a working directory, declaring tools up front, and reading the result programmatically.
tags:
  - project/dotfiles
  - domain/tooling
  - domain/ai/llm
related:
  - "[[INDEX|Headless agents]]"
  - "[[01-triggers|01 — triggers]]"
  - "[[04-safety|04 — safety]]"
---

## The shape

```sh
claude -p "<the instruction>" \
  --output-format json \
  --allowedTools "Read,Grep,Glob,Write" \
  --permission-mode acceptEdits
```

`-p` (print mode) runs one turn non-interactively and exits. No TUI, no prompt loop.

| flag | why it matters headless |
|---|---|
| `-p` / `--print` | the whole point — run and exit |
| `--output-format` | `text` for a human log, **`json`** when a script must read the result, `stream-json` for progress |
| `--allowedTools` | the tool allowlist. **Declare it.** An unattended run should not have tools it doesn't need |
| `--permission-mode` | how prompts resolve with nobody there to answer |
| `--model` | pin it — a run that silently changes model changes cost and behaviour |
| `--add-dir` | extra directories the run may read |

Verify the exact flag set against the installed version before wiring anything: `claude --help`. This document is the design, not a tested runbook — see the DRAFT banner on the INDEX.

## Working directory is the real configuration

The `cwd` decides which `CLAUDE.md`, which `.kol/llm-context/`, which hooks and which skills apply. A run started from `~` is a different agent from one started in `~/.dotfiles`.

**Always `cd` explicitly in the wrapper script.** launchd's cwd is not yours.

## Passing the trigger in

`QueueDirectories` tells you a directory is non-empty, not which file. The wrapper resolves it:

```sh
#!/usr/bin/env bash
set -euo pipefail
QUEUE="$HOME/_inbox/agent"
cd "$HOME/.dotfiles"

for f in "$QUEUE"/*; do
  [ -e "$f" ] || continue                    # empty glob guard
  claude -p "A file was dropped for you to process: $f
             Read it, do what it asks, and write your result to
             ${f%.*}.result.md. Do not modify anything else." \
    --output-format text \
    --allowedTools "Read,Grep,Glob,Write" \
    >> "$HOME/_inbox/agent/.log" 2>&1
  mv "$f" "$QUEUE/done/"                     # MUST empty the queue or launchd re-fires
done
```

The `mv` is not optional. `QueueDirectories` fires while the directory is non-empty — leave the file and the job runs forever.

## Reading the result

`--output-format json` gives a structured envelope a script can branch on — result text, cost, duration, session id. Use it when the next step is automated. Use `text` when the next step is you reading a log.

## One turn, not a conversation

Print mode is a **single turn**. There is no follow-up, no clarification, no "are you sure". Consequences:

| implication | what to do about it |
|---|---|
| the agent can't ask you anything | the prompt must be complete — state the file, the goal, and the output location |
| ambiguity resolves silently | keep the task narrow enough that there is one reasonable reading |
| no correction on the next message | the output goes somewhere reviewable, never straight into a tracked file |

`--continue` / `--resume` exist for multi-turn headless work, but a session that accumulates state unattended is a much larger safety problem. Start with one-shot.

## Cost

Every trigger is a paid run. A `WatchPaths` agent on a file your own editor autosaves can fire dozens of times an hour. Before wiring any watcher, answer: **what is the maximum number of times this can fire in an hour, and am I willing to pay for that?**

Mitigations: debounce in the wrapper (a lockfile), pick `QueueDirectories` over `WatchPaths` where possible, and pin a cheap model for triage-shaped work.
