---
title: Terminal Browsers
type: index
status: active
updated: 2026-06-10
description: Web browsing inside the terminal — full Chromium rendering via Docker, a CSS-capable TUI browser, and a classic text-mode browser.
tags:
  - domain/web
---

Browsers that run in the terminal instead of a window: Carbonyl renders the real modern web (JS, CSS, video) straight to terminal cells via Docker/OrbStack; Chawan does standalone CSS layout with JS/images as opt-in toggles; w3m is the instant text-mode fallback and pipe-friendly HTML renderer.

| Tool | What it is |
| --- | --- |
| [Carbonyl](01-carbonyl.md) | Chromium fork rendering the full web in the terminal, run via Docker/OrbStack. |
| [w3m](02-w3m.md) | Classic text-mode browser — instant, no JS, dumps rendered pages to stdout. |
| [Chawan](03-chawan.md) | Modern TUI browser (`cha`) — CSS layout standalone, JS/images/cookies as runtime toggles. |
