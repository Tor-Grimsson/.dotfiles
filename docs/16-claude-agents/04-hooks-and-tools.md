---
title: Hooks & tools
type: reference
status: active
updated: 2026-07-03
description: The wiring around the agent layer — the statusline hook, settings.json config (permissions, plugins, voice/effort/tui), Claude Code plugins (ponytail, rust-analyzer-lsp), and MCP tools (playwright, glif) registered via bootstrap.
aliases:
  - hooks-and-tools
tags:
  - project/dotfiles
  - domain/ai/llm
  - integration/claude-plugin
related:
  - "[[02-skills|skills]]"
  - "[[04-dev-languages/13-ponytail|ponytail]]"
  - "[[16-claude-agents/INDEX|Claude & Agents]]"
---

# Hooks & tools

The harness-executed wiring around the [[02-skills|skills]] and [[03-agents|subagents]]: hooks, plugins, MCP tools, and the `settings.json` config that binds them.

## Hooks

Hooks are shell commands the **harness** runs on lifecycle events (not the agent). This repo has exactly one:

- **`statusLine`** → `hooks/statusline.sh` — renders the prompt status line: ponytail-mode badge · model · `~`-relative cwd · context-window usage · token usage · plan rate-limit (5h session / 7d weekly %, with reset time). Repo-owned (it **replaced** the ponytail plugin's own statusline script); the ponytail badge logic is **mirrored** (not sourced) so a plugin update can't silently break it.

`commands/` and `output-styles/` exist (symlinked) but are empty. Automated per-event behaviour (PreToolUse/PostToolUse/Stop/etc.) would be added under `settings.json` `hooks` — none configured today.

## settings.json

| Key | Value / effect |
|---|---|
| `permissions.allow` | read-only Bash allowlist (`ls`, `cat`, `find`, `head`, `tail`, `du`, `file`, `stat`, …) + `mcp__playwright`, `mcp__glif` |
| `permissions.deny` | `Bash(git)` / `Bash(git:*)` — **enforces** ARCHITECTURE §N "the agent never runs git" |
| `statusLine` | the hook above |
| `enabledPlugins` | `ponytail@ponytail`, `rust-analyzer-lsp@claude-plugins-official` |
| `extraKnownMarketplaces` | `ponytail` → GitHub `DietrichGebert/ponytail` |
| `alwaysThinkingEnabled` | `true` |
| `effortLevel` | `xhigh` |
| `tui` | `fullscreen` |
| `voice` | `enabled`, `mode: hold` (push-to-talk) |

## Plugins

Claude Code plugins are enabled in `settings.json` + declared marketplaces:

- **`ponytail`** — the laziness layer; always-on via a SessionStart hook (default mode `full`). Full write-up: [[13-ponytail|ponytail]].
- **`rust-analyzer-lsp`** — official LSP plugin for Rust.

Plugin runtime state (cloned marketplace repos under `~/.claude/plugins/`) is **not** tracked; `bootstrap.sh` reproduces the *intent* (enabled list + marketplace) the same way it does for MCP.

## MCP tools

MCP servers give the agent extra tools. Registration lives in `~/.claude.json` (user scope) — **not** `settings.json`, where `mcpServers` is ignored — so `bootstrap.sh` reproduces them with `claude mcp add --scope user`:

| Server | Command | Notes |
|---|---|---|
| `playwright` | `npx @playwright/mcp --headless` | browser automation (drive/screenshot pages) |
| `glif` | `npx @glifxyz/glif-mcp-server` | GLIF image generation; needs `GLIF_API_TOKEN` exported (open item — not yet wired to the vault→env hookup) |

Account-level **claude.ai-connected** MCPs (Gmail, Calendar, Drive, figma-dev-mode) may appear in a session but are **not** repo-tracked and can be absent in headless/cron runs.

## Related
- [[01-agent-context-protocol|Agent-context protocol]] · [[02-skills|Skills]] · [[03-agents|Subagents]]
