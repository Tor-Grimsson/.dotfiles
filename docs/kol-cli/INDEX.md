---
title: kol-cli — cheat cards
type: index
status: active
updated: 2026-07-08
description: Printable personal reference cards for the daily drivers — cross-cutting quick reference spanning both content and machinery. Symlinked into the kol-vault for print.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|docs root]]"
---

# kol-cli

Printable cross-cutting cheat cards for the daily drivers — not per-tool docs (those live in [[documentation/INDEX|documentation/]]), but one-page references spanning tools and workflow. Symlinked into the kol-vault for print.

| # | Card | Covers |
|---|------|--------|
| 01 | [[kol-cli/01-cli-cheatsheet|CLI cheatsheet]] | Neovim · tmux · yazi · fzf · AeroSpace keymaps on one page |
| 02 | [[kol-cli/02-nvim-workflows|Neovim workflows]] | reshaping & handling text in nvim — edit grammar, wrap/reflow (`gq`/`par`), regex, `:g` filters, worked examples |
| 03 | [[kol-cli/03-scripts|Scripts at a glance]] | the `bin/` scripts grouped by job (image/video/audio/PDF/download/files/sync/helpers) |
| 04 | [[kol-cli/04-git-github|Git & GitHub]] | git syntax by task, the `gh` layer (PRs/CI/API), worktrees, and the commands that lose work |
| 05 | [[kol-cli/05-network-security|Network, remote & secrets]] | SSH (incl. over Tailscale VPN), remote logging, Jellyfin sharing, iperf3, arp-scan/nmap, vault → env |
| 06 | [[kol-cli/06-tailscale-jellyfin|Tailscale + Jellyfin]] | what the tailnet/MagicDNS/ACL pieces are, how the `…ts.net:8096` URL is built + changed, CLI, users & devices |
| 07 | [[kol-cli/07-storage-redundancy|Storage redundancy & backup]] | RAID vs backup (3-2-1), rsync/rclone/Disk Utility/Time Machine/B2, how sync works, A→Z two-8TB-drive demo |

## Related
- [[INDEX|docs root]] — top-level router
- [[documentation/03-dedup-cleanup/INDEX|Dedup & Cleanup]] · [[scripts/INDEX|scripts]] — deeper per-tool / per-script detail
