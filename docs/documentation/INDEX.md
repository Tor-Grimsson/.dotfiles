---
title: Documentation — tool catalog & guides
type: index
status: active
updated: 2026-07-09
description: The repo's subject matter — one reference doc per installed tool, plus multi-chapter guides. Content only; repo machinery lives in operations/.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|docs root]]"
---

# Documentation

The **content** layer — what this setup *is about*. One `reference` doc per installed tool, grouped by function, plus standalone multi-chapter guides. Repo machinery (how the repo itself is built and run) lives in [[operations/INDEX|operations/]].

Two cross-cutting axes live in **tags**, not folders:
- **Interface** — `pattern/cli` · `pattern/tui` · `pattern/gui` · `pattern/library`
- **Install method** — `integration/brew-formula` · `integration/brew-cask` · `integration/mac-app-store`

## Categories

| # | Category | Tools | What lives here |
|---|----------|:-----:|-----------------|
| 01 | [[documentation/01-shell-terminal/INDEX|Shell & Terminal]] | 24 | terminal emulators (iTerm2, Ghostty), multiplexers, prompt (starship), zsh plugins, clipboard, sysinfo, process monitor, cheat-sheets (tldr), calendar (gcalcli), markdown renderers (glow/mdcat), image renderer (chafa), kanban (kanban-tui), tmux session/project managers, git worktree pairing (workmux), shell-history search (atuin), vi-mode (zsh-vi-mode) |
| 02 | [[documentation/02-file-management/INDEX|File Management]] | 15 | tree view, TUI/GUI managers, renamers, archiver + modern CLI core (eza/bat/fd/rg/fzf/zoxide/dust) + yazi preview backends (7-Zip/resvg) |
| 03 | [[documentation/03-dedup-cleanup/INDEX|Dedup & Cleanup]] | 6 | duplicate finders, app uninstallers, file recovery |
| 04 | [[documentation/04-dev-languages/INDEX|Dev & Languages]] | 10 | editors, JS/Python runtimes & managers, jq, containers, LLM client, Claude Code plugin (ponytail) |
| 05 | [[documentation/05-network-security/INDEX|Network & Security]] | 8 | scanners, throughput, antivirus, password vault, SSH |
| 06 | [[documentation/06-media-av/INDEX|Media & A/V]] | 8 | player, transcoders, downloader, torrents, speech-to-text, text-to-speech, terminal music (mpd + rmpc) |
| 07 | [[documentation/07-pdf-images/INDEX|PDF & Images]] | 4 | image toolkit, PDF↔image/SVG, clipboard PNG |
| 08 | [[documentation/08-screen-capture/INDEX|Screen Capture]] | 3 | screen recorders, keystroke overlay |
| 09 | [[documentation/09-productivity-desktop/INDEX|Productivity & Desktop]] | 6 | launcher, system monitor, notes, dev browser, tiling window manager, menu bar (SketchyBar) |
| 10 | [[documentation/10-fonts/INDEX|Fonts]] | 2 | Nerd Font, font viewer |
| 11 | [[documentation/11-cloud-sync/INDEX|Cloud & Sync]] | 1 | rclone |
| 12 | [[documentation/12-terminal-browsers/INDEX|Terminal Browsers]] | 3 | Carbonyl (full Chromium via Docker), Chawan (CSS TUI), w3m (text-mode) |
| 13 | [[documentation/13-documents/INDEX|Documents & Publishing]] | 4 | markdown→print converter (pandoc), PDF engines (typst/weasyprint), watch (entr) |
| 17 | [[documentation/17-git/INDEX|Git]] | 3 | git the tool, the GitHub CLI (gh), the lazygit TUI, and the parallel-agent worktree workflow |

## Guides
Standalone multi-chapter guides (not per-tool reference docs, so they don't add to the tool count).

| # | Guide | Chapters | What it covers |
|---|-------|:--------:|----------------|
| 14 | [[documentation/14-supabase/INDEX|Supabase, from zero]] | 9 | Beginner guide to Supabase/Postgres for the `kol-lightroom` project — databases, API keys, migrations, git sync, data in/out, pitfalls. |
| 15 | [[documentation/15-cloudflare/INDEX|Cloudflare, from zero]] | 5 | Beginner guide to Cloudflare R2 (object storage), Pages (static hosting + Functions), and Wrangler (CLI). |
| 16 | [[documentation/16-version-management/INDEX|Version management]] | 4 | Why a globally-installed runtime drifts and breaks projects (the kol-monorepo Node-26 case), per-project pinning, the managers, shell-rc mechanics, and the **fnm** setup. |
| 18 | [[documentation/18-tui-shell-layout/INDEX|TUI shell layout]] | 3 | Terminal-cockpit customization — the fastfetch shell-home greeting (chafa portrait logo), tmuxinator dashboard layouts, and a tmux bookmark system (paths + URLs). |
| 19 | [[documentation/19-google-cloud/INDEX|Google console, from the trenches]] | 1 | Navigating Google's consoles — the two separate billing systems (Workspace vs Cloud), the org-vs-personal billing-account gotcha, the `authuser` trap, direct links, and the kolkrabbi.io footprint. |

## Related
- [[INDEX|docs root]] — top-level router (documentation · operations · siblings)
- [[operations/INDEX|operations/]] — repo machinery & repo-built systems
