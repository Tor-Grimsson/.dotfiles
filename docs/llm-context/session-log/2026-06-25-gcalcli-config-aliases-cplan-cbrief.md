# Session: gcalcli setup + tracked config + c-aliases + cplan planning script + cbrief

**Date:** 2026-06-25
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Walked the user through the one-time gcalcli OAuth setup (authed live on the iMac), then tracked a gcalcli config, added c-prefixed aliases, and built `bin/cplan` — a Python planning view that hides daily/weekly/biweekly recurring noise — plus a `cbrief` morning-briefing function. Corrected two wrong facts in the gcalcli doc along the way, and reorganized the script's docs to match the repo convention (script writeup → `12-scripts/`, tool doc points out).

## Changes Made

### Files Modified / Created
- `gcalcli/config.toml` — **new** tracked config. Schema is tiny (`[auth]` / `[calendars]` / `[output] week-start` only — verified against gcalcli's `config-schema.json`). Set `week-start = "monday"`; `default-calendars` / `ignore-calendars` left commented (a wrong name silently hides every event). Symlinked **live** to `~/Library/Application Support/gcalcli/config.toml` and confirmed gcalcli reads it (`gcalcli list` OK).
- `bootstrap.sh` — gcalcli single-file symlink block (after aerospace). Only `config.toml` is linked, **not** the whole dir — the OAuth token lives beside it (`…/gcalcli/oauth`) and is machine-local.
- `shell/.zshrc` — `c`-prefixed aliases `cag` / `cday` / `cw` / `cm` / `cq` / `cadd` (`--military` 24h on the view commands), plus the `cbrief` **function** (today's full agenda incl. recurring, then `cplan --30d-p` one-offs).
- `bin/cplan` — **new** Python script (bash 3.2 has no assoc arrays). Non-prefixed (callable as `cplan`, like `tor-search`). Flags `--Nd-{p,n,bp}` that **compose** into one asymmetric range (`--10d-n --30d-p` = -10d→+30d), `-a/--all` global, `-h`. Executable, self-check passed.
- `docs/01-shell-terminal/14-gcalcli.md` — **fixed two wrong facts**: config path is `~/Library/Application Support/gcalcli/` on macOS (not `~/.config`), and `military = true` / `monday = true` are **not** config keys (military is the `--military` CLI flag; week start is `week-start = "monday"`). Added Aliases section, day-view note, a short cplan pointer, `cbrief`, fixed the token path in the secrets note, reciprocal `related:`.
- `docs/12-scripts/15-calendar.md` — **new** script doc: full `cplan` home (flags, compose, the recurrence heuristic, maintenance) + `cbrief` cross-ref.
- `docs/12-scripts/INDEX.md` — Calendar row (`_(none)_ | Calendar | 1`) + non-prefixed footnote. (The `bucket-` row in this file came from the user/linter, not this session.)

### Features Added
- gcalcli authed on the iMac (token cached machine-local).
- `cplan` recurring-noise filter — see below.
- `cbrief` morning briefing.

## Current State

### Working
- gcalcli live on the iMac: `gcalcli list` / `agenda` work; the tracked config loads.
- `cplan` verified live across all directions: `--30d-p` (5 ev, 2 hidden), `--10d-n --30d-p` (8 ev, 3 hidden), `--14d-bp`, `--30d-n`, default, `-a`. Self-check green: id parsing, weekly/biweekly→hide, monthly/lone→keep, compose/window/label math.
- `cbrief` renders both sections in zsh (cyan headers).

### How the cplan filter works (design note)
gcalcli won't expose the RRULE, so frequency is inferred from the event **id**: Google tags each recurring *instance* with a trailing `_YYYYMMDD[THHMMSSZ]` on a shared base id; one-offs don't. `cplan` groups by base, measures the inter-instance gap, and drops any series recurring **≤ 15 days** apart (`GAP_SKIP_DAYS`, daily/weekly/biweekly). Monthly+ and one-offs stay; a lone recurring instance stays (can't measure frequency). Robust because one-offs never share a base id.

### Known Issues
- Aliases + `cbrief` need a new shell (or `source ~/.zshrc`) to go live; `cplan` already works.
- The ≤15d filter is a heuristic, not the RRULE — a ~3-weekly series (21d) is kept, by design.

## Next Steps
1. **MBP:** `brew bundle` (installs `gcalcli` + the prior `mdcat`), then `bootstrap.sh` to install the config symlink + the post-commit docs hook; then create the OAuth client + `gcalcli init` per machine (token is local, not synced).
2. Optional: per-direction `-a` on `cplan` (hide recurring on one side only) — deferred as low-value; build only if asked.
3. Root catalog count unchanged at **77** — gcalcli was already counted; `cplan` is a `bin/` script (tracked in the scripts INDEX), not a root-catalog tool.
