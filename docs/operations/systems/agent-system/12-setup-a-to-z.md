---
title: 12 · setup A–Z — the whole system from zero to verified
type: playbook
status: active
updated: 2026-08-03
description: The complete start-to-finish walkthrough of the published system — humpty (discipline plugin), memory-glass (git-backed memory), jabberwocky (the agent OS), and the dotfiles wiring — every command verbatim, with verification at each stage and the traps footnoted.
tags:
  - project/dotfiles
  - domain/tooling
related:
  - "[[INDEX|kol-agent-system]]"
  - "[[00-system-map|00 — system map]]"
  - "[[08-behavior|08 — behavior]]"
  - "[[11-grant|11 — grant]]"
---

# Setup A–Z — the whole system from zero to verified

This is the narrative walkthrough: what the system *is*, what you install, in what order, what each step actually does, and how you prove at every stage that it worked. Every command is verbatim — paste it as written. The traps are footnoted where they bite, each one earned live on 2026-07-28.[^live]

The short version of the story: your agent harness gives you a smart worker with amnesia, no filing system, and no self-control. The system fixes all three, in three installable pieces plus the personal wiring that holds them together.

---

## 0. Prerequisites

A macOS machine with the basics this whole ecosystem already assumes:

- **git** and the **GitHub CLI** (`gh`), authenticated (`gh auth status` answers cleanly)
- **python3** and **bash** — the only languages any of the machinery uses; no npm, no database, no daemon
- **Claude Code** as the harness (it is the reference harness everywhere; each repo documents its harness seam)
- the three repos, cloned wherever your projects live (this guide uses the canonical paths):

```sh
git clone https://github.com/Tor-Grimsson/humpty        ~/dev/projects/kol-dumpty/humpty
git clone https://github.com/Tor-Grimsson/memory-glass  ~/dev/projects/kol-dumpty/memory-glass
git clone https://github.com/Tor-Grimsson/jabberwocky   ~/dev/projects/kol-dumpty/jabberwocky
```

**Verify:** all three folders exist and `gh auth status` is green.

---

## 1. The map — what the four pieces are

Read this section once; everything after it is mechanical.

**humpty** is the discipline plugin — the enforcement layer. It injects five laws into every session (use what we have · reference, don't improvise · high reference = canon · read it twice · check means check), runs a 4-level muzzle dial you control, arms a decaying word-budget clamp when you call out noise (`st · stf · stfu`), and gates shell pipelines (git/npm/gh/downloads) behind time-boxed permission windows. It is the piece that *runs* — two hooks fire on every session start and every prompt.

**memory-glass** is the memory system — the remembering layer. Plain files, symlinks, and git: each repo owns its memory in a tracked tier dir, a symlink redirects the harness's stock write path into that tier, and one clone of the repo becomes a lens vault that aggregates every project's docs and memory into a single greppable surface.

**jabberwocky** is the operating system — the blueprint. Nine modules (init, context, journaling, memory, plans, docs framework, human tier, behavior, routing) shipped as plain files you adopt wholesale or steal one at a time. humpty and memory-glass are two of its modules shipped standalone; the rest stamp into your repos as templates and skills.

**dotfiles** is *your* wiring — the personal layer none of the public repos ship: the statusline, the tmux binds, the `ref-keys` reference cards, your persona, your global memory tier. The public pieces plug into it.

The order below matters only in one place: humpty installs into the harness (minutes), memory-glass wires the harness's write paths (minutes), jabberwocky stamps per-repo (ongoing). Do them in that order the first time.

---

## 2. Install humpty

**On a machine that has dotfiles: nothing to run.** `claude/settings.json` declares both halves —
`extraKnownMarketplaces.humpty` pointing at `github: Tor-Grimsson/ubu-roi`, and
`enabledPlugins["humpty@humpty"]: true`. Claude Code reads them at startup, fetches the plugin
from the marketplace and installs it into `~/.claude/plugins/cache/humpty/`. Pull, restart, done.
Verified on the MBP 2026-08-03 — the machine has no `kol-dumpty/` checkout at all.[^namespacing]

Without dotfiles, add the same marketplace by hand (`Tor-Grimsson/ubu-roi`), then
`/plugin install humpty@humpty` and `/reload-plugins`.

Either way the install registers two prompt-side hooks (session boot + per-prompt tracker), the tool-side gates, and the command surface `/humpty:lvl · st · stf · stfu · laws`.[^dup-hooks]

**Verify:** the session opens with a `[humpty] MODE: standard (2/4)` header followed by the five laws; typing `$humpty` returns one line: `humpty: dial is standard (2/4) · turn N · nudges N`. The two gates deny on probe — `rm -rf <a repo path>` returns the NOTHING IS DELETED law, a gated read returns `mode: off` with the unlock hint.

**A local checkout overrides this on a dev machine.** `~/.claude/settings.local.json` (untracked) repoints the marketplace to `directory` so hook edits are live without republishing. Its *absence* is the correct state on every other machine.

---

## 3. Drive the dial

The dial is the *only* knob the doctrine needs. Four levels, persisted across sessions, `clear`, and `compact`:

| Level | Name | What changes |
|---|---|---|
| 1 | loose | laws at boot only — riff sessions |
| 2 | standard | + report shape, compact re-ground every 3rd turn |
| 3 | strict | + pre-bulleted replies, re-ground every turn |
| 4 | muzzle | + hard caps: verdict or runbook, ≤ 12 lines, full law every turn |

`$humpty 3` sets it (or `/humpty:lvl 3`, or the names: `loose|standard|strict|muzzle`). `$humpty off` = level 1.

When a reply annoys you, escalate without touching the dial — the word erodes as your patience does: **`st`** floors the next reply at 160 words, **`stf`** at 80, **`stfu`** at 40 plus a one-line-ownership override. The budget doubles back each clean turn; re-offending re-floors it; any `$humpty <level>` releases it early. These count only as exact commands or standalone messages — writing about them in prose is inert.[^clamp-guard]

Matching and the usage ledger have **no commands** — they run ambiently under Law 1, scaled by the dial (at 2+ the agent names the closest existing thing before building; at 3–4 it must cite it or state "none exists").

**Verify:** send `st` as a whole message → the next reply is visibly short and the one after relaxes.

---

## 4. The gate — permission windows

The gate decides what the agent's shell may touch, per pipeline: `git · npm · gh · downloads`, each standing at `off | read | full` (defaults: gh=read, the rest off). A **grant window** lifts an `off` pipeline to `read` for a few minutes — writes stay gated even mid-window:[^two-gates]

```sh
~/dev/projects/kol-dumpty/humpty/bin/humpty-grant            # toggle: git+downloads, 15m
~/dev/projects/kol-dumpty/humpty/bin/humpty-grant npm 10     # one pipeline, custom minutes
~/dev/projects/kol-dumpty/humpty/bin/humpty-grant status     # what's open
~/dev/projects/kol-dumpty/humpty/bin/humpty-grant off        # revoke now
```

Standing modes live in `~/.claude/.humpty-gate` (`pipeline=mode` lines — edit by hand, that's the whole config). No timers anywhere: the window is an expiry timestamp checked per use.

On this machine you never call `humpty-grant` by hand for the daily case: **`prefix g` (or `agent-grant`) opens BOTH gates' windows in lockstep** — that wiring exists because this guide's verification pass caught the two gates holding separate windows, which had silently killed the `prefix g` grant the day it was built.[^two-gates]

**Verify:** with no window open, ask the agent to run `git status` → denied with an unlock hint; `prefix g` → the same call passes; `git push` stays denied regardless.

---

## 5. Wire memory — memory-glass

One-time, ~five minutes, from the [memory-glass quickstart](https://github.com/Tor-Grimsson/memory-glass):

```sh
cd ~/dev/projects/kol-dumpty/memory-glass    # your clone IS the vault
# 1 · edit the seam at the top of sync.sh:
#     ROOTS    — where your repos live        (default: ("$HOME/dev/projects"))
#     DOTFILES — repo carrying the global tier (default: "$HOME/.dotfiles")
# 2 · create the global tier (cross-repo facts — keep this repo PRIVATE):
mkdir -p ~/.dotfiles/claude/memory
# 3 · opt any repo in — membership is one directory:
mkdir -p <repo>/.kol/llm-memory
# 4 · wire everything (idempotent, re-run any time, any machine):
./sync.sh
```

What happened: every opted-in repo's memory dir and docs folder got symlinked into the vault's two lenses (`memory/`, `repos/`), and each repo's harness write path (`~/.claude/projects/<key>/memory`) became a symlink into that repo — the agent keeps writing where it always wrote, but the writes now land in git and travel with the repo.[^privacy]

**Verify:** `sync.sh` prints its `+linked / -pruned / merged / wired` line; `ls -la ~/.claude/projects/*/memory` shows a **symlink for every opted-in repo** — projects that haven't joined keep plain dirs, which is by design (membership *is* the tier dir; probed live: 7 symlinks, 34 plain non-members, 0 dangling); a memory the agent writes shows up as a modified file in the owning repo.

---

## 6. Give a repo the OS shell — jabberwocky

This is the ongoing half: sections 2–5 you do once per machine, this one you do once per *repo*, whenever a project graduates into "the agent works here regularly." Each module below is a payload directory in the jabberwocky clone plus a category of docs explaining it; every module stands alone, and the only cross-module assumption is the `.kol/` convention dir. Take them in order the first time — each one gives the next something to stand on.

**Boot (module 01).** Copy `modules/01-init/LLM_RULES.md` to the repo root. This is the file an agent reads before anything else — it points at the context dir and forbids work before orientation. The `/ag-init` skill is the other half: at session start it detects the machine, reads ARCHITECTURE then AGENT-CONTEXT then the newest session log (and a newer handoff if one exists), reports what it found, and *stops* — the agent now knows where it is and waits for a task. Without this module every session starts from amnesia.

**Context (module 02).** Instantiate the three templates from `modules/02-context/` into `.kol/llm-context/`: **ARCHITECTURE** holds the load-bearing decisions with their "do not revisit unless" clauses; **AGENT-CONTEXT** holds current state as a bounded chain of dated entries (trim discipline: chain of 5, ~30 KB ceiling — the bound is what keeps it loadable forever); **HISTORY** holds the why. These three files are what `/ag-init` reads — boot without state is a formality, state without boot is unread.

**Journaling (module 03).** Install the four `*.skill.md` files — four tenses of the same act: `/playbook` journals *during* work (append-only, real timestamps), `/log-work` records a session *after* it, `/log-work-handoff` bridges a *paused* arc to the next session, `/log-work-milestone` *seals* a finished arc and closes its threads. They all write into the context dir from module 02, which is how the AGENT-CONTEXT chain stays honest instead of growing stale.

**Plans (module 05).** Stamp `parking-lot.template.md` into `.kol/llm-plan/01-parking-lot.md`. Three verbs govern it: **graduate** (an entry becomes real work → moves to AGENT-CONTEXT), **park** (speculative → written down with kill criteria), **kill** (criteria met → deleted). Futures stop haunting the current-state file — that's half of the trim discipline working.

**Memory (module 04 — already done in section 5).** `mkdir .kol/llm-memory` and a `sync.sh` run; the repo now remembers across sessions and machines.

**Docs + human tier (modules 06 + 07).** The audience law: `.kol/` is the agent's surface, `docs/` is *yours* — anything meant for human eyes goes in `docs/`, never the machinery dirs. Module 06 ships the full docs-framework canon (frontmatter contract, archetypes, tag taxonomy) that a repo's vault conforms to; module 07 ships the 3-file license-clean `.obsidian` seed so the vault opens in Obsidian with zero third-party baggage. For a working repo, the minimum is the audience law plus a `docs/INDEX.md`; full conformance can come later.

Modules 08 (behavior) and 09 (routing) you already have live in stronger forms — humpty *is* the behavior stack evolved (section 2), and your kol-glass vault *is* the routing module instantiated (section 5).

**Verify:** open a fresh session in the repo, run `/ag-init` → it reports machine, ARCHITECTURE, current state, and latest log, then stops and waits.

---

## 7. The cockpit — dotfiles wiring

The personal layer, already live in this dotfiles repo, listed so you know what's load-bearing:

- **Statusline** (`bin/kol-statusline` → the plugin's `humpty-statusline`) — the `humpty-dumpty` block in tmux active-tab yellow (256-color 214/234) reading the plugin's state, level suffix off-default; then model · cwd · ctx · tok · 5h, each gruvbox-colored. `bin/kol-statusline` is a **locator**, not the renderer: `statusLine` is not a hook, so `$CLAUDE_PLUGIN_ROOT` is unset there and a direct plugin path silently yields a blank line. It prefers the dev checkout, then the newest plugin cache, then prints nothing.
- **tmux** — `prefix g` toggles the dotfiles-side [[11-grant|agent-grant]] window (the gate's ancestor, still active)[^two-gates]; the pane/window/session surface is on `ref-keys tmux`.
- **Reference cards** — `ref-keys git new` is the verbatim init→publish chain with both rescues; `ref-keys gh` covers repo create/rename/browse.
- **Global memory tier** — `claude/memory/` in this repo, symlink-wired by section 5, indexed in its `MEMORY.md`.

---

## 8. Verification — "everything is perfect" as a checklist

Run down this table on any machine claiming to be set up; every row has a probe and an expected answer.

| Piece | Probe | Expect |
|---|---|---|
| humpty installed | `/plugin` → Installed | `humpty @ humpty`, enabled, 0 errors |
| laws injecting | new session | `[humpty] MODE:` header + five laws at boot |
| dial | `$humpty` | one `humpty: dial is …` line |
| clamp | `st` as a whole message | next reply ≤ 160 words, then decays back |
| gate | agent runs `git status`, no window | denied with unlock hint |
| grant | `prefix g` (opens both gates) then same probe | read passes · `git push` still denied |
| memory wiring | `ls -la ~/.claude/projects/*/memory` | every opted-in repo's key is a symlink (non-members keep plain dirs — by design) |
| vault lenses | `ls <vault>/memory <vault>/repos` | one link per opted-in repo, none dangling |
| repo shell | `/ag-init` in an opted-in repo | context report, then stops and waits |
| statusline | glance | yellow `humpty-dumpty` block + colored fields, no `7d` |

All rows green = the system is set up, remembering, and enforcing. Anything red: the section above it is where to look.

---

[^live]: Every trap in this doc was hit for real during the 2026-07-28 install-and-publish arc — this guide is the distillation of that failure trail, which is why the commands are verbatim rather than paraphrased.

[^namespacing]: Bare `/humpty` cannot exist as a command: Claude Code namespaces plugin commands as `/plugin-name:command` (`/humpty:lvl`). The dial is therefore reachable two ways — the namespaced command, or `$humpty`, which is plain text and reaches the tracker hook from any prompt. `$humpty` is the daily driver.

[^dup-hooks]: Two install-time traps: `marketplace add` requires `.claude-plugin/marketplace.json` to exist in the repo (it errors "Marketplace file not found" without it), and a plugin must never declare `"hooks"` in `plugin.json` — `hooks/hooks.json` auto-loads by convention, so declaring it double-registers and the plugin list shows a "Duplicate hooks file detected" error.

[^clamp-guard]: The exact-command guard exists because the first clamp shipped word-matching and armed itself whenever `stfu` was merely *discussed* — a live false positive. Signals now only count as commands or standalone messages.

[^two-gates]: Two gates stack on this machine: the dotfiles-native [[11-grant|agent-grant]] (git-gate.sh, `prefix g`, `~/.claude/.agent-grant`) and humpty's generalized gate (`humpty-grant`, `~/.claude/.humpty-grant` + `.humpty-gate`). Both are deny-first — a call passes only if neither denies — which was proven to mean the old grant was **dead on arrival** once humpty installed: fixture test showed `git status` denied with the agent-grant window wide open. Fixed 2026-07-28 in `bin/agent-grant`: opening a window now writes both flag files, `off` revokes both; re-tested → read passes, writes still denied, revoke closes everything. Long-term the humpty gate is the survivor and the dotfiles pair retires.

[^privacy]: Tracked memory rides git history — a repo's tier goes wherever the repo goes, including every past version. Tier-carrying repos stay private, or get scrubbed before publishing. The global tier is the most personal layer; it lives in the private dotfiles repo.
