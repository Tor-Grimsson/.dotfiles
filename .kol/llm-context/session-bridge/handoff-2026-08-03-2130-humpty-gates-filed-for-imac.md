# Handoff — 2026-08-03 21:30

## For the iMac agent — you have the humpty checkout, the MBP does not

Two humpty gate defects were hit in live use on the MBP today. Neither can be fixed from that
machine: `~/dev/projects/kol-dumpty/` does not exist there. They are filed in this repo's queue.

**Read `lobby/inbox/humpty-gates-misfire-on-docs-and-command-text.md` before touching either hook.**
Ledger row and history line are in `lobby/INDEX.md`.

| Defect | Hook | Shape of it |
|---|---|---|
| Token set from the wrong repo | `humpty_tokens.py` | Counts `--kd-*` in the **session cwd's** repo, applies the law to a write whose target is in another repo. Also fires on markdown, where a palette doc's literal values are the content |
| Scan rule matches command text | `humpty-gate` | Denies a grep for **naming** the vendor directory it excludes — and denies a heredoc write because the file's **prose** mentions it. No scan involved in the second case |

The token count is **real and correctly measured** — 14 distinct names in
`claude/packages/scaffold/02-scaffold-docs/obsidian-shapes/04-plugin-kol-dashboard/styles.css`.
It is measured against the wrong tree, which is a different fix from the one my first diagnosis
implied. The ticket carries that correction; do not act on the earlier framing if you see it
quoted anywhere.

## Still open from earlier today — unchanged

**Plugin skills are only reachable as `/humpty:<name>` and the user rejects that syntax.**
Full brief: `session-bridge/handoff-2026-08-03-1830-plugin-skills-namespace-problem.md`.

The next action there is **research, not a proposal**: does Claude Code offer any alias or
command-mapping so a plugin's commands resolve bare? I asserted it does not, without checking.

**Do not quarantine the 18 dotfiles skill copies while that is open** — they are the only reason
`/jana`, `/yona` and the eight `/tmpl-*` work without a prefix today. The parking-lot entry that
proposes quarantining them is written from the wrong premise.

## Also landed today, no action needed

- `bin/md-preview` + piper — yazi's markdown preview now shows frontmatter. Proven standalone;
  the user has not yet eyeballed it inside yazi.
- Framer external-agent setup run on the MBP for the first time. Session against the STUDIO16
  project; four docs written **in studio16**, not here.
- The plugin's own `skills/humpty-goal/SKILL.md` still points at `claude/hooks/goal-loop.sh`, a
  path that left dotfiles in the consolidation. Real ubu-roi defect, fix at source.

## Next intended action

Nothing is mid-flight on the MBP. The iMac picks up the lobby ticket and the namespace research.
