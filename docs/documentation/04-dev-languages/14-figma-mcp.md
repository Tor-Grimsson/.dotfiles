---
title: Figma MCP server
type: reference
status: active
updated: 2026-08-05
description: Figma's official MCP server — bidirectional since the February 2026 Code-to-Canvas launch. Agents read design context and write native Figma layers. Remote is the useful one; the desktop variant is read-only.
aliases:
  - figma
  - figma-mcp
  - use_figma
tags:
  - domain/dev
  - domain/ai/llm
  - integration/claude-plugin
links:
  docs: https://developers.figma.com/docs/figma-mcp-server/
  write: https://developers.figma.com/docs/figma-mcp-server/write-to-canvas
  setup: https://help.figma.com/hc/en-us/articles/39888612464151-Claude-Code-and-Figma-Set-up-the-MCP-server
covers:
  - Remote vs desktop server, and why only one of them writes
  - The seat/plan gates, including the Full-seat wall on writing
  - The tool surface, and what the REST API still cannot do
related:
  - "[[13-framer-agent|framer-agent]]"
  - "[[12-ponytail|ponytail]]"
---

## Summary
Figma's official MCP server gives an agent read **and write** access to a Figma file — writing arrived February 2026 with **Code to Canvas**. The remote server at `https://mcp.figma.com/mcp` is the one that matters; the local desktop server is read-only.

**Not installed here** as of 2026-08-05. This doc is the decision record, not a config note.

## Dependencies

| Need | Kind | Detail |
| --- | --- | --- |
| Figma account, **Full seat** | Account | Required to *write*. A Dev seat reads only. Also needs edit permission on the target file |
| `figma@claude-plugins-official` | Install | One `claude plugin install`. No binary, no daemon, no Brewfile line |
| OAuth authorization | Browser step | Runs once from `/plugin`; no token stored in the repo |
| Figma desktop app | Download | **Desktop server only** — and that variant cannot write, so it is the lesser path |

Nothing here is a Brewfile change. The remote path downloads nothing.

## Config & setup

1. Install the plugin:
   ```sh
   claude plugin install figma@claude-plugins-official
   ```
2. Restart Claude Code.
3. `/plugin` → **Installed** → select `figma` → authorize in the browser → **Allow access**.
4. Desktop variant instead (read-only, needs the app running with MCP enabled in Dev Mode):
   ```sh
   claude mcp add --transport http figma-desktop http://127.0.0.1:3845/mcp
   ```

## The three surfaces

| Surface | Reads | Writes design | Gate |
| --- | --- | --- | --- |
| **Remote MCP** `mcp.figma.com/mcp` | Yes | **Yes** — frames, components, variants, variables, auto layout | Connects on all seats/plans · writing needs a **Full seat** + file edit permission |
| **Desktop MCP** `127.0.0.1:3845/mcp` | Yes | No | Figma desktop app running, Dev Mode on · Dev or Full seat, paid plans |
| **REST API** | Metadata, node properties, image renders | **No** — cannot create nodes | Personal token or OAuth; org-wide plan access tokens went GA 2026-07-23 |

## Tools

| Tool | Does |
| --- | --- |
| `use_figma` | The write tool — creates native Figma structure on the canvas. Remote only |
| `generate_figma_design` | Captures live web UI into Figma layers. Remote only, subset of clients |
| `get_design_context` | Design context for a layer or selection |
| `get_variable_defs` | Variables and styles used in the selection |
| `get_metadata` | Sparse XML of the selection — ids, names, types, position, size |
| `get_screenshot` | Screenshot of the selection |
| `get_code_connect_map` / `add_code_connect_map` | Figma node id ↔ code component mapping |
| `create_design_system_rules` | Writes a rules file so agents translate designs consistently |

## Not gated to Figma's own agent — gated by allowlist

Any agent can use it, but only clients in Figma's MCP catalog may connect: **Claude Code**, Claude Desktop, Cursor, VS Code, Codex, Copilot CLI, Warp, Augment, Factory, Firebender, Xcode 27 beta. New clients join by waitlist.

## Biggest win
The alternative to this is describing a canvas to the agent by hand. `use_figma` closes the loop the other way too — code-generated UI lands in Figma as editable layers rather than a screenshot.

## Gotchas

- **Write is free beta today, usage-based paid later.** Do not build a workflow that assumes it stays free.
- **The REST API is not a back door.** Its 2026 changelog adds read-side design properties (Jan), oEmbed (Mar), AI usage metering (Jun), plan access tokens (Jul) — nothing that creates canvas content. The Plugin API is the only other write path and it runs inside Figma.
- **`Figma.app` is installed on this machine but appears in neither brewfile.** Catalog drift, found 2026-08-05, not corrected.

## Future use
If Figma work actually runs from here, the decision is which server: remote for anything that writes, desktop only if an org policy forbids the hosted endpoint. This is the fourth Claude Code integration in this category (with ponytail, framer-agent, and humpty counted separately) — the dedicated catalog category `12-ponytail` flagged is now overdue.
