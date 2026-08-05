---
title: framer-agent
type: reference
status: active
updated: 2026-08-03
description: Framer's official external-agent bridge — two Claude Code skills that give the agent direct access to a Framer project's canvas, components, CMS and analytics without an MCP server.
aliases:
  - framer
  - framer-agent
tags:
  - domain/dev
  - domain/ai/llm
  - integration/claude-plugin
links:
  setup: https://www.framer.com/agents/external/
  docs: https://www.framer.com/help/articles/how-to-set-up-framer-for-claude-code-codex-and-cursor/
covers:
  - What the two skills do and when each loads
  - Why it is skills-not-MCP, and what that changes
  - Install, telemetry opt-out, and the vendored-file rule
related:
  - "[[12-ponytail|ponytail]]"
  - "[[14-figma-mcp|Figma MCP server]]"
---

## Summary
`@framer/agent` is Framer's **official external-agent bridge** (v0.0.42). It installs two skills that let Claude Code read and edit a Framer project directly — layouts, sections, text and images, CMS collections, code components, colour and text styles, localisation, analytics, and publishing deployments. It is not a plugin and not a CLI you keep running: the setup command writes skill files and exits.

## Why installed
Framer work otherwise means describing the canvas to the agent by hand, or wiring an MCP server. This removes both. The skill triggers on any mention of Framer or "my website", so the agent picks it up without being told which tool to use.

## Most common use case

| Skill | Loads when |
| --- | --- |
| `framer` | The entry point — any Framer or website-editing ask. Reads the project's generated task map |
| `framer-code-components` | **Only after** `framer` has loaded and its Components row has been read. Never the entry point |

The second skill's own frontmatter enforces that order. Loading it directly is a documented mistake, not a shortcut.

## Biggest win
No MCP server to run, configure or keep alive. The bridge is plain markdown skills plus a per-project task map, so it costs nothing when idle and there is no daemon to fail.

## Config & setup
- **Not a Brewfile tool, and not a plugin either.** Install/reproduce:
  ```sh
  npx @framer/agent setup
  ```
  It writes to **two** locations: `~/.agents/skills/` (other agents, untracked) and `~/.claude/skills/` — which is the symlink into this repo, so the skills land in `claude/skills/` and **are tracked**.
- **Vendored — never hand-edit.** Re-running setup overwrites both skill dirs. Treat them the way `gsap-*` is treated: tracked so a fresh machine gets them from `bootstrap.sh` rather than a re-install, but upstream owns the contents.
- **No credentials in the repo.** Verified 2026-08-03: `projects/` holds only `__template__`, and every `projectId`/`token` string is API documentation, not a value. A real project's map is generated per-project at use time.
- **Telemetry is on by default.** Opt out with:
  ```sh
  npx @framer/agent telemetry disable
  ```
- The MBP gets these on its next dotfiles pull — no re-install needed, since the skills are tracked.

## Future use
If a Framer project is actually driven from here, the generated `projects/<id>/index.md` task map becomes the thing to read first — note whether it should be gitignored once it carries a real project id. Also: this is now the second Claude Code integration in this category (with ponytail) and the third counting humpty, which suggests the split into a dedicated catalog category that `12-ponytail` already flagged.
