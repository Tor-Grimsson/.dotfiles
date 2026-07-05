---
title: Shell & Terminal
type: index
status: active
updated: 2026-07-04
description: The terminal emulator, multiplexers, zsh prompt, and shell enhancements that make up the command-line environment.
tags:
  - domain/shell
---

The tools that build the day-to-day command-line environment: the terminal app itself, session multiplexing and sharing, the zsh prompt, and the completion/highlighting plugins layered on top.

| Tool | What it is |
| --- | --- |
| [iTerm2](01-iterm2.md) | macOS terminal emulator with split panes, search, and deep customization. |
| [tmux](02-tmux.md) | Terminal multiplexer for persistent sessions, windows, and panes. |
| [Powerlevel10k](03-powerlevel10k.md) | Fast, configurable zsh prompt theme with instant-prompt startup. |
| [zsh-syntax-highlighting](04-zsh-syntax-highlighting.md) | Fish-style live syntax highlighting for the zsh command line. |
| [zsh-completions](05-zsh-completions.md) | Extra tab-completion definitions for tools zsh doesn't cover by default. |
| [pbcopy & pbpaste](06-pbcopy-pbpaste.md) | macOS clipboard from the shell — pipe text in/out; recipes with fzf, jq, git, pngpaste. (built-in) |
| [fastfetch](07-fastfetch.md) | Fast system-info tool printing specs alongside an OS logo. |
| [glow](08-glow.md) | Terminal markdown renderer — open any `.md` as styled, readable text, instantly. |
| [htop](11-htop.md) | Interactive process/resource monitor (TUI) — find and kill whatever's eating CPU or memory. |
| [tldr (tealdeer)](12-tldr.md) | Community cheat-sheets of real per-command examples — the fast antidote to a long man page. |
| [Shell functions](13-shell-functions.md) | Custom one-liners in `.zshrc` — `killport <port>` and future additions. |
| [gcalcli](14-gcalcli.md) | Google Calendar from the terminal — agenda/week/month views, natural-language quick-add, edit and import. |
| [mdcat](15-mdcat.md) | Terminal markdown renderer — clean headings (no `##`), inline iTerm2 images; the yazi `.md` previewer. |
| [kanban-tui](16-kanban-tui.md) | Kanban/todo board in the terminal (Textual TUI) — also a CLI + MCP server; local SQLite. |
| [sesh](17-sesh.md) | Smart tmux session picker — fuzzy-finds sessions, configs, and zoxide directories. Being evaluated against tmux-sessionx. |
| [tmuxinator](18-tmuxinator.md) | Define a project's tmux window/pane layout in YAML, launch it with one command. Kept alongside tmuxp, not a winner. |
| [tmuxp](19-tmuxp.md) | Same idea as tmuxinator, plus `tmuxp freeze` to snapshot an already-running layout — tmuxinator has no equivalent. |
| [tmux-sessionx](20-tmux-sessionx.md) | TPM plugin — fzf popup session manager with live previews and git branch. Being evaluated against sesh. |
| [tmux-harpoon](22-tmux-harpoon.md) | TPM plugin — bookmark a handful of tmux sessions, jump back with one key. |
| [workmux](24-workmux.md) | Pairs a git worktree with a tmux window in one command — parallel branches/agents, no stashing. |
| [tmux-agent-sidebar](25-tmux-agent-sidebar.md) | TPM plugin — live sidebar of every AI coding agent's status across all sessions/windows. |

## Guides
- [tmux help & cheat sheet](10-tmux-help.md) — built-in help commands first, then the keys, shell commands, and workflows you actually use with the [tmux](02-tmux.md) config.
- [tmux tips & tricks](09-tmux-tips.md) — copy mode in full, plus pane/window/session tricks for the [tmux](02-tmux.md) config.
- [stdin, stdout & pipes](23-stdin-pipes.md) — the three standard streams, redirection, pipes, and the `-` convention CLI tools use to mean "read from stdin."
