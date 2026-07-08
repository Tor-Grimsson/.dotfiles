---
title: kanban-tui
type: reference
status: active
updated: 2026-06-25
verified: 2026-06-25
description: Customizable kanban/todo board in the terminal (Textual TUI) with a CLI, an MCP server, and SQLite/Jira/Claude backends.
aliases:
  - kanban-tui
  - ktui
tags:
  - domain/productivity
  - pattern/tui
  - pattern/cli
  - integration/uv
links:
  website: https://github.com/Zaloog/kanban-tui
  repo: https://github.com/Zaloog/kanban-tui
  manual: https://github.com/Zaloog/kanban-tui/blob/main/README.md
  pypi: https://pypi.org/project/kanban-tui/
covers:
  - install via uv + the `ktui` short alias
  - the TUI board, the CLI subcommands, and where data lives
  - MCP server + Claude-Code-skill integration
related:
  - "[[14-gcalcli|gcalcli]]"
  - "[[../04-dev-languages/04-uv|uv]]"
---

## Summary
A **kanban board in the terminal** (Textual TUI) — columns (default Ready / Doing / Done / Archive), cards you create/edit/move by keyboard or drag-and-drop, multi-board with task dependencies, plus monthly/weekly/daily charts. Beyond the TUI it ships a **CLI** (script boards/tasks), an **MCP server** (so an agent can read/write the board), and a `--web` mode. Backends: **SQLite** (default, local), **Jira**, or **Claude**.

Launch the TUI with `kanban-tui` or the short alias **`ktui`**.

## Setup
A **uv tool**, not a Brewfile line (like [[09-llm|llm]]).
1. Install: `uv tool install kanban-tui` (see [[04-uv|uv]]).
2. Run: `ktui` — first launch creates the config + SQLite db (paths below).
3. (Optional) try it risk-free: `kanban-tui demo` — temporary db + config, nothing touched.

## Use
```sh
ktui                      # open the board TUI (alias for kanban-tui)
kanban-tui --web          # host the board locally in a browser (needs textual-serve)
kanban-tui demo           # throwaway demo board (temp db/config)
kanban-tui info           # print the config / data / skill xdg paths
kanban-tui task   ...     # CLI: manage tasks (create/edit/list/move)
kanban-tui board  ...     # CLI: manage boards
kanban-tui column ...     # CLI: manage columns
kanban-tui category ...   # CLI: manage categories
kanban-tui mcp            # start the MCP server (agent read/write access)
kanban-tui skill ...      # manage the Claude-Code skill it can register
```
In the TUI, `?` shows the keybindings; cards move between columns by keyboard or drag.

## Data & config
XDG dirs, all **machine-local** (not the repo):
- Config: `~/.config/kanban_tui/config.toml`
- Database: `~/.local/share/kanban_tui/kanban_tui.db`
- Auth (Jira/Claude backends): `~/.config/kanban_tui/auth/authentication.toml` — a **secret**, stays out of git (ARCHITECTURE §3).

## Why installed
A lightweight, keyboard-driven todo/kanban that lives in the terminal next to everything else — no browser, no Electron app. The board persists in a local SQLite db, and because it also speaks CLI + MCP it can be driven by scripts or an agent, not just the TUI.

## Biggest win
One tool, three surfaces: the **TUI** for daily use, the **CLI** for scripting, and the **MCP server** so Claude Code can read and update the same board. The kanban state is a plain local SQLite file you own.

## Reproduce on the other machine
`brew bundle` already installs [[04-uv|uv]]. Then:
```sh
uv tool install kanban-tui
```
The board db + config live in the XDG dirs above (machine-local, not synced) — so each machine gets its own board unless you sync the db yourself.

## Future use
Wire the **MCP server** (`kanban-tui mcp`) into Claude Code so the agent can triage the board; register its **skill** (`kanban-tui skill`) under `~/.claude/skills/` if you want slash-command access; or point it at the **Jira** backend if work tasks ever need to live here too.
