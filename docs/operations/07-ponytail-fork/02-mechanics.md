---
title: 07.02 · Mechanics — how ponytail actually works
type: explainer
status: active
updated: 2026-07-28
description: The two-hook loop — SessionStart injects the mode-filtered skill text, UserPromptSubmit tracks /ponytail commands into a state file — and why the plugin form beats a plain skill for this job.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[07-ponytail-fork/INDEX|ponytail fork]]"
  - "[[07-ponytail-fork/01-inventory|inventory]]"
---

# Mechanics

```
  session boot (startup|resume|clear|compact)
      │
      ▼
  SessionStart hook ── node ponytail-activate.js
      │        reads ~/.claude/.ponytail-active  (mode: lite|full|ultra|review…)
      │        ponytail-instructions.js builds the text:
      │          skills/ponytail/SKILL.md → filtered for the active mode
      ▼
  "PONYTAIL MODE ACTIVE — level: full" + the ladder, injected as context

  every user prompt
      │
      ▼
  UserPromptSubmit hook ── node ponytail-mode-tracker.js
               parses /ponytail [lite|full|ultra|off…] (also @ponytail, $ponytail)
               writes the mode to ~/.claude/.ponytail-active → next boot re-injects
```

## The clever parts (worth keeping in any fork)

- **Single source of truth:** the injected text is *built from* `skills/ponytail/SKILL.md`, filtered per mode — the skill and the injection can't drift.
- **State survives sessions:** one flag file; `/ponytail ultra` today is still ultra tomorrow. The SessionStart matcher covers `clear` and `compact`, so the mode survives context resets too.
- **Fail-open everywhere:** no node → `exit 0`; BOM-stripping before JSON.parse; 5-second timeouts.
- **Why a plugin, not a skill:** skills only load when invoked; this needs to fire at *every boot* and *every prompt* — that's hook territory, and plugins are how hooks + skills + state ship as one unit.

## Comparison with our own behavior stack

Same architecture as the jabberwocky 08-behavior module — persona states law, hooks re-assert it — with one difference: ponytail's cadence layer *rebuilds* its payload from the skill per mode, where our reinforce hook reads static `.txt` payloads. The rebuild trick is the main thing worth stealing back.
