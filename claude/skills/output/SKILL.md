---
name: output
description: The control panel for reply shape. Prints the CURRENT output state — dial level, clamp, every format module and toggle — then asks ONE question about what should change, applies it, and writes the preference to global memory so it survives the session. Use on /output, /reformat, or when the user says the replies are the wrong shape, wants to change how output looks, or asks what layout options exist.
---

# /output — the control panel for reply shape

**One place that answers "what shape are my replies, and how do I change it?"** Everything it
offers already exists — the dial, the clamps, the format modules, the tmpl family. This skill
does not invent format vocabulary; it makes the existing surface visible, changes one thing,
and **remembers the answer**.

The problem it solves: there are six format modules, two toggles, four dial levels, three clamp
rungs and fourteen `tmpl-*` skills, and no single place that shows their current state. The user
has been correcting output shape by hand, one reply at a time, for weeks.

## Steps

### 1. Read the current state — never guess it

| Read | From |
|---|---|
| dial level · turn · nudges · toggles | `$humpty` — run `echo '{"prompt":"$humpty"}' \| bash <repo>/hooks/humpty-track.sh` if the repo has humpty, else say "no dial here" |
| which format modules exist | `docs/documentation/08-formats/INDEX.md` in the humpty repo — **read it, do not recite this file's list** |
| the standing word budget | any `tmpl-wl-*` set this session (it persists until another is set) |
| what is already remembered | `~/.dotfiles/claude/memory/` — `grep -l 'type: feedback' *.md`, and read any whose name touches output shape |

**If a module file and this skill disagree, the module file wins.** It is versioned; this is a
front door.

### 2. Print the state as ONE table

Current value in the middle, how to change it on the right. No prose around it.

```
| Knob | Now | Change with |
|---|---|---|
| dial | strict (3/4) | `$humpty 1..4` |
| where-we-are (module 05) | off | `$humpty where` |
| box table (module 06) | off | `$humpty box` |
| word budget | none standing | `/tmpl-wl-40` … `/tmpl-wl-100` |
| clamp | released | `st` · `stf` · `stfu` |
```

Then list the **layout choices** — the five in
`~/.dotfiles/docs/operations/systems/claude-harness/07-output-formats.md`, one line each:
**1 one-liner · 2 build/change report · 3 findings · 4 recommendation · 5 staged.**

### 3. Ask ONE question — with **AskUserQuestion**, not in prose

**This step is interactive. Use the `AskUserQuestion` tool.** A markdown table of options is not a
question, it is homework — it makes the user type back an answer he could have clicked. Same rule
the `/lobby` router already follows.

**One question, not a survey.** Pick the one the state makes obvious — the knob most likely wrong
for what the user is complaining about, or if he came in cold: *"What is the reply doing that it
should not?"*

Offer at most four options, each `description` naming the knob it moves. Include the
**no-change** option — "it was right" is a real answer and its absence pressures a change nobody
wanted. Never ask two questions in one turn; a second question is a second `/output`.

### 4. Apply it — but NEVER by touching the dial

**The dial is the user's. All of it.** `$humpty <n>`, `$humpty where`, `$humpty box` — this skill
**reads** them and never sets them. ARCHITECTURE §3, and the "What this skill must not do" table
below has always said so.

**Broken on 2026-08-01:** the answer was read as *"turn on the module that carries the proposed
action"* and `$humpty where` was switched on unasked. He turned it straight back off —
*"you dont turn it on, I handle the modules, this is not that."*

| The answer wants | Do |
|---|---|
| a **dial** change (level · `where` · `box`) | hand him the exact command on one line. Stop. Do not run it |
| a **clamp** or word budget | apply it — `st`/`stf`/`stfu` and `tmpl-wl-*` are session shape, not his dial |
| a **rule** change — how replies are written | **build it**: edit the module in `08-formats/`, bump its version, sync the injected law in `skills/laws/SKILL.md`. This is the real work and it needs no toggle |

The third row is the common case and the one to reach for first. *"This is you reading my response
and making FRESH on-the-fly changes and layouts"* — a preference he states is a spec change, not a
switch to flip.

### 5. Write it to memory — the part that makes this worth having

**A preference stated once should never need stating twice.** Write to
`~/.dotfiles/claude/memory/` (global, all repos — not the repo-local memory dir):

```markdown
---
name: <short-kebab-case>
description: <one line — used to decide relevance during recall>
metadata:
  type: feedback
---

<the preference, as a rule the agent can apply>

**Why:** <date> — <what the user said, VERBATIM in quotes> <what it was correcting>

**How to apply:** <the check to run before sending a reply>
```

| Rule | |
|---|---|
| **check for an existing file first** | 34 memories already exist. Update the one that covers it rather than adding a near-duplicate |
| **quote him verbatim** | his own wording is protected class. A paraphrase of a correction is a corrected correction |
| **`feedback_` prefix** | matches the 20 existing feedback memories. `docs-lookup-first.md` is the one exception and predates the convention |
| **link siblings** | `[[feedback_lead_first]]` — recall follows the links |
| **one preference per file** | a memory holding two rules gets half-applied |

**Do not write a memory for a one-off.** A memory is for a preference that will recur. If the
user is fixing this reply only, apply it and stop — say so in one line.

### 6. Report in three lines

What was read · what changed · what was remembered. No recap of the options.

## What this skill must not do

| Never | Because |
|---|---|
| invent a new layout, module or toggle | they live in `08-formats/` and the dial. New ones are a build, not a conversation |
| present a menu of more than four | that is the options-menu failure the doctrine already bans |
| re-emit the previous reply | that is `/claude-bullet`, `/claude-clear` and `/dump` — this changes the *standing* shape, not one reply |
| write to the repo-local memory dir | a shape preference is global. Repo-local memory is for repo facts |
| set the dial without being asked | ARCHITECTURE §3 — the dial is the user's; suggest, never auto-step |

## Neighbours

| Want to | Use |
|---|---|
| fix the reply that just landed | `/claude-bullet` · `/claude-clear` · `/dump` · `/tmpl-stfu` |
| set a standing word budget | `/tmpl-wl-10` … `/tmpl-wl-100` |
| change the standing shape and remember it | **this skill** |
| read the format spec itself | `docs/documentation/08-formats/` in the humpty repo |
