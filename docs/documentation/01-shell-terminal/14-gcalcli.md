---
title: gcalcli
type: reference
status: active
updated: 2026-06-25
description: Google Calendar from the terminal — agenda/week/month views, natural-language quick-add, edit and import, all without opening a browser.
aliases:
  - gcalcli
tags:
  - domain/productivity
  - pattern/cli
  - integration/brew-formula
  - integration/google
links:
  website: https://github.com/insanum/gcalcli
  repo: https://github.com/insanum/gcalcli
  manual: https://github.com/insanum/gcalcli/blob/master/docs/api-auth.md
  brew: https://formulae.brew.sh/formula/gcalcli
covers:
  - One-time Google Cloud OAuth client setup (the only friction)
  - agenda / calw / calm views, quick-add, add, edit, import
  - Where the token + config live (token is a secret → not the repo)
  - The c-prefixed aliases + the cplan planning view (hides recurring noise)
related:
  - "[[16-kanban-tui|kanban-tui]]"
  - "[[16-capture|Capture pipeline]]"
  - "[[15-calendar|Calendar scripts (cplan)]]"
  - "[[01-console-map|Google console map]]"
---

## Summary
`gcalcli` reads and writes your **Google Calendar** from the shell — `gcalcli agenda` for what's next, `gcalcli calw` for a week grid, `gcalcli quick "Dinner with Sam tomorrow 7pm"` to drop an event in with natural language. No browser, no mouse. It's the de-facto Google Calendar CLI (Python, the most popular Google-only option).

It is **Google-only** by design. For iCloud/Nextcloud or local-first storage you'd want `khal` + `vdirsyncer` instead — a heavier, provider-agnostic CalDAV stack. For a pure-Google workflow, gcalcli is the lighter, better fit.

## Setup
The one chore is a **one-time Google OAuth client** — gcalcli no longer ships a bundled API client, so you make your own (free, ~5 min). Done once per Google account; the token then caches per machine.

1. Install: `brew bundle` (it's in the `Brewfile` — `brew "gcalcli"`).
2. **Create the OAuth client** at <https://console.cloud.google.com>:
   - New project (any name) → **APIs & Services → Library →** enable **Google Calendar API**.
   - **OAuth consent screen →** User type **External** → add your own Google address under **Test users** (keeps it in "testing" — no Google verification needed for personal use).
   - **Credentials → Create credentials → OAuth client ID →** application type **Desktop app**. Copy the **client ID** and **client secret**.
3. **Authorise** (opens a browser, you grant access — run this yourself):
   ```sh
   gcalcli --client-id=YOUR_ID.apps.googleusercontent.com init
   # paste the client secret when prompted, approve in the browser
   ```
4. Test: `gcalcli list` (should print your calendars), then `gcalcli agenda`.

> **Secrets stay out of the repo.** The OAuth token lands beside the config as `~/Library/Application Support/gcalcli/oauth` — machine-local, never tracked (ARCHITECTURE §3, like the Jackett / B2 keys). That's why only `config.toml` is symlinked, not the whole dir. The client ID/secret are likewise per-account, not committed. The `Brewfile` line, `config.toml`, and the aliases are the only repo-tracked pieces.

## Use
```sh
gcalcli agenda                       # upcoming events (default: now → a week)
gcalcli agenda today tomorrow        # explicit range (natural-language dates ok)
gcalcli calw                         # this week as a calendar grid
gcalcli calw 3                       # next 3 weeks
gcalcli calm                         # current month grid
gcalcli quick "Lunch w/ Ana Fri 1pm" # natural-language quick-add
gcalcli add                          # interactive add (prompts title/when/where/duration)
gcalcli edit "standup"               # find matching events → edit / delete interactively
gcalcli import meeting.ics           # import an ICS/vCal file
gcalcli list                         # list your calendars
gcalcli --calendar "Work" agenda     # scope a command to one calendar
gcalcli remind 10 'notify "%s"'      # run a command when an event is within 10 min
```

## Config
The config file lives at **`~/Library/Application Support/gcalcli/config.toml`** on macOS (not `~/.config` — gcalcli uses the platform app-support dir; override with `$GCALCLI_CONFIG`). It's **tracked in the repo** as `gcalcli/config.toml` and symlinked there by `bootstrap.sh` — edit the repo copy, not the live file. `gcalcli config edit` opens it in `$EDITOR`.

The schema is small — only these three sections exist ([full schema](https://raw.githubusercontent.com/insanum/gcalcli/HEAD/data/config-schema.json)):
```toml
[output]
week-start = "monday"          # or "sunday" (the only output setting)

[calendars]
# default-calendars = ["you@gmail.com"]   # scope default commands to these
# ignore-calendars  = ["Holidays in Iceland"]

[auth]
# client-id = "...apps.googleusercontent.com"   # kept OUT of the repo (§3)
```

**24-hour time is _not_ a config key** — it's the `--military` CLI flag, baked into the view aliases below. Likewise colours, width, etc. are flags, not config. Run `gcalcli --help` (or `gcalcli <cmd> --help`) for the full flag set.

> A wrong name in `default-calendars` silently hides **every** event — leave it commented unless you've copied a name verbatim from `gcalcli list`.

## Aliases
Wired in `shell/.zshrc` — all `c`-prefixed, `--military` (24h) on the view commands:
```sh
cag      # gcalcli agenda --military           → upcoming (now → a week)
cday     # gcalcli agenda today tomorrow …     → today only (the "day view")
cw       # gcalcli calw --military             → week grid
cm       # gcalcli calm --military             → month grid
cq "…"   # gcalcli quick                       → natural-language add: cq "Dentist Thu 2pm"
cadd     # gcalcli add                         → guided add (prompts title/when/where)
cbrief   # function                            → morning briefing: today's full agenda
         #                                       (recurring included) + cplan's month-ahead one-offs
```

**There is no day-grid view** — gcalcli only grids weeks (`calw`) and months (`calm`). A single day is just agenda scoped to today, which is exactly what `cday` (`agenda today tomorrow`) does.

## Planning view — `cplan`
`cplan` is a `bin/` script (a gcalcli companion) that lists a window of events with the **daily/weekly/biweekly recurring noise hidden** — a month-ahead glance of just the one-offs you'd forget (`cplan`, `cplan --10d-n --30d-p`, …). Full flag set, the compose behaviour, and how the recurrence heuristic works live with the script: **→ [[15-calendar|Calendar scripts (cplan)]]**. The `cbrief` morning briefing above is built on it.

## Why installed
Glancing at and editing the calendar without leaving the terminal — a `gcalcli agenda` in a tmux pane or a shell alias beats opening a browser tab, and `quick` adds an event faster than any GUI. Scriptable too: pipe agenda into a status bar, a `caffeinate`-style "am I free" check, or a morning briefing.

## Biggest win
Natural-language **quick-add** plus zero-context-switch viewing. "What's on today?" and "book this" both become one short command, and because it's plain stdout it composes with everything else in the shell.

## Future use
A `cal`/`ag: ` shell alias for the daily glance; `gcalcli agenda --tsv` piped into a prompt/status-line segment; `gcalcli remind` wired to a notifier for desk alerts. If a non-Google calendar ever enters the mix, re-evaluate against `khal` + `vdirsyncer` rather than bending gcalcli.
