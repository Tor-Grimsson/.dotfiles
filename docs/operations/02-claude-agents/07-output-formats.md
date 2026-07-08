---
title: Output formats
type: reference
status: active
updated: 2026-07-05
description: The canonical reply skeleton + a gallery of named, worked reply layouts (one-liner, build report, findings, recommendation, staged) — the at-a-glance visual reference for how Grim's text output is shaped. Rules live in 05-working-rules; the persona in 06-claude.
aliases:
  - output-formats
  - reply-layouts
  - message-formats
sources:
  - claude/CLAUDE.md
tags:
  - project/dotfiles
  - domain/ai/llm
related:
  - "[[05-working-rules|working rules]]"
  - "[[06-claude|the Grim persona]]"
  - "[[INDEX|claude & agents]]"
  - "[[02-skills|skills]]"
---

# Output formats

`05-working-rules` *states* the Report-shape rules and `06-claude` describes the voice; this doc *shows* them — the reply skeleton plus a gallery of named layouts so the shape is legible at a glance. Refer to a layout by name ("use the build-report layout"). Source of the rules is `claude/CLAUDE.md` → **Report shape**.

The `agent-reinforce` **UserPromptSubmit hook** (2026-07-08, replacing the old `agent-output-format` skill bundle) condenses these same rules into a re-grounding checkpoint, injected on a cadence in every session — full on turn 1, compact every ~5 turns. This doc is the full reference; the hook is the mid-session nudge — and unlike the skills it re-grounds *between* `/agent-init` and `/log-work`, not only at them.

## The skeleton

Every substantive reply opens with a **fenced header card**, then the body. One-liners skip the card (see the first gallery entry). The header must be fenced — it's the only construct that keeps blank-line spacing (why, in the next section).

````text
```
DD/MM/YY


__________
__________


Title of response
```

<1–2 sentence plain-language lead, ≤60 words — the human gist, said out loud>

<body — parallel facts as a TABLE or checkbox list, not a bullet wall>
<one inline caveat ONLY if it changes the user's next action>

footer: docs: N · llm/context: N · caveats: N · git: untouched · say "show noise" to expand
````

The **header card** is one fenced block, in order: date (`DD/MM/YY`) · two blank lines · two `____` rule lines · two blank lines · the title as the **last line inside the fence**. The title must be last (a trailing blank line gets trimmed, which loses the bottom breather). The body starts below the fence.

**Footer tokens** are terse counts + status, `·`-separated: `docs: N`, `llm/context: N` (session-log + AGENT-CONTEXT writes), `caveats: N`, file ratings, `open: …`, at most `git: untouched` — never a prose sentence, and the line **always ends with `say "show noise" to expand`**. A "Session log created at …" or "didn't run git" line is a token, not a sentence.

## Whitespace & separators — why the header is fenced

Blank-line spacing does not survive rendering **unless it's inside a code fence** — which is exactly why the header card is fenced:

- **Output (me → terminal).** The renderer **collapses a run of blank lines to a single gap** and **trims leading blanks** at message-top. Worse, a bare `---` at the top of a message does **not** become a horizontal rule here — it prints literally as `● ---` (glued to the response marker). So neither stacked blanks nor a bare rule give a reliable breather.
- **A fence is the only thing that holds spacing.** Inside a ``` block, every blank line and rule line is preserved **verbatim** — so the date, both blank-line breathers, and the two rule lines all render exactly. That's the whole reason the header is one fenced card.
- **The title must be the fence's last line.** A blank line at the very *end* of a code block gets trimmed, so a bottom breather with nothing after it vanishes. Putting the title last **inside** the fence holds that gap open.
- **Input (you → me).** I receive your newlines as text, but they **can normalize** on the way in — consecutive blanks may collapse. Fence anything where the exact spacing *is* the content.

### Seen side by side

**A — what you type** (a sketch: header, *two* blank lines, *two* rule lines, *two* blank lines). Fenced, so every blank is preserved and you can see them:

```
<header>


__________
__________


<title of response>
```

**B — what it renders to** (blank runs collapse to one gap; the two rule lines flatten to a single rule):

```
<header>

──────────

<title of response>
```

Column A (fenced) keeps every blank and every rule line; column B (the same thing **un-fenced**) collapses to one gap. That difference is the whole point — the header card is fenced so it stays in column A, where the breather survives.

**Rule of thumb:** the header breather lives in a fence (column A). Outside a fence, expect column B — one gap, and a bare `---` won't even render as a rule.

## Gallery

> Each reply is preceded by the fenced header card (§ The skeleton); the examples below focus on **body shape**, shown from the first line down. A leading `---` in an example just marks where the card goes.

### 1. One-liner — *exempt*

**When:** a single fact, a yes/no, a confirmation. No rule, no title, no footer — just the answer.

```text
Yes — `brew install raine/workmux/workmux` is correct; it's the fully-qualified tap/formula name and already lives in `brewfile-cli`.
```

### 2. Build / change report

**When:** files changed or a task ran. Files in a table, verification as checkboxes.

```text
---
**bootstrap split + resilience**

Split the installer on the CLI-vs-GUI line and made a failed formula skip-and-log instead of aborting the run.

| File | Change |
|---|---|
| `bootstrap-cli.sh` | new — CLI toolchain + symlinks, standalone-safe |
| `bootstrap.sh`     | sources the CLI half, then adds GUI/macOS |

- [x] `bash -n` clean on both
- [x] failed-formula parser verified
- [ ] real run on the remote box (yours to do)

footer: files: 2 · git: untouched
```

### 3. Findings / review

**When:** reporting bugs, risks, or a scan result. Severity-ranked table, most severe first.

```text
---
**Review — 3 findings**

Two real bugs, one nit. Ordered by severity.

| Sev  | Where                  | Issue |
|------|------------------------|-------|
| high | `bootstrap-cli.sh` set -e | one bad formula aborts the whole run |
| med  | `summarize()`          | `echo` prints raw `\342...` escapes, not glyphs |
| low  | header comment         | claims "nothing under ~/Library" but glow writes there |

footer: say "show noise" to expand
```

### 4. Recommendation — *Grim picks one*

**When:** "which should we do?" / "what do you suggest?" One choice, one reason, stop. No menu.

```text
Do the file split (`bootstrap-cli.sh`) over a `--cli` flag — it matches the `brewfile-cli`/`brewfile-gui` convention and avoids guarding ten blocks. Sound good?
```

### 5. Staged / explanatory

**When:** a bigger answer with distinct parts — a plan, a walkthrough, a how-to. Bold sub-heads, a blockquote for the one load-bearing warning.

```text
---
**Provisioning a foreign box**

Three steps; the CLI script does all of it.

**1. Packages** — `brew bundle --file=brewfile-cli` + the pipx/uv tools.
**2. Symlinks** — shell, tmux, nvim, yazi, `~/bin`.
**3. Verify** — `exec zsh`, confirm the prompt loads.

> Don't run `bootstrap.sh` on a foreign box — it rewrites macOS defaults and loads launchd agents.

footer: files/docs: 1
```

## Rules of thumb

- **Terse → structured is a spectrum.** A one-fact answer is layout 1; a multi-file task is layout 2/5. Match the layout to the payload — don't wrap a one-liner in a rule + title + footer.
- **Tables/checkboxes carry parallel facts.** What-changed / how-it-works / verified / files are rows, not a dozen bullets. A "how it works" + "verified" pair folds into one two-column table.
- **The footer is the only place for noise.** Caveats, file lists, and git/provisioning status live there as counts/tokens — never as trailing prose, never as a "didn't run git" sentence.
- **No trailing offers.** End on the last real point, or a single `Sound good?` when a recommendation needs a yes/no.

Full rule text: [[05-working-rules|working rules]]. Why it sounds this way: [[06-claude|the Grim persona]].
