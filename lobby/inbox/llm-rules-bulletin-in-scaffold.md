# Give the scaffolded LLM_RULES.md a BULLETIN section — and symlink kol-ds-ui onto it

**Staged:** 2026-08-01 · from a kol-ds-ui session
**Change:** one section in the scaffold template, the skill that writes it, and one repo converted from a local file to the symlink

---

## The problem, in one case

kol-ds-ui shipped `@kolkrabbi/kol-theme@0.24.0` today. It **deletes** `.text-body`
and `--kol-fg-body` with no fallback — a consumer still using either loses its
text colour silently, with nothing in the console.

That is exactly the announcement `LLM_RULES.md` § BULLETIN exists for.
kol-ds-ui's own copy already carries three entries and one of them is this same
class of change:

> *"2026-07-29 · Links ship COLORLESS since `kol-theme@0.12.0`."* — version cited,
> old behaviour named, and what a repo must do to restore it.

**But that file is kol-ds-ui's, and it reaches nobody else.** Checked all four:

| Repo | `LLM_RULES.md` | Has BULLETIN |
|---|---|---|
| kol-ds-ui | regular file, local | **yes** — 3 entries |
| dotfiles | regular file, local | — |
| humpty | regular file, local | — |
| **kol-website** | **symlink** → `claude/packages/scaffold/03-scaffold-llm-context/LLM_RULES.md` | **no section exists** |

kol-website is the one repo wired to the shared template, and the template has no
BULLETIN at all. So the single consumer that *would* inherit an announcement is
the single one that structurally cannot. Its agent boots, reads its rules file,
and learns nothing about a breaking token change in a package it installs.

The cost is not hypothetical: `.text-body` was live at **78 call sites** in
kol-ds-ui alone before today's rename.

## The fix

1. Add a `## 📢 BULLETIN` section to
   `claude/packages/scaffold/03-scaffold-llm-context/LLM_RULES.md`, matching the
   shape kol-ds-ui already proved — dated entries, newest first, prune older than
   a month. Empty in the template, with the one-line convention above it.
2. Decide what a scaffolded repo's bulletin is *for*. kol-ds-ui's is
   **outbound** (things this repo changed that others must know). A consumer's is
   **inbound**. If the same section serves both, say so in the template; if not,
   the consumer's wants a different heading.
3. `scaffold-llm-context` writes the section on new repos, and repairs it on
   existing ones — the same repair path the skill already runs for a missing
   symlink or a wrong-type artifact.
4. **Symlink kol-ds-ui onto the template while you are in there** (user ask,
   2026-08-01). Three of the four repos hold a *regular file* where kol-website
   holds a symlink — a convention with one adopter is not a convention, and it is
   why nobody noticed the template was missing a section the local copies had.

   **This is the part that needs a decision, not just a `ln -s`.** kol-ds-ui's
   local file is not generic: its startup protocol names `.kol/llm-context/`
   explicitly, and its BULLETIN holds three dated entries that are *about this
   repo*. Symlinking as-is would delete both. So the shape has to answer where
   per-repo content lives once the rules are shared — an `include` line, a
   sibling `LLM_BULLETIN.md` the template points at, or a template that is
   genuinely repo-agnostic with everything specific already in `.kol/`. Pick one
   and the other two repos follow the same way.

## Rejected alternative

**Writing the bulletin into the shared template as content.** That was the first
instinct and it is wrong: the template is symlinked, so a kol-ds-ui fact written
there is broadcast verbatim into every scaffolded repo as if it were their own
rule. The template gets the *section*; the *entries* stay per repo.

**Using the lobby alone.** The lobby is the right channel for a ticket addressed
to one repo, and it is how this very entry travelled. It is the wrong shape for a
standing notice every agent should see at boot without anyone filing it.

## Definition of done

- [ ] The scaffold template carries a `BULLETIN` section with its convention line
- [ ] The template states whether a consumer's bulletin is inbound, outbound or both
- [ ] `scaffold-llm-context` emits it on create AND repairs a template missing it
- [ ] kol-website, the one symlinked repo, ends up with a section its agent reads at boot
- [ ] **kol-ds-ui runs off the symlink**, with its three bulletin entries and its
      `.kol/llm-context/` startup protocol intact — losing either is a failed fix
- [ ] The per-repo-content answer is written down, so dotfiles and humpty convert
      the same way rather than each inventing one

## Also noticed, not the ask

`packages/theme/CHANGELOG.md` in kol-ds-ui tops out at **0.6.0** while the package
ships **0.24.0** — eighteen minors unrecorded, so the npm-facing channel is dead
too. That one is kol-ds-ui's own problem, not dotfiles', and is noted here only
because it is why the bulletin carries the whole load.
