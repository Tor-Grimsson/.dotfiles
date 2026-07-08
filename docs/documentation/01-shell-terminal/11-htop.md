---
title: htop
type: reference
status: active
updated: 2026-06-19
description: Interactive terminal process/resource monitor (TUI) — live CPU, memory and per-process view, with sort/search/filter and kill. The friendly, colour-coded `top`; works over SSH where Activity Monitor can't.
aliases:
  - htop
tags:
  - domain/shell
  - pattern/tui
  - integration/brew-formula
links:
  website: https://htop.dev
  repo: https://github.com/htop-dev/htop
  manual: https://man.archlinux.org/man/htop.1
  brew: https://formulae.brew.sh/formula/htop
covers:
  - Launching, quitting, reading the meters and process columns
  - Finding and killing the process hogging CPU or memory
  - Sort vs search vs filter vs tree, the function keys, F2 setup
  - CLI flags and the "my Mac is slow" walkthrough
related:
  - "[[07-fastfetch|fastfetch]]"
  - "[[01-iterm2|iTerm2]]"
  - "[[04-stats|Stats]]"
---

## Summary
`htop` is an interactive, colour-coded **process and resource monitor** that runs in the terminal. It shows live CPU/memory bars and a sortable list of every running program, and lets you **find the thing eating your machine and kill it** — all by arrow keys and function keys. Think Activity Monitor, but in the terminal, faster, and usable over SSH.

It's the live counterpart to [[07-fastfetch|fastfetch]] (which prints a one-shot specs banner) and the terminal counterpart to [[04-stats|Stats]] (the always-on menu-bar gauge).

## Setup

1. Install (already in the `Brewfile`): `brew install htop`
2. Run it: `htop`
3. Quit it: press **`q`** (or `F10`).

That's the whole install. No config needed — it works out of the box.

## The 30-second version (in a hurry)

You opened htop because something's slow. Here's the entire loop:

1. Type `htop`, hit Enter.
2. The **bars at the top** = how busy your CPU cores and memory are right now.
3. The **list below** = every program running.
4. Press **`P`** to sort by CPU, or **`M`** to sort by memory → the worst offender jumps to the **top of the list**.
5. Read the **`Command`** column (far right) to see what it is.
6. To stop it: **arrow-key up/down** to highlight it → **`F9`** → **Enter** (sends "please quit").
7. Press **`q`** to leave.

Everything below is just detail on those seven steps.

## Reading the screen

The window is three areas: **meters** (top-left), **stats** (top-right), **process list** (everything below).

### Top-left — the meters (the bars)

- **CPU bars** — one bar per core (a modern Mac shows several). A full bar = that core is maxed. The colours in the bar split the load by type — roughly **green = your apps**, **red = the system/kernel**, **blue = low-priority** stuff. (Exact legend: press `F1` inside htop.)
- **Mem** — physical RAM in use. The bar fills as memory is consumed; the coloured segments separate genuinely-used memory from disk cache/buffers (cache is "borrowed" RAM that's freed on demand — not a problem).
- **Swp (swap)** — disk pretending to be RAM. A little is normal. **Swap filling up while Mem is full = you're out of memory and the machine will crawl** — that's your cue to close something.

### Top-right — the stats

- **Tasks** — how many processes/threads exist and how many are actually `running` right now.
- **Load average** — three numbers = average demand over the last **1, 5, 15 minutes**. The dummy rule: compare to your core count (`sysctl -n hw.ncpu`). Load ≈ cores = fully busy but coping; load **well above** cores = things are queuing and waiting. Rising left-to-right (1m > 15m) means it's getting worse.
- **Uptime** — how long since the last reboot.

### The process list — the columns

Each row is one process. The columns that matter, in dummy terms:

| Column | What it means (plain) |
|---|---|
| `PID` | The process's ID number. You need this to kill or target it from elsewhere. |
| `USER` | Who owns it (you, `root`, `_windowserver`, …). |
| `PRI` / `NI` | Scheduling priority / "niceness" (-20 = greedy, 19 = polite). Usually ignore. |
| `VIRT` | Virtual memory — looks **huge and scary, mostly meaningless**. Ignore it. |
| **`RES`** | **Resident memory — the actual RAM this process is using right now.** This is the real memory number. |
| `SHR` | Shared memory (shared libraries). Ignore. |
| `S` | State: **`R`** running, **`S`** sleeping (normal/idle), `D` waiting on disk, **`Z`** zombie (dead, harmless leftover), `T` stopped. |
| **`CPU%`** | **Percent of one core this process is using.** Can exceed 100% — that means it's using more than one core (e.g. 350% = 3½ cores). |
| **`MEM%`** | **Percent of total RAM this process is using.** |
| `TIME+` | Total CPU time it's burned since it started. |
| **`Command`** | **What the process actually is.** The full command line — your main clue to identify it. |

The three you actually read: **`CPU%`**, **`RES`/`MEM%`**, and **`Command`**.

## Finding the resource hogger (the main event)

This is what htop is *for*. Two flavours of "hog":

**The CPU hog** (fan spinning, app beachballing):
1. Press **`P`** (sort by CPU) — or `F6` → pick `PERCENT_CPU`.
2. The top row is your worst CPU user. Read its `CPU%` and `Command`.

**The memory hog** (machine swapping, everything sluggish):
1. Press **`M`** (sort by memory) — or `F6` → pick `PERCENT_MEM`.
2. The top row is your worst memory user. Look at its **`RES`** (real RAM) and `MEM%`.

Then identify it from the `Command` column. If the culprit is a vague helper process and you can't tell what it belongs to, switch to **tree view** (`F5` or `t`) to see its parent — e.g. a runaway `node` shows up nested under the app that launched it. Press `F` to "follow" a process so it stays selected even as the sort reshuffles.

> `P`/`M`/`T` are quick-sort shortcuts: **P**rocessor, **M**emory, **T**ime. Press `I` to invert (smallest-first).

## Killing a runaway process

1. **Arrow-key** up/down to highlight the process (or `F3`/`/` to search to it — see below).
2. Press **`F9`** (kill).
3. Pick a **signal** from the left-hand menu:
   - **`SIGTERM` (15)** — "please shut down cleanly." **Always try this first.**
   - **`SIGKILL` (9)** — "die now, no cleanup." Use only when `SIGTERM` doesn't work — it can't be ignored, but the program gets no chance to save.
4. Press **Enter** to send, or **Esc** to back out.

**Kill several at once:** press **`Space`** on each process to tag them (they highlight), then `F9` sends the signal to all tagged. `U` untags everything.

**Dummy safety rules:**
- **You can only kill your own processes.** To touch system processes or another user's, quit and run **`sudo htop`**.
- **Don't kill things you don't recognise.** Killing `kernel_task`, `WindowServer`, `launchd`, or `loginwindow` can freeze the screen or log you out. When unsure, copy the `Command` name and look it up *before* killing.
- **`kernel_task` eating CPU is usually macOS managing heat**, not a bug — leave it.
- Prefer quitting an app the normal way (⌘Q) first; reach for `F9` when it's already hung.

## Sort vs Search vs Filter vs Tree (don't confuse them)

These four feel similar and trip everyone up:

| Key | Name | What it does |
|---|---|---|
| `F6` (or `P`/`M`/`T`) | **Sort** | Reorders the whole list by a column. Everything still shown. |
| `F3` or `/` | **Search** | Type a name → *jumps* to the first match and highlights it. List stays full; Enter cycles to the next match. |
| `F4` or `\` | **Filter** | Type a name → *hides* everything that doesn't match. Esc clears the filter. Best for "show me only `chrome`". |
| `F5` or `t` | **Tree** | Shows the parent→child hierarchy (who launched what). `t` toggles it; `-`/`+` collapse/expand a branch. |

Rule of thumb: **Search** = "take me to it", **Filter** = "show me only these", **Sort** = "worst first", **Tree** = "who spawned this".

## Handy keys (cheat sheet)

| Key | Does |
|---|---|
| `F1` | Help (incl. the colour legend) |
| `F2` | **Setup** — customise meters, columns, colours (see below) |
| `F3` / `/` | Search (jump to a process) |
| `F4` / `\` | Filter (show only matches) |
| `F5` / `t` | Tree view toggle |
| `F6` | Choose sort column |
| `F7` / `F8` | Nice − / + (change priority; may need `sudo`) |
| `F9` / `k` | Kill (send a signal) |
| `F10` / `q` | Quit |
| `Space` | Tag / untag a process (multi-select) |
| `U` | Untag all |
| `u` | Filter by user (pick from a list) |
| `P` / `M` / `T` | Quick-sort by CPU / Memory / Time |
| `I` | Invert the sort order |
| `H` | Show/hide user threads |
| `K` | Show/hide kernel threads |
| `F` | Follow the selected process across re-sorts |
| arrows / PgUp / PgDn | Move the selection |

## Customising (F2 Setup)

Press `F2` to open Setup — four columns you navigate with arrows + Space/Enter:

- **Meters** — add/remove/rearrange the top bars. Useful adds: a **clock**, **load average** as a bar, **battery**, **memory as text**. Left/right column = which side it sits on; you can also switch a meter between bar / text / graph / LED style.
- **Display options** — toggles like *tree view by default*, *highlight the program "basename"* (so the actual binary name stands out), *hide kernel threads*, *highlight high-CPU processes*.
- **Colors** — pick a colour scheme.
- **Columns** — add or remove process-table columns (e.g. add `STARTTIME`, drop `VIRT`/`SHR` to declutter).

Settings save to `~/.config/htop/htoprc` automatically on quit. Don't hand-edit it while htop is running — it'll get overwritten.

## Command-line flags

You usually just run `htop`, but these start it pre-focused:

| Flag | Does | Example |
|---|---|---|
| `-u [USER]` | Only this user's processes (defaults to `$USER`) | `htop -u` |
| `-p PID,…` | Only the given PIDs | `htop -p 501,777` |
| `-t` / `--tree` | Start in tree view | `htop -t` |
| `-s COLUMN` / `--sort-key` | Start sorted by a column | `htop -s PERCENT_MEM` |
| `-d DELAY` | Update delay in **tenths of a second** (10 = 1s) | `htop -d 10` |
| `-F TERM` / `--filter` | Start filtered to matching commands | `htop -F node` |
| `--readonly` | Disable all kill/nice — a safe "look but don't touch" mode | `htop --readonly` |
| `-C` / `--no-color` | Monochrome | `htop -C` |
| `-h` / `-V` | Help / version | `htop -V` |

`htop -s help` prints every sortable column name (handy for `-s`).

## macOS notes & gotchas

- **`sudo htop` to see/manage everything.** Without root you fully control only your own processes; some other-process detail is hidden or unkillable.
- **No `strace`/`lsof` keys.** The Linux builds map `s` (trace syscalls) and `l` (list open files) to a process; those are Linux-only and do nothing useful on macOS.
- **`kernel_task` high CPU** is macOS throttling for heat, not a runaway — don't fight it.
- It reads `hw.ncpu` for the core count — load-average judgement is relative to that.

## "My Mac is slow" — the walkthrough

1. `htop`.
2. Glance at the **top bars**: are the CPU bars pinned, or is **Mem full and Swp climbing**? That tells you CPU-bound vs memory-bound.
3. CPU-bound → press **`P`**. Memory-bound → press **`M`**.
4. Look at the **top row**: `Command` (what), `CPU%` or `RES` (how bad).
5. Recognise it? If it's an app, quit it normally (⌘Q). If it's a hung helper, **arrow to it → `F9` → `SIGTERM` (15) → Enter**.
6. Didn't die? `F9` again → **`SIGKILL` (9)**.
7. Don't recognise it? **Look up the name before killing** — don't nuke a system process blind.
8. `q` to leave.

## Why installed
The terminal-native "what's eating my machine" tool. Opening Activity Monitor is a context switch and useless over SSH; `htop` is one word, lives in the terminal, and works the same on a laptop or a headless box you're sshed into. It pairs with the rest of the shell stack — spot a hog here, act on it without leaving the keyboard.

## Biggest win
**Find-and-kill in seconds, anywhere.** Sort by CPU or memory, see the offender at the top with a readable command line, and end it with two keys — no mouse, no app launch, and identically over SSH. The colour meters also make memory *pressure* (swap filling) obvious in a glance, which Activity Monitor buries.

## Future use
A tuned `htoprc` (preferred meters, tree-by-default, decluttered columns) committed to the dotfiles so both machines open the same layout; a `htop -u` or filtered alias for common checks; pairing it with [[07-fastfetch|fastfetch]] for static specs and [[04-stats|Stats]] for the always-on menu-bar glance.
