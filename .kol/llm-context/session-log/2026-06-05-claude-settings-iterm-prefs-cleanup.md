# Session: claude settings.json cleanup + iTerm prefs drift fix

**Date:** 2026-06-05
**Agent:** Grim (Claude Opus 4.8)
**Summary:** Stripped 6 dead keys from `claude/settings.json` (validated against the official schema), re-registered the MCP servers in their correct home, and fixed the iTerm custom-folder setup that was silently auto-saving live state into the repo plist on every quit.

## Changes

- `claude/settings.json` — removed `mcpServers` (ignored in settings.json — user-scope MCP lives in `~/.claude.json`), `theme`, `voiceEnabled`, `agentPushNotifEnabled`, `skipAutoPermissionPrompt`, `skipWorkflowUsageWarning` (last three aren't real settings).
- glif + playwright registered via `claude mcp add --scope user` (glif keeps `${GLIF_API_TOKEN}` expansion); same two lines added to `bootstrap.sh` for reproducibility.
- iTerm: save-mode flipped to **Manually** (was auto-save → repo plist drifted on every quit, the "fighting defaults" cause); fresh deliberate snapshot exported to `iterm/`; default window arrangement saved + `OpenArrangementAtStartup` patched true; verified `NoSync*` save-mode keys pinned in `bootstrap.sh` (they don't travel in the snapshot).
- Pre-push secret scan of all dirty files incl. the plist: clean.

## Next steps

1. Export `GLIF_API_TOKEN` via the vault-to-env pattern (`docs/05-network-security/08-vault-to-env-pattern.md`) — glif MCP fails auth until then.
2. iTerm loop from now on: change setting → Save Now → commit. Repo plist never moves on its own.
