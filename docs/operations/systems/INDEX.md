---
title: Systems — the interconnected ones
type: index
status: active
updated: 2026-07-30
description: One folder per system that spans repos, machines or services — agent OS, agent memory, the Claude harness config, the docs framework, CDN buckets, terminality, the repo map, and the cross-repo lobby queue. Plain names, no sequencing; the shelf grows as the estate does.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[operations/INDEX|Operations]]"
  - "[[INDEX|docs root]]"
---

# Systems

A **system** here = something that spans more than one repo, machine or service, and therefore has no natural home inside any single one of them. The knowledge lives here in dotfiles; the thing itself lives wherever it runs.

No `NN-` prefixes on these folders — the shelf is deliberately sized to grow, and ordering by number would just churn. Files *inside* each system keep their numbering.

| System | Tracks | Where the thing lives |
|---|---|---|
| [[operations/systems/agent-system/INDEX\|agent-system]] | the agent operating system — init · context economy · journaling · memory · plans · docs framework · human tier · behavior · routing · naming | source repo `kol-dumpty/jabberwocky`; muzzle half in `kol-dumpty/humpty` |
| [[operations/systems/claude-memory/INDEX\|claude-memory]] | the shared agent-memory design — per-repo `.kol/llm-memory/`, the global tier, write-path symlinks | every repo + `kol-glass` as the lens |
| [[operations/systems/claude-harness/INDEX\|claude-harness]] | this repo's Claude config — agent-context protocol, skills, subagents, hooks, MCP | `claude/` → symlinked to `~/.claude/` |
| [[operations/systems/docs-framework/INDEX\|docs-framework]] | the kol-docs spec + scaffolding skills every repo's `docs/` conforms to | `claude/packages/`, applied in every repo |
| [[operations/systems/cdn/INDEX\|cdn]] | CDN bucket trees + drift — B2 `website`/`vault-media`, R2 `kol-media` | Backblaze B2 · Cloudflare R2 |
| [[operations/systems/terminality/INDEX\|terminality]] | the terminal-as-workstation initiative — cockpit, workspaces, the daily ritual, connected reach | the whole desk: tmux · nvim · aerospace · widgets |
| [[operations/systems/repo-map/INDEX\|repo-map]] | what every repo IS and how they connect — the map, the ASCII wiring diagram, drift against reality | `~/dev/projects/*` (29 repos) |
| [[operations/systems/lobby/INDEX\|lobby]] | the cross-repo ticket system — a `lobby/` inbox per repo, one ledger law, the `lobby-*` skills and `bin/lobby` | `lobby/` in dotfiles · humpty · kol-website · kol-ds-ui |
| [[operations/systems/headless-agents/INDEX\|headless-agents]] | **DRAFT** — running Claude without you: triggers (launchd `QueueDirectories`/`WatchPaths`, `entr`), the `claude -p` contract, use cases, and the safety floor | nothing wired yet; design only |

## The rule that keeps this honest

Each system documents the **map and the machinery** here; each repo keeps its **own depth** in its own `docs/`. Nothing is written twice — [[operations/systems/claude-memory/03-kol-glass-vault|kol-glass]] then makes both greppable in one vault.
