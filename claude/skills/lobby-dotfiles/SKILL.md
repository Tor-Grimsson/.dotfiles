---
name: lobby-dotfiles
description: Port the current conversation into the dotfiles lobby as a tracked ticket — a script, config, ref-card, shell or desk issue found while working in another repo, carried over with its evidence. Writes the entry, the ledger row and the history line in one pass. Use on /lobby-dotfiles, or when the user says "file that against dotfiles", "that's a dotfiles issue", "log it for the tooling repo".
---

# lobby-dotfiles — this conversation → the dotfiles queue

The tooling lobby. A script that lies, a ref card gone stale, a nav command pointing at a dead path, a keybind that double-fires, a config drift — found *anywhere*, filed *here*, because dotfiles is where it gets fixed.

**Destination:** `~/.dotfiles/lobby/inbox/`
**Ledger:** `INDEX.md` at that lobby's root.

## Steps

1. **Name the ask, not the symptom.** "Point `/ag-init` at the docs index", not "agent didn't read docs". The title is what someone scanning the ledger sees.
2. **Collect the evidence from this session** — the exact file and line, the command run, the output, and what it cost. A reader who wasn't here must be able to reproduce it.
3. **Size it.** One sentence: "two files, one sentence each" or "new script + a tmux bind". This is the `Change:` line, and it's what makes a queue triageable.
4. **Slugify** — kebab-case naming the ask: `agent-init-docs-index.md`, `g-nav-dead-targets.md`.
5. **Write `lobby/inbox/<slug>.md`** in the shape below.
6. **Append the INDEX row** at 🔵 `filed` + a dated `History` line. Same pass.
7. **Write the receipt in THIS repo** — `lobby/outbox/<same-slug>.md`, plus its row under **Filed elsewhere** in this repo's own ledger. Same pass again. The ticket now exists at both ends: when dotfiles closes it, its closer writes back into that stub, and `/ag-init` reports it here at boot. Current repo has no `lobby/` → skip it and say so. Shape: `04-conventions.md` § A receipt.
8. **Report** what landed, where, and that it is **not** started.

## Entry shape

```markdown
# <the ask, one line>

**Staged:** YYYY-MM-DD · from a <repo> session
**Change:** <how big it is>

---

## The problem, in one case
<the concrete failure with its cost. Not a category — the actual thing
 that went wrong, with paths and line numbers.>

## The fix
<what to do. Name files and lines wherever you can.>

## Rejected alternative
<what you considered and why it lost. Stops the next reader
 re-proposing it.>

## Definition of done
- [ ] <checkable>
- [ ] <checkable>
```

## What belongs here

`bin/` scripts · shell functions and aliases · `ref/` cards · tmux, nvim, aerospace, ghostty, yazi, broot configs · the docs vault in `~/.dotfiles/docs/` · hooks and skills that live in `claude/` · the Brewfile.

**What doesn't:** agent *behaviour* → `/lobby-humpty`. Site content → `/lobby-web`. Components and tokens → `/lobby-ds`.

## The bar for closing

🟢 `closed` when **the user confirms**. Append `## ✅ RESOLUTION — <date>` to the entry, move it to `done/`, update the ledger, **and return the receipt** to the repo named in the entry's `from a <repo> session` line — naming the remainder, or `none`. All in the same turn as the work.

## Do not

- Do not set a state above `filed`. Filing is not fixing.
- Do not start the work. This is an inbox; the user picks what gets built.
- Do not file without a ledger row — an entry with no row is invisible.
- Do not file without a receipt — a ticket the filing repo has no record of is that same invisibility, one repo over.

Protocol: `~/.dotfiles/docs/operations/systems/lobby/02-lifecycle.md` · card: `ref-lobby`.
