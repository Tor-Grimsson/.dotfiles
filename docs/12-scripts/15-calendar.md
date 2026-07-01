---
title: Calendar scripts
type: reference
status: active
updated: 2026-06-25
description: cplan — a "what's actually coming up" calendar view over gcalcli that hides daily/weekly/biweekly recurring noise so a month-ahead glance shows only the one-offs you'd forget.
tags:
  - project/dotfiles
  - domain/scripts/calendar
related:
  - "[[../01-shell-terminal/14-gcalcli|gcalcli]]"
---

# Calendar (`cplan`)

`bin/cplan` is a [[../01-shell-terminal/14-gcalcli|gcalcli]] companion — a planning
view that lists a window of events with the **daily / weekly / biweekly recurring
noise hidden**, so a month-ahead glance shows only the one-offs and rare events you'd
actually forget. It's **non-prefixed** (callable as `cplan`, matching the `c*` gcalcli
aliases) rather than `cal-…` — a deliberate exception to the `domain-` bin scheme, like
[[07-torrent|`tor-search`]]. Written in **Python** because the grouping needs associative
arrays, which macOS's bash 3.2 lacks.

## Usage
```sh
cplan                  # next 30 days ahead (default)
cplan --7d-p           # p = positive = future, next 7 days
cplan --30d-n          # n = negative = past, last 30 days
cplan --30d-bp         # bp = bipolar = both, 30 days either side of now
cplan --10d-n --30d-p  # asymmetric: window flags COMPOSE into one range (10 back + 30 ahead)
cplan --30d-p -a       # -a/--all = show recurring too (global, not per-side)
cplan -h               # full help
```

Two window flags **compose** into a single range rather than clobbering — a past (`-n`)
and a future (`-p`) flag together span both sides; `--bp` is just shorthand for a
symmetric pair. `-a` is a global on/off, not per-direction.

## How the recurring filter works
gcalcli won't expose the recurrence rule (RRULE), so `cplan` infers frequency from the
event **id**. Google tags each recurring *instance* with an id ending in
`_YYYYMMDD[THHMMSSZ]` over a shared base id; one-offs don't. `cplan`:

1. pulls `gcalcli agenda <start> <end> --tsv --details id` for the window,
2. groups instances by that base id,
3. measures the gap between consecutive instances,
4. **drops any series recurring ≤ 15 days apart** (daily / weekly / biweekly).

Monthly+ series and true one-offs stay. A recurring series with only one instance in the
window also stays — its frequency can't be measured, so it errs toward showing. It's a
heuristic, not the RRULE, but it's robust: one-offs never share a base id, so they can't
be mistaken for a series.

## `cbrief` (morning briefing)
A shell **function** (in `shell/.zshrc`, not a `bin/` script — documented with the
[[../01-shell-terminal/14-gcalcli#aliases|gcalcli aliases]] since that's where its code
lives) that stacks two views: today's full agenda (recurring **included** — you want your
standup) followed by `cplan --30d-p` (recurring hidden). One command for "what's my day,
and what's coming that I'd forget".

## Maintenance
- The ≤ 15-day threshold is `GAP_SKIP_DAYS` at the top of `bin/cplan`. Raise it to also
  hide ~3-weekly series; lower it to keep biweekly visible.
- A self-check lives in the script's history (id parsing, weekly/biweekly→hide,
  monthly/lone→keep, window math). Re-run it after touching `base_id` or the gap logic.
