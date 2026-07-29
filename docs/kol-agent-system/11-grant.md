---
title: 11 · grant — time-boxed permission windows
type: reference
status: active
updated: 2026-07-28
description: The keyed gate in the NO-GIT wall — prefix g opens a self-expiring 15-minute window where the agent may run read-only git and downloads, enforced by a PreToolUse hook, surfaced in the statusline and the reinforce cadence.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[08-behavior|08 — behavior]]"
---

# 11 · grant

The NO-GIT wall gets a keyed gate: `prefix g` (or `agent-grant [min]`) opens a time-boxed window where the agent may run **read-only git + downloads**; it expires by itself, shows as a yellow badge while open, and never touches a tracked file.

## Actors

| file | role |
|---|---|
| `bin/agent-grant` | CLI — open/extend/revoke/status/toggle; writes the expiry epoch to the flag |
| `claude/hooks/git-gate.sh` | PreToolUse(Bash) gate — replaced the `settings.json` git deny rules; the only enforcer |
| `claude/hooks/agent-reinforce.sh` | injects "window open, Nm left" **every turn** while active — lifts the NO-GIT text for reads |
| `claude/hooks/statusline.sh` | `[GRANT git Nm]` yellow badge while the window is open |
| `tmux/.tmux.conf` | `prefix g` → `agent-grant toggle` (+ `display-message`) |
| `~/.claude/.agent-grant` | the flag: one line, expiry epoch — runtime state, never tracked |
| `~/.claude/.humpty-grant` | **written in lockstep since 2026-07-28** — the humpty plugin's gate holds its own window; both gates are deny-first, so `bin/agent-grant` opens/revokes both flags or the grant is dead (caught by the [[12-setup-a-to-z|A–Z]] verification pass, fixture-proven) |

## Commands

```
agent-grant           # open 15m (default)
agent-grant 30        # open/extend to 30m
agent-grant off       # revoke now
agent-grant status    # remaining time; exit 1 if closed
agent-grant toggle    # what prefix g calls: closed → 15m · open → revoke
```

## Window semantics

| state | git read (log/show/diff/status/blame/…) | git write (commit/push/add/…) | wget / curl / git clone·fetch |
|---|---|---|---|
| **closed** | deny — reason names the unlock command | deny | normal permission prompt |
| **open** | auto-allow (whole command must be git-read + benign filters) | **deny — always** | auto-allow |
| **open, mixed/odd command** | "ask" — falls back to the normal prompt | deny | "ask" |

## Why it's shaped this way

A `permissions.deny` rule lives in `settings.json` — a **tracked** file, so lifting it at runtime would dirty the repo on every toggle, and settings deny beats any allow anywhere. Moving the block into a PreToolUse hook makes it runtime-readable: the flag is checked **per tool call**, so grant/revoke applies mid-session with no restart and expiry is arithmetic on a stored epoch — no timers, no cleanup, reboot-safe. The gate's command splitter is deliberately naive: a wrong parse can only downgrade to "ask"/"deny", never widen an allow. A bare-path `/usr/bin/git` dodges the gate but still lands on the normal permission prompt — the gate guards the honest path, the prompt guards the rest.

## Export notes

Self-contained module: two scripts + three hook touchpoints + one bind. Only dependency is `python3` (and tmux for the key; the CLI works without it). Ports to any harness with pre-tool hooks + a prompt-inject seam; the flag-file contract (one line, expiry epoch) is the whole interface. Staged for porting in kol-dumpty `lobby/agent-grant.md`.
