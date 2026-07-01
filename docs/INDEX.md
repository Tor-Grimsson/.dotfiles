---
title: Tooling catalog
type: index
status: active
updated: 2026-06-25
description: One reference doc per installed tool (78 tools, 13 categories), each with verified links and a why/use/win/how/future write-up. Routes to every category.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[TOOLING|tooling audit & sync]]"
---

# Tooling catalog

One `reference` doc per tool in this setup — **78 tools across 13 categories**. Each doc carries verified links (website / repo / manual / brew) in frontmatter and a body covering *what it is, why it's installed, the common use case, the biggest win, how to use it, and future use*.

Folders group by **function**. Two cross-cutting axes live in **tags**, not folders, so you can slice either way:
- **Interface** — `pattern/cli` · `pattern/tui` · `pattern/gui` · `pattern/library`
- **Install method** — `integration/brew-formula` · `integration/brew-cask` · `integration/mac-app-store`
- **Vendor** (where clear) — `provider/<vendor>`

## Quick reference
Printable personal reference cards for the daily drivers — not per-tool docs, so they don't add to the tool count. Symlinked into the kol-vault for print.

| # | Card | Covers |
|---|------|--------|
| 00 | [[00-kol-cli/01-cli-cheatsheet\|CLI cheatsheet]] | Neovim · tmux · yazi · fzf · AeroSpace keymaps on one page |
| 00 | [[00-kol-cli/02-workflows\|CLI workflows]] | keystroke recipes — editing text blocks in nvim, navigating/moving/opening in yazi |
| 00 | [[00-kol-cli/03-scripts\|Scripts at a glance]] | the `bin/` scripts grouped by job (image/video/audio/PDF/download/files/sync/helpers) |
| 00 | [[00-kol-cli/04-git-github\|Git & GitHub]] | git syntax by task, the `gh` layer (PRs/CI/API), worktrees, and the commands that lose work |
| 00 | [[00-kol-cli/05-network-security\|Network, remote & secrets]] | SSH (incl. over Tailscale VPN), remote logging, Jellyfin sharing, iperf3, arp-scan/nmap, vault → env |
| 00 | [[00-kol-cli/06-tailscale-jellyfin\|Tailscale + Jellyfin]] | what the tailnet/MagicDNS/ACL pieces are, how the `…ts.net:8096` URL is built + changed, CLI, users & devices |
| 00 | [[00-kol-cli/07-storage-redundancy\|Storage redundancy & backup]] | RAID vs backup (3-2-1), rsync/rclone/Disk Utility/Time Machine/B2, how sync works, A→Z two-8TB-drive demo |

## Categories

| # | Category | Tools | What lives here |
|---|----------|:-----:|-----------------|
| 01 | [[01-shell-terminal/INDEX\|Shell & Terminal]] | 13 | terminal emulator, multiplexers, prompt (p10k), zsh plugins, clipboard, sysinfo, process monitor, cheat-sheets (tldr), calendar (gcalcli), markdown renderers (glow/mdcat), kanban (kanban-tui) |
| 02 | [[02-file-management/INDEX\|File Management]] | 15 | tree view, TUI/GUI managers, renamers, archiver + modern CLI core (eza/bat/fd/rg/fzf/zoxide/dust) + yazi preview backends (7-Zip/resvg) |
| 03 | [[03-dedup-cleanup/INDEX\|Dedup & Cleanup]] | 6 | duplicate finders, app uninstallers, file recovery |
| 04 | [[04-dev-languages/INDEX\|Dev & Languages]] | 11 | editors, JS/Python runtimes & managers, jq, containers, LLM client, GitHub CLI, Claude Code plugin (ponytail) |
| 05 | [[05-network-security/INDEX\|Network & Security]] | 8 | scanners, throughput, antivirus, password vault, SSH |
| 06 | [[06-media-av/INDEX\|Media & A/V]] | 7 | player, transcoders, downloader, torrents, speech-to-text, text-to-speech |
| 07 | [[07-pdf-images/INDEX\|PDF & Images]] | 4 | image toolkit, PDF↔image/SVG, clipboard PNG |
| 08 | [[08-screen-capture/INDEX\|Screen Capture]] | 3 | screen recorders, keystroke overlay |
| 09 | [[09-productivity-desktop/INDEX\|Productivity & Desktop]] | 5 | launcher, system monitor, notes, dev browser, tiling window manager |
| 10 | [[10-fonts/INDEX\|Fonts]] | 2 | Nerd Font, font viewer |
| 11 | [[11-cloud-sync/INDEX\|Cloud & Sync]] | 1 | rclone |
| 12 | [[12-scripts/INDEX\|Scripts]] | 33 | `bin/` helpers: au/vid/img/pdf/art/batch/tor/fs |
| 13 | [[13-terminal-browsers/INDEX\|Terminal Browsers]] | 3 | Carbonyl (full Chromium via Docker), Chawan (CSS TUI), w3m (text-mode) |

## Guides
Standalone multi-chapter guides (not per-tool reference docs, so they don't add to the tool count).

| # | Guide | Chapters | What it covers |
|---|-------|:--------:|----------------|
| 14 | [[14-supabase/INDEX\|Supabase, from zero]] | 9 | Beginner guide to Supabase/Postgres for the `kol-lightroom` project — databases, API keys, migrations, git sync, data in/out, pitfalls. **CLI:** `brew install supabase/tap/supabase`. |
| 15 | [[15-cloudflare/INDEX\|Cloudflare, from zero]] | 5 | Beginner guide to Cloudflare R2 (object storage/buckets), Pages (static hosting + serverless Functions), and Wrangler (CLI). Covers the kol-media bucket + admin tool setup at `admin.kolkrabbi.io`. |

## Related
- [[TOOLING|Tooling audit & sync]] — the drift audit, Brewfile reconciliation, cross-arch portability notes, and open items.

## Maintenance
- Source of truth for *what's installed* is the repo `Brewfile`. When a tool is added/removed there, add/remove its doc here.
- The catalog intentionally runs ahead of the `Brewfile`: `[[01-shell-terminal/06-pbcopy-pbpaste|pbcopy & pbpaste]]` is a macOS **built-in**, a few CLIs (`[[06-media-av/06-edge-tts|edge-tts]]` via pipx, `[[04-dev-languages/09-llm|llm]]` + `[[01-shell-terminal/16-kanban-tui|kanban-tui]]` via uv) are **not** Brewfile lines, and `[[04-dev-languages/13-ponytail|ponytail]]` is a **Claude Code plugin** tracked via `bootstrap.sh` + `claude/settings.json`. Don't "fix" the count against the Brewfile — those mismatches are expected.
- The **supabase** CLI *is* in the Brewfile (`supabase/tap/supabase`) but is documented as the `[[14-supabase/INDEX|Supabase guide]]` (a guide, not a per-tool reference doc) — so it doesn't add to the 78-tool count either.
- Removed 2026-06-04: **tmate** and **qlstephen** (brew was disabling both; uninstall locally with `brew uninstall tmate` and `brew uninstall --cask qlstephen`).
