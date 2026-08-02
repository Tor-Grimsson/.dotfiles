---
title: Triggers — every way a run can start
type: reference
status: draft
updated: 2026-07-31
description: launchd QueueDirectories vs WatchPaths vs StartInterval, entr, git hooks and webhooks — what each can detect, what it passes on, and which are already present on this machine.
tags:
  - project/dotfiles
  - domain/tooling
  - pattern/automation
related:
  - "[[INDEX|Headless agents]]"
  - "[[02-invocation|02 — invocation]]"
---

## What's already here

| mechanism | on this machine | used by |
|---|---|---|
| launchd `StartInterval` | **yes** | `com.kolkrabbi.tg-inbox` (120s) · `com.kolkrabbi.dot-sync` (1800s) · `com.kolkrabbi.mpd` |
| launchd `QueueDirectories` | available, **unused** | — |
| launchd `WatchPaths` | available, **unused** | — |
| `entr` | **installed** (`/usr/local/bin/entr`, `brewfile-cli:110`) | `pdf-from-md.sh -w` |
| `git` hooks | **yes** | the docs → vault mirror (post-commit) |

So the pattern is established — both agents poll on a timer. The event-driven half simply hasn't been used yet.

## launchd — the macOS answer

### `QueueDirectories` — "new files appeared"

Fires when a watched directory is **non-empty**, and **keeps firing until it is empty again**. That last clause is the whole design: it's a work queue, not a notification. The job is expected to consume the files.

```xml
<key>QueueDirectories</key>
<array><string>/Users/biskup/_inbox/agent</string></array>
```

| property | value |
|---|---|
| detects | a file existing in the directory |
| tells you | **nothing about which file** — you list the directory yourself |
| repeats | yes, until the directory is empty |
| the trap | if your job doesn't remove or move the file, launchd re-fires forever |

This is the closest thing to what was asked: *"woken when new files appear in the folder"*.

### `WatchPaths` — "something changed"

Fires when any listed path is modified, created or deleted. Works on files *and* directories.

| property | value |
|---|---|
| detects | any change to the path |
| tells you | nothing — you diff or stat yourself |
| repeats | once per change, no queue semantics |
| the trap | edits by your own job can re-trigger it — an infinite loop unless the job writes elsewhere |

Use for *"the config changed, re-validate"*. Don't use for a work queue — that's what `QueueDirectories` is for.

### `StartInterval` — the timer

What both existing agents use. Simplest, most predictable, and wrong for this: it wakes on a clock whether or not anything happened, and adds up to `interval` seconds of latency.

| when to prefer it | when not |
|---|---|
| the check is cheap and the source is remote (an API, a bucket) | a local directory — `QueueDirectories` is free and instant |

## `entr` — the foreground watcher

Already installed. Reads a list of files on stdin, re-runs a command when any changes.

```sh
ls lobby/inbox/*.md | entr -n claude -p "summarise the newest lobby entry"
```

| property | value |
|---|---|
| lives | in a terminal, in the foreground |
| survives logout | **no** |
| good for | a watch you start deliberately and watch happen |
| bad for | anything unattended — that's launchd's job |

## git hooks

A `post-commit` or `post-merge` hook can start a run. Precedent exists: the docs → vault mirror is a post-commit hook.

**Caveat that matters here:** the agent is forbidden from running git. A git hook *starting* an agent is fine; an agent *inside* a hook must never touch the repo state that triggered it.

## Choosing

| you want to react to | use |
|---|---|
| a file dropped in a folder | launchd **`QueueDirectories`** |
| a config file being edited | launchd **`WatchPaths`** |
| a remote thing you must poll | launchd **`StartInterval`** |
| a commit | a git hook |
| something while you watch it | **`entr`** |

## The launchd facts that bite

- Agents live in `~/Library/LaunchAgents/`, load at login, run **as you**.
- `bootstrap.sh` symlinks them; the existing three are the template.
- launchd gives the job a **minimal environment** — no brew on `PATH`. Both existing agents work around it with `/bin/zsh -lc`, which sources your profile. Copy that.
- A job that exits non-zero repeatedly gets throttled by launchd. Fail loudly *inside* the job, exit 0 outside.
- `launchctl list | grep kolkrabbi` shows load state; the log paths are whatever you set in `StandardOutPath` / `StandardErrorPath` — the existing agents set neither, which is a gap worth closing when the first watcher lands.
