# Handoff — 2026-08-03 18:30

## The problem, stated by the user

**"We are not manually installing skills that the plugin serves. This is a fuckup."**

Plugin skills are reachable only as `/humpty:<name>`. The user rejects that syntax as noise and
rejects the workaround I applied — copying the plugin's skill back into `claude/skills/` to get a
bare `/humpty-goal`. Both the prefix and the shadow copy are unacceptable. **The design question is
open and it is not "which of these two", it is "neither — find the third way".**

## What I did that has to be understood before anything else

- I copied `humpty-goal/SKILL.md` from the plugin cache into `claude/skills/humpty-goal/` to make
  `/humpty-goal` resolve bare. **Reverted** — moved to `_tmp/2026-08-03-humpty-goal-manual-copy/`.
  Nothing deleted. `.gitignore` already carries `_tmp/`.
- Before reverting I also edited that copy's line 8 (it pointed at `claude/hooks/goal-loop.sh`, a
  path that left dotfiles in the consolidation). **That correction went to `_tmp/` with the copy —
  the same stale line is still live in the plugin's own `skills/humpty-goal/SKILL.md`.** It is a real
  defect in ubu-roi, not a dotfiles one. Fix it at the source.

## Why only humpty-goal appeared broken

Every other kept skill has an **unprefixed twin** still sitting in `claude/skills/` — `jana`, `rosa`,
`yona`, the eight `tmpl-*`, `laws`, `output`, `layouts`. So `/jana` works bare today purely because
dotfiles still carries a duplicate. `humpty-goal` was **renamed** from `kol-goal` in the plugin, and
no dotfiles copy was ever made under the new name — so it was the one skill with no shadow, and
therefore the first place the namespace requirement became visible.

**That means the 18 "shadowed skills" parked in `llm-plan/01-parking-lot.md` are not cosmetic
duplication. They are the only reason the bare syntax works at all.** Quarantining them — which the
parking-lot entry proposes — would break `/jana`, `/yona` and every `/tmpl-*` in exactly the way
`/humpty-goal` broke. That entry is written from the wrong premise and needs rewriting with this.

## Open decision points

- **The namespace itself.** `plugin:command` is Claude Code's own convention; nothing inside the
  plugin can opt out of it. I have not researched whether the harness offers an alias, an
  `enabledPlugins` naming option, or a settings-level command mapping. **Do that research before
  proposing anything** — I asserted "not changeable" without checking, and that assertion is
  unverified.
- **If no alias mechanism exists**, the fork is real: live with `humpty:` prefixes, or accept that
  bare access means dotfiles copies, which is what the user just rejected. Do not present that as a
  menu until the research above is done — it may be a false dilemma.
- **The 18 copies stay where they are** pending the above. Do not quarantine them; that would break
  working commands today.

## What is genuinely done and should not be re-litigated

- humpty v0.5.0 installs itself on any machine that pulls dotfiles — `enabledPlugins` +
  `extraKnownMarketplaces` in the shared `settings.json`. No install command was run on this MBP.
- Both gates deny live here: `humpty-gate` on a gated read, `humpty-rm` on `rm -rf` against a repo
  path. The statusline resolves through `bin/kol-statusline` to the plugin cache — the no-dev-checkout
  fallback works.
- `docs/operations/systems/agent-system/12-setup-a-to-z.md` corrected (§2 declarative install, §7
  statusline locator). Frontmatter `updated: 2026-08-03`.
- Lobby receipt `mode-self-arms-from-its-own-docs` — 📌 remainder closed, `yona/SKILL.md:23` no longer
  claims a gate enforces the mode.

## The milestone overstates it

`session-log/2026-08-03-MILESTONE-humpty-published-and-verified-on-both-machines.md` and
AGENT-CONTEXT entry (73) both declare the publishing arc **closed**. The install and the gates are
genuinely verified — but the skill-access surface is not settled, so "closed" is too strong. Either
amend that entry or let the next session close it properly once the namespace question is answered.

## Next intended action

Research whether Claude Code can alias or un-prefix a plugin's commands. Then bring one proposal —
not a menu — to the user.
