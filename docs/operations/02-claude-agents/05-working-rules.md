---
title: Working rules
type: reference
status: active
updated: 2026-07-05
description: The rule-sections in claude/CLAUDE.md — "Grim", the global personality + working rules Claude Code loads every session. A section map + change log; CLAUDE.md is the source text.
aliases:
  - claude-md
  - working-rules
  - grim
sources:
  - claude/CLAUDE.md
tags:
  - project/dotfiles
  - domain/ai/llm
related:
  - "[[06-claude|the Grim persona]]"
  - "[[07-output-formats|output formats]]"
  - "[[INDEX|claude & agents]]"
  - "[[01-agent-context-protocol|agent-context protocol]]"
---

# Working rules

`claude/CLAUDE.md` is **"Grim"** — the global personality + working rules symlinked to `~/.claude/CLAUDE.md` and loaded into every Claude Code session (repo-backed, `ARCHITECTURE.md` §3). This doc **maps** its sections and logs changes; the file itself is the source text — edit `claude/CLAUDE.md`, keep this map in sync.

## Sections

| Section | Gist |
|---|---|
| Tone | direct, no preamble, no honorifics, pick-one |
| Answering | never options menus (save genuine forks); answer direct questions first; execute clear instructions |
| Report shape | open with a **fenced header card** (date + breather + title in one ``` fence — the only construct that keeps blank-line spacing; a bare `---` renders as literal `● ---`), then a 1–2 sentence plain-language summary; body in scan shape, **tables/checkboxes first** for parallel facts; fold caveats/files/noise, **git-provisioning status**, and session-log/AGENT-CONTEXT writes (`llm/context: N`) into one footer line that **always ends with `say "show noise" to expand`** (no prose "created at …" restatement); rate files `[n/5]`; no trailing offers |
| Terminology | KOL, not DS |
| Working on code | smallest change; verbatim user-facing text; no auto text-transform; Tailwind-first |
| Architecture & scope | long-term over patch; respect existing structure; kill redundancy |
| Debugging | isolate the broken path before fixing; profile before guessing |
| Running things | no reflexive build/dev; **never run git unless asked** |
| Session logs | never log unprompted; terse |
| Repo hygiene | no artifacts at repo root; gitignore `_tmp/` |
| Docs in kol-system projects | conform to `docs/_framework/` (frontmatter, archetypes, wikilinks) |

## Changes

- **2026-07-04** — added **Report shape**: bullet/scan replies by default, caveats/files folded into a `say "show noise"` footer, file ratings `[n/5]`. Talk-form is a separate axis from ponytail (build-form).
- **2026-07-04** — Report shape refined: **lead every report with a 1–2 sentence plain-language summary** (the human gist) before the structured body — don't skip straight to bullets.
- **2026-07-05** — Report shape: **open every reply with a fenced header card** — date + a two-blank/two-rule/two-blank breather + the title, all in one ``` fence, title as the last line inside it. A fence is the only construct this terminal renders with real blank-line spacing: a bare `---` opener prints as literal `● ---`, and blank lines flatten outside a fence (learned across a live back-and-forth this session). Also: **tables/checkboxes first** for parallel facts (what-changed / how-it-works / verified fold into one table, not a dozen bullets); **git/provisioning status is not a talking point** — drop the "didn't run git / nothing installed" line, at most a `git: untouched` footer token. Footer is ONE line **always ending in `say "show noise" to expand`**; session-log + AGENT-CONTEXT writes fold to a `llm/context: N` token — no "Session log created at …" restatement line.
