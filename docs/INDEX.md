---
title: Tooling catalog
type: index
status: active
updated: 2026-07-05
description: One reference doc per installed tool (85 tools, 14 categories), each with verified links and a why/use/win/how/future write-up. Routes to every category.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[TOOLING|tooling audit & sync]]"
---

# Tooling catalog

One `reference` doc per tool in this setup — **85 tools across 14 categories**. Each doc carries verified links (website / repo / manual / brew) in frontmatter and a body covering *what it is, why it's installed, the common use case, the biggest win, how to use it, and future use*.

Folders group by **function**. Two cross-cutting axes live in **tags**, not folders, so you can slice either way:
- **Interface** — `pattern/cli` · `pattern/tui` · `pattern/gui` · `pattern/library`
- **Install method** — `integration/brew-formula` · `integration/brew-cask` · `integration/mac-app-store`
- **Vendor** (where clear) — `provider/<vendor>`

## Quick reference
Printable personal reference cards for the daily drivers — not per-tool docs, so they don't add to the tool count. Symlinked into the kol-vault for print.

| # | Card | Covers |
|---|------|--------|
| 00 | [CLI cheatsheet](00-kol-cli/01-cli-cheatsheet.md) | Neovim · tmux · yazi · fzf · AeroSpace keymaps on one page |
| 00 | [Neovim workflows](00-kol-cli/02-nvim-workflows.md) | reshaping & handling text in nvim — edit grammar, wrap/reflow (`gq`/`par`), regex, `:g` filters, worked examples |
| 00 | [Scripts at a glance](00-kol-cli/03-scripts.md) | the `bin/` scripts grouped by job (image/video/audio/PDF/download/files/sync/helpers) |
| 00 | [Git & GitHub](00-kol-cli/04-git-github.md) | git syntax by task, the `gh` layer (PRs/CI/API), worktrees, and the commands that lose work |
| 00 | [Network, remote & secrets](00-kol-cli/05-network-security.md) | SSH (incl. over Tailscale VPN), remote logging, Jellyfin sharing, iperf3, arp-scan/nmap, vault → env |
| 00 | [Tailscale + Jellyfin](00-kol-cli/06-tailscale-jellyfin.md) | what the tailnet/MagicDNS/ACL pieces are, how the `…ts.net:8096` URL is built + changed, CLI, users & devices |
| 00 | [Storage redundancy & backup](00-kol-cli/07-storage-redundancy.md) | RAID vs backup (3-2-1), rsync/rclone/Disk Utility/Time Machine/B2, how sync works, A→Z two-8TB-drive demo |

## Categories

| # | Category | Tools | What lives here |
|---|----------|:-----:|-----------------|
| 01 | [Shell & Terminal](01-shell-terminal/INDEX.md) | 20 | terminal emulator, multiplexers, prompt (p10k), zsh plugins, clipboard, sysinfo, process monitor, cheat-sheets (tldr), calendar (gcalcli), markdown renderers (glow/mdcat), kanban (kanban-tui), tmux session/project managers (sesh vs tmux-sessionx — still evaluating; tmuxinator + tmuxp, kept side by side; tmux-harpoon), git worktree + agent status (workmux, tmux-agent-sidebar) |
| 02 | [File Management](02-file-management/INDEX.md) | 15 | tree view, TUI/GUI managers, renamers, archiver + modern CLI core (eza/bat/fd/rg/fzf/zoxide/dust) + yazi preview backends (7-Zip/resvg) |
| 03 | [Dedup & Cleanup](03-dedup-cleanup/INDEX.md) | 6 | duplicate finders, app uninstallers, file recovery |
| 04 | [Dev & Languages](04-dev-languages/INDEX.md) | 11 | editors, JS/Python runtimes & managers, jq, containers, LLM client, GitHub CLI, Claude Code plugin (ponytail) |
| 05 | [Network & Security](05-network-security/INDEX.md) | 8 | scanners, throughput, antivirus, password vault, SSH |
| 06 | [Media & A/V](06-media-av/INDEX.md) | 7 | player, transcoders, downloader, torrents, speech-to-text, text-to-speech |
| 07 | [PDF & Images](07-pdf-images/INDEX.md) | 4 | image toolkit, PDF↔image/SVG, clipboard PNG |
| 08 | [Screen Capture](08-screen-capture/INDEX.md) | 3 | screen recorders, keystroke overlay |
| 09 | [Productivity & Desktop](09-productivity-desktop/INDEX.md) | 5 | launcher, system monitor, notes, dev browser, tiling window manager |
| 10 | [Fonts](10-fonts/INDEX.md) | 2 | Nerd Font, font viewer |
| 11 | [Cloud & Sync](11-cloud-sync/INDEX.md) | 1 | rclone |
| 12 | [Scripts](12-scripts/INDEX.md) | 36 | `bin/` helpers: au/vid/img/pdf/art/batch/tor/fs/bucket |
| 13 | [Terminal Browsers](13-terminal-browsers/INDEX.md) | 3 | Carbonyl (full Chromium via Docker), Chawan (CSS TUI), w3m (text-mode) |
| 17 | [Documents & Publishing](17-documents/INDEX.md) | 4 | markdown→print converter (pandoc), PDF engines (typst/weasyprint), watch (entr) |

## Guides
Standalone multi-chapter guides (not per-tool reference docs, so they don't add to the tool count).

| # | Guide | Chapters | What it covers |
|---|-------|:--------:|----------------|
| 14 | [Supabase, from zero](14-supabase/INDEX.md) | 9 | Beginner guide to Supabase/Postgres for the `kol-lightroom` project — databases, API keys, migrations, git sync, data in/out, pitfalls. **CLI:** `brew install supabase/tap/supabase`. |
| 15 | [Cloudflare, from zero](15-cloudflare/INDEX.md) | 5 | Beginner guide to Cloudflare R2 (object storage/buckets), Pages (static hosting + serverless Functions), and Wrangler (CLI). Covers the kol-media bucket + admin tool setup at `admin.kolkrabbi.io`. |

## Systems
Repo infrastructure with its own moving parts (scripts + services + data) — **not** a per-tool reference, so it doesn't add to the tool count.

| # | System | What it covers |
|---|--------|----------------|
| 18 | [CDN tree snapshots (r2b2)](18-cdn-r2b2/INDEX.md) | `bucket-tree.sh` snapshots each CDN bucket's file tree (B2 `website`/`vault-media`, R2 `kol-media`) into readable JSON in the dotfiles, refreshed on every write and mirrored to Obsidian + other consumers. |
| 20 | [kol-docs system setup](20-kol-docs-system-setup/INDEX.md) | The `kol-docs-fm`/`-md`/`-lib` skill trio + packages, and the shared Obsidian vault-config source (`claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/`) repos symlink into. |
| 21 | [How this repo works](21-dotfiles/INDEX.md) | The dotfiles repo itself — the two-machine symlink model, and how `bootstrap-cli.sh`/`bootstrap.sh` + `brewfile-cli`/`brewfile-gui` provision a machine (CLI-only for a foreign/SSH box, full for a daily driver). |
| 22 | [Remote machine](22-remote-machine/INDEX.md) | Working over SSH once a box is provisioned — `~/.ssh/config` power features (auto-attach tmux, ControlMaster, ProxyJump, agent forwarding) and alternative tools (mosh/autossh/et/sshrc/sshfs), then the dev workflow on top (nvim clipboard, git/gh auth, secrets with no GUI, two-GitHub-account fork/PR practice). |

## Explorations
Design surveys for something **not yet built** — logged so the option survey isn't lost, not scheduled work. Not counted among the installed tools.

| # | Exploration | What it covers |
|---|--------------|----------------|
| 19 | [kol-tui-plugin — bookmark sidebar](19-kol-tui-plugin/INDEX.md) | Option survey for an always-visible sidebar of bookmarked files/URLs/git worktrees as clickable links — AeroSpace-window vs. tmux-pane layers, OSC-8/iTerm2 command-URLs vs. existing yazi bookmark plugins vs. a custom tmux plugin. |

## Agent layer
The repo's own Claude Code / agent config (`claude/`, symlinked to `~/.claude/` per `ARCHITECTURE.md` §3) — documented as its own section, **not** counted among the installed tools.

| # | Section | What it covers |
|---|---------|----------------|
| 16 | [Claude & Agents](16-claude-agents/INDEX.md) | the agent-context protocol, skills, subagents, hooks, and MCP tools |

## Related
- [Tooling audit & sync](../TOOLING.md) — the drift audit, Brewfile reconciliation, cross-arch portability notes, and open items.

## Maintenance
- Source of truth for *what's installed* is the repo `brewfile-cli` + `brewfile-gui`. When a tool is added/removed there, add/remove its doc here.
- The catalog intentionally runs ahead of the Brewfiles: `[pbcopy & pbpaste](01-shell-terminal/06-pbcopy-pbpaste.md)` is a macOS **built-in**, a few CLIs (`[edge-tts](06-media-av/06-edge-tts.md)` via pipx, `[llm](04-dev-languages/09-llm.md)` + `[kanban-tui](01-shell-terminal/16-kanban-tui.md)` via uv) are **not** Brewfile lines, `[tmux-sessionx](01-shell-terminal/20-tmux-sessionx.md)`, `[tmux-harpoon](01-shell-terminal/22-tmux-harpoon.md)`, and `[tmux-agent-sidebar](01-shell-terminal/25-tmux-agent-sidebar.md)` are TPM plugins (none are Brewfile lines), and `[ponytail](04-dev-languages/13-ponytail.md)` is a **Claude Code plugin** tracked via `bootstrap.sh` + `claude/settings.json`. Don't "fix" the count against the Brewfiles — those mismatches are expected.
- The **supabase** CLI was dropped from the Brewfile 2026-07-04 (unused) — the `[Supabase guide](14-supabase/INDEX.md)` stays as a standalone guide, it never counted toward the tool count anyway.
- Removed 2026-06-04: **tmate** and **qlstephen** (brew was disabling both; uninstall locally with `brew uninstall tmate` and `brew uninstall --cask qlstephen`).
