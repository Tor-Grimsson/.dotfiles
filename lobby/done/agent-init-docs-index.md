# Point `/ag-init` + `/agent-init` at the docs index

**Filed:** 2026-07-31 · from a kol-ds-ui session
**Change:** two files, one sentence each. No new hook, no new skill.

---

## The problem, in one case

I spent a session editing layout code in `kol-ds-ui` — shell frame widths, rail
insets, padding — and derived every rule from grepping the source. The rules
were already written, in docs I never opened:

- `docs/documentation/01-foundations/04-layout-breakpoints.md`
- `docs/documentation/01-foundations/05-layout-systems.md`
- `docs/documentation/08-breakpoints/04-kol-ds-rules.md`

Cost of not reading them: I proposed re-adding a width token that had been
**deliberately deleted** for the exact reason I was proposing it, and proposed
fixing a rail-width mismatch in the wrong direction. The user caught both.

The boot path is why. `/ag-init` loads `.kol/` only — ARCHITECTURE, AGENT-CONTEXT,
the newest session log, the newest handoff. Every one of those is the repo's
**history and current state**. None of them is the repo's **laws**. So an agent
boots knowing what happened and not knowing what is true.

## The fix

Read the docs index at boot. Not the docs — the **index**. The agent doesn't need
the content; it needs to know the material exists, roughly what's in it, and that
grepping `docs/` will surface the rule before it improvises one.

`docs/documentation/INDEX.md` is already exactly that: one table, 9 sections,
every doc named and linked, with its live counterpart. In kol-ds-ui it is 32
lines. Row 01 reads *"foundations — tokens · color · typography · layout &
breakpoints · layout systems registry"*. That one line would have stopped the
whole failure.

## The edit

Identical in both files — they are the same skill under two names:

- `~/.dotfiles/claude/skills/ag-init/SKILL.md`
- `~/.dotfiles/claude/skills/agent-init/SKILL.md`

**Step 3, line 26.** Currently:

```
3. Read `<ctx>/AGENT-CONTEXT.md` — current project state
```

Replace with:

```
3. Read `<ctx>/AGENT-CONTEXT.md` — current project state. Then, if `docs/documentation/INDEX.md` exists, read it (and `docs/INDEX.md` if present) — the vault index. This is **awareness, not study**: it maps what the repo has documented so the laws can be found by name before anything is improvised. `.kol/` carries history and state; `docs/` carries the rules.
```

Folding it into step 3 rather than inserting a new step 4 means **no
renumbering** — steps 5, 6 and 8 cross-reference each other by number.

**Step 8, line 31** — optional, one clause. After the handoff-summary sentence:

```
If the docs index was read, name the sections that govern the work at hand in one line — not a summary of the index, just the pointers.
```

## The per-repo half

The index says what exists. It doesn't say what gets referenced most in *this*
repo. That belongs in the repo's own `AGENT-CONTEXT.md`, which the skill already
reads at step 3 — a short block naming the hot files.

For kol-ds-ui that would be:

| Doc | What it rules |
|---|---|
| `01-foundations/04-layout-breakpoints.md` | width tiers, breakpoints, padding rhythm, rail width |
| `01-foundations/05-layout-systems.md` | which layout system owns what — the lookup before picking a container |
| `08-breakpoints/04-kol-ds-rules.md` | the responsive laws, in table form |
| `03-components/02-placement.md` | where a component goes, and whether it ships at all |
| `04-compositions/02-shells.md` | shell chrome — frame, rails, insets, embed mode |

No skill change needed for that half; it is per-repo authoring.

## Rejected alternative

A `PreToolUse(Edit|Write)` hook mirroring `doc-sync-reminder.sh` — it reads each
doc's `sources:` frontmatter, so it could print *"this file is governed by X"*
before an edit landed. Dropped: ~30 lines plus a `grep` across the docs tree on
**every edit, forever**, to deliver less awareness than 32 lines read once at
boot. The index is cheaper and earlier.

## Definition of done

- [ ] Step 3 sentence added in both `SKILL.md` files
- [ ] `/ag-init` in a repo with `docs/documentation/INDEX.md` reads it and names the relevant sections
- [ ] `/ag-init` in a repo without one is silent — no error, no mention

---

## ✅ RESOLUTION — 2026-08-01

Applied verbatim to **both** files (user: *"ag-init and agent-init, both"*):

- `claude/skills/ag-init/SKILL.md`
- `claude/skills/agent-init/SKILL.md`

**Step 3** — the ticket's sentence, folded in as proposed so steps 5/6/8 keep their
numbers. One addition beyond the ticket text: `No index → silent, no error, no mention.`
made explicit, since that was a DoD item but not in the sentence.

**Step 8** — the optional clause added: name the governing sections in one line, pointers
not a summary.

- [x] Step 3 sentence in both `SKILL.md` files
- [x] Step 8 clause in both
- [x] Repo with an index reads it — dotfiles has `docs/documentation/INDEX.md` **and**
      `docs/INDEX.md`, so both branches of the sentence fire here
- [x] Repo without one is silent — guarded by `if … exists`

**The per-repo half stays open by design** — the ticket says the hot-files block belongs
in each repo's own `AGENT-CONTEXT.md`. That is per-repo authoring, not a skill change,
and no skill edit can deliver it.
