---
title: aero-add
type: reference
status: active
updated: 2026-07-30
description: See and set each app's aerospace workspace + float rule from one picker — the state view over aerospace.toml's on-window-detected blocks, in-place edit and remove, the hand-written-rule guard, and the already-open-windows catch.
tags:
  - project/dotfiles
  - domain/desktop
  - pattern/cli
related:
  - "[[INDEX|Scripts index]]"
  - "[[documentation/09-productivity-desktop/05-aerospace|AeroSpace]]"
---

## Summary
`aero-add` is a **state view** over the `[[on-window-detected]]` rules in `aerospace/aerospace.toml`. The picker lists every running app with its *current* rule in column 3 and its real TOML block in the preview pane; Enter adds, changes, or removes that rule and moves the app's already-open windows; `r` is what reloads aerospace. Daily lookup lives in `ref-desk aerospace rules`.

Read-only entry points: `--list` (every rule, one line each) and `--show <bundle-id>` (one app's block) — neither needs AeroSpace running.

## The pieces

| piece | where | role |
|---|---|---|
| `bin/aero-add` | on PATH | the whole tool — state parse, pickers, in-place write, window catch-up, `r`-triggered reload |
| the state parser | `rules_map()` | one awk pass over the TOML emitting `bundle-id · state · start · end · run-line · zone` per block. `zone` is `gen` (below the marker) or `hand` (above it) — the whole protection model rests on that one field |
| app source | `aerospace list-apps` + `list-windows --all` | every running app is offered; the ones with **no open window** are labelled `hidden` and sorted to the bottom, because `on-window-detected` can never match them. Labelled, not excluded — an app can be windowless now and a valid target later |
| workspace source | `aerospace list-workspaces --all` | validated against, so a typo can't write a dead rule |
| generated block | `aerospace.toml` EOF, under the `aero-add` marker | same marker-delimited pattern as `bin/repo-map.sh`; hand-kept groups above stay hand-kept |
| trigger | `tmux/.tmux.conf` → `bind C-w display-popup` | joins the popup/picker band — `C-b` bookmarks, `C-f` ref-pick, `C-p` clip-drop, `C-g` lazygit |

## Behavior & guards

| case | outcome |
|---|---|
| app has a rule in the **generated** block | its `run =` line is rewritten in place. Never a second rule — only the first match runs, so appending one would be silently ignored |
| app has a **hand-written** rule | interactive: a confirm picker first (`cancel` / `edit it anyway`), and only the `run =` line changes, so surrounding comments and grouping survive. Non-interactive: proceeds, since the call is explicit |
| rule has **extra conditions** (e.g. the kitty window-title regex) | shown with `*` and never rewritten — refuses and prints the block |
| `remove` | deletes the whole block; if that was the last generated rule, the marker header goes too, so an add→remove round-trip returns the file byte-identical |
| target not a real workspace | error, names the listing command |
| AeroSpace not running / `enable off` | error before anything is written (`--list` / `--show` still work) |
| `--dry-run` | prints `now: → would:` and the exact line change, writes nothing |
| picker inherits a global fzf preview | the app picker sets its own `--preview` (`aero-add --show {1}`), which overrides the `bat`/`eza` one in `FZF_DEFAULT_OPTS` (`shell/.zshrc:215`) — that one errors, since a table row is not a path. The target picker uses `--no-preview` |
| popup closed before the result could be read | `bind -EE`, not `-E`: one `-E` closes the popup the instant the command exits, so the summary and any refusal flashed for a single frame. Two `-E` closes **only on success** |
| non-interactive | `aero-add <bundle-id> <floating\|WORKSPACE\|remove> [float]` — no fzf needed, so Raycast or a script can call it |
| app's windows already open | moved/floated explicitly on write — `on-window-detected` fires only for **new** windows, and a `reload-config` does **not** re-apply rules to existing windows, so without this step a written rule appears to do nothing |

### The bug that made "float" not float
The catch-up loop listed windows with `aerospace list-windows --all --app-bundle-id …`. The `--all` alias **conflicts with filtering flags** and exits 2 — and `2>/dev/null || true` hid it. Every run reported `0 open window(s) moved`, and a floating rule left the already-open window tiled no matter how many reloads followed. The correct form is `--monitor all`. `--all` on its own, with no filtering flag (as the app picker uses it), is still fine.

## The form — two toggles, not a menu
The second step is a redrawn form, not a list. The whole decision space is two booleans plus a letter:

```
  Ghostty   com.mitchellh.ghostty

   [ ] float        [x] snaps          1  swap
   [x] workspace    → T                2 or ⌫  remove workspace

   now    →T
   after  →T

   enter  write     r  reload aerospace     d  clear both     q / esc  back
```

| key | does |
|---|---|
| `1` | row 1 — float ⇄ snaps, mutually exclusive |
| `2` | row 2 — set the workspace (the next keypress is the letter), or remove it when one is set |
| **backspace** or `-` | also remove the workspace; float untouched. Inside the letter prompt they abort it and leave none |
| letter/digit | only read as a workspace **inside** the capture step — which is why `1`, `2` and `d` work as commands at all, since `1`, `2` and `D` are themselves workspace names. `-` is safe for the same reason: no workspace is named `-` |
| `d` | clears **both** toggles — the whole rule |
| `enter` | **write the file.** The form stays open; nothing is reloaded |
| `r` | **reload aerospace** — the only thing that makes a written rule live |
| `q` / `esc` | back to the app list, not out of the popup. `q` is instant, `esc` takes ~1s (see below) |
| anything else | a **red hint**, never an exit |

### Nothing reloads on its own
Writing the rule and making it live are separate acts, on purpose. `enter` only touches the file; `r` runs `aerospace reload-config`. Edit several apps, press `r` once at the end. The summary line after a write says `NOT live until r` so the state is never ambiguous.

`enter` keeps the form open (a re-exec with `AERO_ADD_FORM` set, so `now` is re-read from the file just written) precisely so `r` is still reachable afterwards. That also means the reload needs only ONE spelling: plain `r` works in the form, and would not work in the fzf app list, where every printable key goes into the filter box and your app names are full of `r` — Finder, Firefox, Raycast.

**Only the list closes the session.** Every back-out inside one app — cancel, the hand-written `y/n` answered `n`, a `remove` on an app that had no rule — returns to the list with a `↩` note in its header. Esc in the list itself is the single exit. Getting this wrong once (esc at the `y/n` prompt closed the whole popup) is why it routes through one `back_or_exit` helper rather than scattered `exit 0`s.

The loop is a re-exec, not an in-process loop, so the rebuilt list reads the file that was just written and column 3 is never stale. The previous result rides along in the picker header. The cursor is hidden for the whole form and restored on every exit path including `INT`/`TERM`; a non-interactive run never emits the escape at all, so piped output stays clean.


### Why arrows used to close the popup
An arrow key is `ESC [ A`. A one-byte read sees the leading `ESC` and treats it as cancel, so any arrow killed the form. The reader now peeks for a following byte and swallows the whole CSI sequence when it finds one.

The peek needs a timeout, and **it must be an integer**: macOS ships bash 3.2 (no newer bash on this machine), which floors a fractional `-t` to `0` — `-t 0.05` timed out instantly every time, so the peek came back empty and the fix silently did nothing. With `-t 1`, a real Escape pauses one second before cancelling, which is why `q` exists as the instant cancel.

Hints are state-dependent (`2 set workspace` ⇄ `2 or ⌫ remove workspace`) so they can't drift from the behaviour. Three rounds of user feedback shaped it: `d delete rule` read as "deletes everything including the float" (it does — that's `d`'s job, but the workspace-only case had no obvious key); pressing `w` to *un*-set W was unintuitive; and `w` itself collided with W-for-Window in muscle memory, so the toggles became **row numbers**. The bottom row (`enter` / `d` / `q` / `esc`) was kept as-is on the user's call.

**Both toggles off is not a fourth case** — it *is* the aerospace default (tiled, wherever it opens), so that state deletes the rule. `d` is a shortcut for the same thing. The form is seeded from the app's current rule, and the `now → after` lines show the change before it's written.

### Both at once
`run` takes an **array** and its entries execute in sequence, so one rule can assign a workspace *and* float: `run = ["move-node-to-workspace W", "layout floating"]`. Order matters — assign first, float second; floating first and then moving loses the float. One rule, never two, because only the first matching rule runs. Non-interactive form: `aero-add md.obsidian O float`.

**Design note (2026-07-30):** the first cut made this a 34-row fzf list — every workspace as a menu item, plus a `remove` row and a `Ctrl-F` modifier for "and float". The user's own five-line sketch replaced it: two mutually-exclusive toggles and a conditional letter prompt. Scrolling a list to express two booleans was the error.

**Fixed 2026-07-30:** the hand-written Finder rule claimed "floats and still lands on W" in its comment but held a single-element array (`["layout floating"]`) — the W assignment had been dropped in an earlier merge. Restored to the two-element form, which is now the in-repo example of the pattern.

## Verified (2026-07-30)
`bash -n` clean · `--help` served · `--list` parsed all 21 existing rules with correct states, including `→W +float` and the `*` on kitty · `--show` prints the block for a ruled app and a "no rule yet" line otherwise · dry-run correct for new / change / remove / protected · bogus workspace `ZZ` rejected · **live round-trip**: add → change → add a second → remove → remove returned `aerospace.toml` **byte-identical** to its backup, marker header pruned with the last rule, `aerospace reload-config` clean at every step.
