---
title: dot-sync, explained slowly
type: guide
status: active
updated: 2026-06-05
description: The commit-first model in plain words, repeated until it sticks — edits stay home, commits travel.
aliases:
  - dot-sync-explained
audience: internal
tags:
  - project/dotfiles
  - domain/scripts/sync
related:
  - "[[11-dot-sync|Dotfiles sync]]"
---

# dot-sync, explained slowly

One idea lives in this doc. It gets said six times, six ways, on purpose.
Technical detail lives in [the reference doc](11-dot-sync.md). This one is for
a tired brain at midnight wondering why a change is not on the other machine.

## 1. The one sentence

**dot-sync moves commits, not edits.**

That is the whole system. Everything below is the same sentence again.

## 2. The mail metaphor

A commit is a sealed envelope. The daemon is the mailman.

- The mailman comes every 30 minutes.
- He takes sealed envelopes. He delivers sealed envelopes.
- He will **not** take loose papers off your desk.

An edit you have not committed is loose paper on the desk. It goes nowhere.
Seal it (commit it) and the next mailman run takes it.

## 3. What happens when you edit and walk away

You change `.zshrc` on the MacBook. You close the laptop. You sit down at the iMac.

The change is **not there**. It is not lost — it is sitting on the MacBook,
exactly where you left it, uncommitted. The daemon saw it and deliberately
did not touch it. It will sit there forever until you commit it.

The other machine only ever receives things you committed.

## 4. The two jobs, split

There are two jobs in syncing. One is yours. One is the robot's.

| Job | Who | What it means |
|---|---|---|
| **Authorship** | you | deciding a change is done, and committing it |
| **Transport** | the daemon | carrying committed work between the machines |

The robot never does your job. It never commits, ever.
You never need to do the robot's job. Pulled and pushed for you, every 30 min.

## 5. The table

What the daemon does, per situation:

| Your repo right now | Daemon does |
|---|---|
| clean, other machine pushed something | pulls it in |
| clean, you committed but forgot to push | pushes it |
| **uncommitted changes anywhere** | **nothing — hands off, one notification** |
| no internet | nothing, silently, retries later |

Read the third row twice. Uncommitted = untouched. Always.

## 6. The midnight question

> "I changed this yesterday, why is it not on this machine?!"

Because you did not commit it. That is the answer every time.
Not a bug. Not a broken daemon. A loose paper on the other desk.

Go to the other machine, commit, wait up to 30 minutes — or skip the wait:

```sh
dot-sync.sh
```

## The three commands you actually need

```sh
git add -A && git commit -m "what changed"   # seal the envelope
dot-sync.sh                                  # mailman, now
tail ~/Library/Logs/dot-sync.log             # what has the mailman been doing
```

## Why it works this way

These files are symlinked into the live home directory on both machines.
If the robot committed for you, a half-edited `.zshrc` would ship to the
other machine on a timer and break a shell you are actively using.
So: you decide what is done. The robot only carries it.

**dot-sync moves commits, not edits.** Told you it was one idea.
