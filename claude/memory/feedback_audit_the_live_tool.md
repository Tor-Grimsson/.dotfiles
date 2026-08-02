---
name: audit-the-live-tool
description: Before auditing a tool's config, verify it's the tool actually in use — don't anchor on the first config found
metadata:
  type: feedback
---

Before auditing or fixing any tool's configuration (terminal, editor, multiplexer), confirm it's the one the user actually runs. A config existing on disk is not evidence it's live.

**Why:** 2026-07-29 — audited the iTerm2 profile as "the terminal layer" of a keybind audit; the user runs Ghostty (daily) and Kitty (widgets). One collision row and one claim were void. The evidence was already in view (aerospace rules, `.zshrc` comments naming Ghostty) and got skipped. Related: [[no-change-means-full-audit]].

**How to apply:** At the start of any tool-layer audit, establish the live tool first (running processes, aerospace/OS rules, config comments, or ask), then audit that tool's config — and say which tool the findings are scoped to.
