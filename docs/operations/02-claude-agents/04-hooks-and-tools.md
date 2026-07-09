---
title: Hooks & tools
type: reference
status: active
updated: 2026-07-09
description: The wiring around the agent layer — the statusline / doc-sync / reinforce / footer-gate hooks, settings.json config (permissions, plugins, voice/effort/tui), Claude Code plugins (ponytail, rust-analyzer-lsp), and MCP tools (playwright, glif) registered via bootstrap.
aliases:
  - hooks-and-tools
tags:
  - project/dotfiles
  - domain/ai/llm
  - integration/claude-plugin
related:
  - "[[02-skills|skills]]"
  - "[[12-ponytail|ponytail]]"
  - "[[operations/02-claude-agents/INDEX|Claude & Agents]]"
---

# Hooks & tools

The harness-executed wiring around the [[02-skills|skills]] and [[03-agents|subagents]]: hooks, plugins, MCP tools, and the `settings.json` config that binds them.

## Hooks

Hooks are shell commands the **harness** runs on lifecycle events (not the agent). Four are wired — one statusline + three behavioural, all global (dotfiles), so they apply in every repo:

- **`statusLine`** → `hooks/statusline.sh` — renders the prompt status line: ponytail-mode badge · model · `~`-relative cwd · context-window usage · token usage · plan rate-limit (5h session / 7d weekly %, with reset time). Repo-owned (it **replaced** the ponytail plugin's own statusline script); the ponytail badge logic is **mirrored** (not sourced) so a plugin update can't silently break it.
- **`PostToolUse(Edit|Write)`** → `hooks/doc-sync-reminder.sh` (2026-07-08) — after an edit, if the file is declared in a doc's `sources:` frontmatter (in the current repo's `docs/documentation/`), reminds the agent to update that doc the same turn. Precise (fires only for tracked files), fail-open. No-ops in repos without a `docs/documentation/` tree. **Blind spot:** it checks the *current* repo's docs, so editing dotfiles docs from another repo's session isn't caught.
- **`UserPromptSubmit`** → `hooks/agent-reinforce.sh` (2026-07-08) — injects report-shape + standing-rules + no-git reinforcement on a cadence (full on turn 1, compact every ~3 turns), keyed by session_id; text in `hooks/reinforce-{full,compact}.txt`. **Replaced** the old 4-skill `agent-reinforce` bundle (`agent-output-format` + `-rules` + `-memory` + the bundler); re-grounds mid-session, which the skills couldn't. This is *soft* — it fires at turn start and drifts by turn end, which is why the footer rule also gets a hard Stop gate:
- **`Stop`** → `hooks/footer-gate.sh` (2026-07-09) — HARD gate on the end-of-message footer discipline. When a reply finishes it reads the last assistant message from the transcript and **blocks** (forces a re-emit) if the trailing lines break the rule: content after the footer line, a trailing offer ("want me to…"), or a bare status/recap line ("X untouched", "created/updated at") sitting in the last ~8 lines instead of folded into the footer. Loop-safe (respects `stop_hook_active` → blocks at most once per stop-chain), fail-open, and exempts one-liners + anything inside the footer line itself. Born 2026-07-09 after the soft reminder repeatedly failed to stop trailing summaries.

`commands/` and `output-styles/` exist (symlinked) but are empty.

## settings.json

| Key | Value / effect |
|---|---|
| `permissions.allow` | read-only Bash allowlist (`ls`, `cat`, `find`, `head`, `tail`, `du`, `file`, `stat`, …) + `mcp__playwright`, `mcp__glif` |
| `permissions.deny` | `Bash(git)` / `Bash(git:*)` — **enforces** ARCHITECTURE §N "the agent never runs git" |
| `statusLine` | the statusline hook above |
| `hooks` | `PostToolUse(Edit\|Write)` → doc-sync-reminder · `UserPromptSubmit` → agent-reinforce · `Stop` → footer-gate (all above) |
| `enabledPlugins` | `ponytail@ponytail`, `rust-analyzer-lsp@claude-plugins-official` |
| `extraKnownMarketplaces` | `ponytail` → GitHub `DietrichGebert/ponytail` |
| `alwaysThinkingEnabled` | `true` |
| `effortLevel` | `xhigh` |
| `tui` | `fullscreen` |
| `voice` | `enabled`, `mode: hold` (push-to-talk) |

## Plugins

Claude Code plugins are enabled in `settings.json` + declared marketplaces:

- **`ponytail`** — the laziness layer; always-on via a SessionStart hook (default mode `full`). Full write-up: [[12-ponytail|ponytail]].
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
