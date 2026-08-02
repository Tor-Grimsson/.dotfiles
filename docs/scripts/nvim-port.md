---
title: nvim-port
type: reference
status: active
updated: 2026-07-29
description: Open a path as a new tab in the tmux session's running nvim — socket plumbing (zshrc wrapper + /tmp/nvim-<session>.sock), the statusline badge, and the port command.
tags:
  - project/dotfiles
  - domain/shell
  - pattern/cli
related:
  - "[[INDEX|Scripts index]]"
  - "[[scripts/ref-system/01-system|ref]]"
---

## Summary
`nvim-port [path]` opens a path (arg, or clipboard when bare) as a **new tab in the nvim already running in this tmux session**, then focuses that pane. Daily lookup lives in `ref-nvim porting` — this doc is the system record.

## The pieces

| piece | where | role |
|---|---|---|
| shell wrapper `nvim()` | `shell/.zshrc` | first nvim per tmux session gets `--listen /tmp/nvim-<session>.sock` silently; extra instances start plain; stale sockets (crash leftovers) auto-removed via a liveness probe |
| the socket | `/tmp/nvim-<session>.sock` | the instance's address — a unix socket, created at start, gone at exit; nothing is stored anywhere |
| statusline badge | `nvim/lua/grim/plugins/lualine.lua` (`socket_badge`) | shows `nvim-<session>` in lualine_x when the instance is the addressable one; blank = not addressable |
| `bin/nvim-port` | on PATH | resolves the session socket, `--remote-tab`s the path, focuses the nvim pane (best-effort) |

## Behavior & guards

| case | outcome |
|---|---|
| bare `nvim-port` | path from `pbpaste`, whitespace-trimmed, `~` expanded |
| path doesn't exist | error — guards against porting clipboard garbage |
| outside tmux | error |
| no addressable nvim in the session | error with hint (open nvim first) |
| second nvim in the same session | starts plain (unaddressed) — only the first listens |

## Verified (2026-07-29)
Live headless test: listen → liveness probe → `--remote-tab` → target showed `2 tabs` with the ported buffer active; badge regex extracts `nvim-dotfiles` from the socket path.
