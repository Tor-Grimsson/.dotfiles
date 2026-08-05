---
title: llm-pick
type: reference
status: active
updated: 2026-08-04
description: Ask Claude from a tmux popup — an fzf menu over the llm CLI's five real modes (ask, continue, chat, pipe the clipboard, model override), bound to prefix Ctrl+L.
tags:
  - project/dotfiles
  - domain/ai/llm
  - pattern/cli
related:
  - "[[INDEX|Scripts index]]"
  - "[[documentation/04-dev-languages/09-llm|llm]]"
  - "[[nvim-port|nvim-port]]"
---

## Summary
`llm-pick` puts the [[documentation/04-dev-languages/09-llm|llm CLI]] behind an fzf menu in a tmux popup, so a quick question costs a keystroke instead of a pane. Daily lookup is `ref-llm` — this doc is the system record.

| command | does | needs |
|---|---|---|
| `prefix Ctrl+L` | open the popup (60%×60%) | tmux, fzf, `llm` |
| `llm-pick` | same menu, in the current pane | fzf, `llm` |
| `llm-pick --help` | modes + gotchas | — |

## Setup
1. `llm` on PATH — `uv tool install llm` then `llm install llm-anthropic` (see [[documentation/04-dev-languages/09-llm|llm]]). The script refuses with a one-line message if either `llm` or `fzf` is missing.
2. `prefix r` to reload tmux — the bind is inert until then.

## Modes

| mode | runs | for |
|---|---|---|
| `ask` | `llm "…"` | a one-shot question on the default model (Haiku 4.5) |
| `continue` | `llm -c "…"` | keep going from the last exchange |
| `chat` | `llm chat` | the interactive REPL, inside the popup |
| `clipboard` | `pbpaste \| llm "…"` | ask *about* whatever you just copied — an error, a diff, a config block |
| `model` | `llm -m <model> "…"` | one-off override, model picked from a second fzf list |

Answers page through `less -R`; `q` returns to the menu, `Esc` at the menu closes the popup. Empty input aborts back to the menu rather than sending a blank prompt.

**A question typed straight at the menu is answered as an `ask`** (2026-08-04). The menu's fzf prompt reads `llm > `, which looks like an input box and is a filter — a typed question matched no mode row, fzf exited 1, and `display-popup -E` shut the popup with nothing on screen. `--print-query` now returns the typed text on line 1, and only `Esc` (rc 130) closes.

## Why this shape
It copies the popup band already in `tmux/.tmux.conf` — `clip-drop.sh --menu` (`prefix Ctrl+P`), `ref-pick` (`prefix Ctrl+F`), `aero-add` (`prefix Ctrl+W`). Same idea each time: fzf picks, a `bin/` script runs, Esc walks back out. Nothing new was invented here.

`prefix Ctrl+L` was free. The bare `C-l` on `.tmux.conf:240` is `bind-key -n` — pane navigation, no prefix — so the two never meet.

## Gotchas

| gotcha | fact |
|---|---|
| `continue` always works | every `llm` exchange logs to SQLite regardless of flags, so there is always a thread to continue (`llm logs path`) |
| pipe vs `-c` | piping feeds **content** into one prompt; `-c` continues **conversation memory**. Different things — see the llm doc |
| model aliases use dots | `claude-haiku-4.5`, not `claude-haiku-4-5` |
| key is not in the repo | it lives in llm's own config dir; a fresh machine re-runs the four setup steps |
| never export `ANTHROPIC_API_KEY` | on a machine running Claude Code it silently bills the API instead of the subscription |
