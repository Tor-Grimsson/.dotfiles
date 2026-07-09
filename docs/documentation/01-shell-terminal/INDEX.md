---
title: Shell & Terminal
type: index
status: active
updated: 2026-07-08
description: The terminal emulator, multiplexers, zsh prompt, image renderer, and shell enhancements that make up the command-line environment.
tags:
  - domain/shell
---

The tools that build the day-to-day command-line environment: the terminal app itself, session multiplexing and sharing, the zsh prompt, and the completion/highlighting plugins layered on top.

| Tool | What it is |
| --- | --- |
| [[01-iterm2|iTerm2]] | macOS terminal emulator with split panes, search, and deep customization. |
| [[02-tmux|tmux]] | Terminal multiplexer for persistent sessions, windows, and panes. |
| [[03-powerlevel10k|Powerlevel10k]] | Fast, configurable zsh prompt theme with instant-prompt startup. |
| [[04-zsh-syntax-highlighting|zsh-syntax-highlighting]] | Fish-style live syntax highlighting for the zsh command line. |
| [[05-zsh-completions|zsh-completions]] | Extra tab-completion definitions for tools zsh doesn't cover by default. |
| [[06-pbcopy-pbpaste|pbcopy & pbpaste]] | macOS clipboard from the shell — pipe text in/out; recipes with fzf, jq, git, pngpaste. (built-in) |
| [[07-fastfetch|fastfetch]] | Fast system-info tool printing specs alongside an OS logo. |
| [[08-glow|glow]] | Terminal markdown renderer — open any `.md` as styled, readable text, instantly. |
| [[11-htop|htop]] | Interactive process/resource monitor (TUI) — find and kill whatever's eating CPU or memory. |
| [[12-tldr|tldr (tealdeer)]] | Community cheat-sheets of real per-command examples — the fast antidote to a long man page. |
| [[13-shell-functions|Shell functions]] | Custom one-liners in `.zshrc` — `killport <port>` and future additions. |
| [[14-gcalcli|gcalcli]] | Google Calendar from the terminal — agenda/week/month views, natural-language quick-add, edit and import. |
| [[15-mdcat|mdcat]] | Terminal markdown renderer — clean headings (no `##`), inline iTerm2 images; the yazi `.md` previewer. |
| [[16-kanban-tui|kanban-tui]] | Kanban/todo board in the terminal (Textual TUI) — also a CLI + MCP server; local SQLite. |
| [[17-sesh|sesh]] | Smart tmux session picker — fuzzy-finds sessions, configs, and zoxide directories. Being evaluated against tmux-sessionx. |
| [[18-tmuxinator|tmuxinator]] | Define a project's tmux window/pane layout in YAML, launch it with one command. Kept alongside tmuxp, not a winner. |
| [[19-tmuxp|tmuxp]] | Same idea as tmuxinator, plus `tmuxp freeze` to snapshot an already-running layout — tmuxinator has no equivalent. |
| [[20-tmux-sessionx|tmux-sessionx]] | TPM plugin — fzf popup session manager with live previews and git branch. Being evaluated against sesh. |
| [[21-chafa|chafa]] | Terminal image renderer — turns an image into colored Unicode/braille/sixel; yazi's preview fallback and the fastfetch logo renderer. |
| [[22-tmux-harpoon|tmux-harpoon]] | TPM plugin — bookmark a handful of tmux sessions, jump back with one key. |
| [[24-workmux|workmux]] | Pairs a git worktree with a tmux window in one command — parallel branches/agents, no stashing. |
| [[25-atuin|atuin]] | SQLite-backed shell history with scoped fuzzy search (global/host/session/directory) — takes over fzf's Ctrl-R. |

## Guides
- [[10-tmux-help|tmux help & cheat sheet]] — built-in help commands first, then the keys, shell commands, and workflows you actually use with the [[02-tmux|tmux]] config.
- [[09-tmux-tips|tmux tips & tricks]] — copy mode in full, plus pane/window/session tricks for the [[02-tmux|tmux]] config.
- [[23-stdin-pipes|stdin, stdout & pipes]] — the three standard streams, redirection, pipes, and the `-` convention CLI tools use to mean "read from stdin."
