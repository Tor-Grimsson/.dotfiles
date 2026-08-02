---
title: Operations — repo machinery & systems
type: index
status: active
updated: 2026-07-30
description: How this repo itself is built and run — the two-machine model, remote workflow, design explorations — plus systems/, the growing home for every interconnected system the repo operates (agent OS, memory, docs framework, CDN, terminality, repo map).
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|docs root]]"
  - "[[operations/systems/INDEX|systems/]]"
---

# Operations

The **machinery** layer — how the repo itself is built, run, and operated. Not the tool catalog (that's [[documentation/INDEX|documentation/]]).

## systems/ — the interconnected ones

Anything that spans repos, machines or services lives in **[[operations/systems/INDEX|systems/]]** — one folder per system, plain names, no sequencing, added to as the estate grows. Six today: agent-system · claude-memory · claude-harness · docs-framework · cdn · terminality · repo-map.

## This repo's own machinery

| # | Section | What it covers |
|---|---------|----------------|
| 01 | [[operations/01-dotfiles/INDEX|How this repo works]] | The dotfiles repo itself — the two-machine symlink model, and how `bootstrap-cli.sh`/`bootstrap.sh` + `brewfile-cli`/`brewfile-gui` provision a machine (CLI-only for a foreign/SSH box, full for a daily driver). |
| 04 | [[operations/04-remote-machine/INDEX|Remote machine]] | Working over SSH once a box is provisioned — `~/.ssh/config` power features (auto-attach tmux, ControlMaster, ProxyJump, agent forwarding) and alternative tools (mosh/autossh/et/sshrc/sshfs), then the dev workflow on top. |
| 06 | [[operations/06-explorations|explorations]] | Design surveys for things not yet built — the bookmark-sidebar / TUI-plugin exploration (OSC-8 links, yazi bookmark plugins, AeroSpace-window vs tmux-pane); logged so the option survey isn't lost. |
| 07 | [[operations/07-ponytail-fork/INDEX|Ponytail fork]] | The ponytail plugin (4.8.1) evaluated for forking — full inventory from disk, the two-hook mode mechanics, the keep/cut/rename fork plan, and the MIT provenance that makes it clean. |
| 08 | [[operations/08-research/INDEX\|Research]] | Tool **surveys** — what exists, what each actually does, and the install command, for tools considered but not installed. 06 explores things to *build*; 08 surveys things to *install*. |

Numbers 02/03/05 moved into `systems/` on 2026-07-30 (claude-harness · docs-framework · cdn); the gaps are left rather than renumbering live links.

## Related
- [[INDEX|docs root]] — top-level router
- [[documentation/INDEX|documentation/]] — the tool catalog & guides
