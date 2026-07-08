---
title: kol-dash
type: index
status: active
updated: 2026-07-05
description: The umbrella for "kol-dash" — a wake-up automation system (theme + Focus + Spotify + Telegram) and the three separate things that have all been called "the dashboard," plus the plan for an always-on iPad kiosk view.
tags:
  - project/dotfiles
  - domain/automation
  - domain/dashboard
related:
  - "[[INDEX|tooling catalog]]"
  - "[[18-appearance|Appearance & wake automation]]"
  - "[[17-kol-dashboard-cli|Dashboard CLI]]"
---

# kol-dash

Two things share the "kol-dash" name and get confused for each other: an **automation system** (this repo's theme/alarm scripts) and **"the dashboard"** — which turns out to actually be three separate, real things, not one. This category maps all of it so the next session doesn't re-discover the same landscape.

## In this category

| Doc | Covers |
|---|---|
| [[01-automation\|Automation]] | The Raycast + `launchd` wiring — how a hotkey or a clock time turns into a theme flip, a Focus mode, Spotify, a Telegram nudge |
| [[02-process\|Process]] | The wake-up bundle's design and escalation phasing (what's built vs. brainstormed) |
| [[03-dashboard-systems\|Dashboard systems]] | The three things called "dashboard" — what each actually is, what's real vs. mock, how they relate |
| [[04-ipad-kiosk\|iPad kiosk]] | The plan for an always-on browser view on the old iPad — what's ready, what's a genuine open safety question |

**Scripts themselves are not re-documented here** — `os-mode.sh` / `theme-alarm.sh` already have a full per-flag reference at [[18-appearance|12-scripts/18-appearance]], the established one-doc-per-family catalog every other `bin/` script uses. Duplicating that here would just be two places to keep in sync; this category links to it instead.

## The three "dashboards" — one-line disambiguation

| Name | What it actually is | Lives in |
|---|---|---|
| **Obsidian `kol-dashboard` plugin** | An Obsidian plugin — kanban, tracks, pinned notes, socials/growth, week view. Terminal twins: `kol-kb` / `kol-dash` | `kol-vault` repo (`.obsidian/plugins/kol-dashboard/`) |
| **kol-studio's `Dashboard.jsx`** | A real React page — Tasks, Projects, Calendar (live `gcalcli`), Capture (live Todoist/Obsidian-inbox/calendar), Metrics (live, queries self-hosted Umami's Postgres directly) | `kol-studio` repo (`app/src/pages/Dashboard.jsx`) |
| **`_kol-dashboard`** | An empty, abandoned directory — 0 files, not even git-initialized. Not a thing. | `dev/projects/_kol-dashboard` (dead) |

See [[03-dashboard-systems|Dashboard systems]] for the full breakdown (what's live vs. mock per widget) and [[04-ipad-kiosk|iPad kiosk]] for what's now built: a nav-safe `/kiosk` route and an R2 bucket-browser tab, both verified live in `kol-studio`.
