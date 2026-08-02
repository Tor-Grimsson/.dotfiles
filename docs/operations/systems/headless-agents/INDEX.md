---
title: Headless agents — work that starts without you
type: index
status: draft
updated: 2026-07-31
description: Running Claude non-interactively — triggered by a file landing, a schedule, or another program instead of by you typing. The trigger layer (launchd WatchPaths/QueueDirectories, cron, entr), the invocation layer (claude -p), and the discipline that keeps an unattended agent from doing damage.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/automation
related:
  - "[[operations/systems/INDEX|systems/]]"
  - "[[01-triggers|01 — triggers]]"
  - "[[02-invocation|02 — invocation]]"
  - "[[03-use-cases|03 — use cases]]"
  - "[[04-safety|04 — safety]]"
  - "[[operations/systems/lobby/INDEX|lobby]]"
---

# Headless agents

**The question that started this (2026-07-31):** *"can agent with auto mode on, in idle state, be woken to do a task if new files appear in the folder it instances?"*

The short answer is **no, and yes**. No — an idle interactive session cannot be woken; it only advances when you type. Yes — a **new** agent run can be started by anything the OS can trigger, and that run can read the file that caused it.

That distinction is the whole system. Nothing "wakes"; something **starts**.

## Status — one built, opt-in

| piece | state |
|---|---|
| `goal-loop.sh` **headless exemption** | **shipped.** `KOL_HEADLESS=1` releases the Stop hook. Without it a stray active goal file traps every print-mode run in that repo |
| `bin/agent-drop` | **shipped + live-tested.** Use case 1 — drop a file in `~/_inbox/agent/`, get a `.result.md` beside it |
| `com.kolkrabbi.agent-drop.plist` | **written, NOT installed.** `QueueDirectories` on the queue folder. The bootstrap block is commented out — headless runs cost money, so this is opt-in |
| use cases 2–5 | design only |

To arm the watcher:

```sh
mkdir -p ~/Library/LaunchAgents ~/_inbox/agent/done
cp ~/.dotfiles/macos/launchd/com.kolkrabbi.agent-drop.plist ~/Library/LaunchAgents/
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.kolkrabbi.agent-drop.plist
```

Until then `agent-drop` runs on demand — which is the safer way to meet it.

## Why it's a system, not part of lobby

The lobby is *one possible input*. A file landing in `lobby/inbox/` could start an agent — but so could a screenshot in `~/_inbox`, a CI webhook, a calendar event, a `git` hook, or a clock. The trigger layer, the invocation contract and the safety rules are the same regardless of which of those fires.

Filing this under lobby would bind a general capability to one of its consumers. Same test the systems shelf already applies: *something that spans more than one repo, machine or service, and therefore has no natural home inside any single one of them.*

## The three layers

```
   ┌─────────────────────────────────────────────────────────┐
   │  TRIGGER — something happened                           │
   │  launchd QueueDirectories · WatchPaths · StartInterval  │
   │  entr · git hook · webhook · cron                       │
   └───────────────────────────┬─────────────────────────────┘
                               │  passes: what happened, where
                               ▼
   ┌─────────────────────────────────────────────────────────┐
   │  INVOCATION — a run is started                          │
   │  claude -p "<prompt>" --output-format …                 │
   │  cwd = the repo · a skill or a written prompt as the    │
   │  instruction · allowed tools declared up front          │
   └───────────────────────────┬─────────────────────────────┘
                               │  produces: a change, a report
                               ▼
   ┌─────────────────────────────────────────────────────────┐
   │  OUTCOME — where the work lands                         │
   │  a file · a lobby ticket · a log line · a notification  │
   │  NEVER a silent commit, never a push                    │
   └─────────────────────────────────────────────────────────┘
```

| doc | covers |
|---|---|
| [[01-triggers\|01 — triggers]] | every way a run can start, what each one can and can't tell you, and which are already on this machine |
| [[02-invocation\|02 — invocation]] | the `claude -p` contract: prompt, cwd, tool allowlist, output format, exit codes |
| [[03-use-cases\|03 — use cases]] | five worked examples, from trivial to ambitious |
| [[04-safety\|04 — safety]] | what an unattended agent must never be allowed to do, and how the existing gates apply |

## The one rule

**An unattended agent reports; it does not decide.** Interactive work has you in the loop to catch a wrong turn on the next message. A headless run has nobody. Everything here is built so the worst outcome is a file you have to delete, never a change you have to undo.
