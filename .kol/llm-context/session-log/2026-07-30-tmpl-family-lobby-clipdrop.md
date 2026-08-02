# The tmpl family · lobby read-side · clip-drop rebuilt

**Date:** 2026-07-30
**Agent:** Claude Code (Grim)

Scattered output restraints became one namespace, the lobby pattern got its missing half, and clip-drop stopped scattering captures into whatever directory the shell was in.

## 1 — the `tmpl-` family (14 skills)

`tmpl-` = a contract on the OUTPUT. `kolds-` = a contract on the SUBJECT.

| built | contract |
|---|---|
| `tmpl-present` | understanding + steps, then STOP (kills the "let's name it" → renamed-and-shipped failure) |
| `tmpl-ask` | ask · state · blocker · need — four lines, "shall I proceed?" banned |
| `tmpl-human` | ≤3-line paragraphs, one idea per line, no viewport-filling walls |
| `tmpl-uncanny` | no apology / validation / sympathy / enthusiasm cosplay |
| `tmpl-hl` | high-level shape, then walk one piece at a time |
| `tmpl-wl-{100,80,60,40,10}` | **standing** body budget 250→25 words; overflow folds into the footer |
| `tmpl-stfu` | local alias for the plugin-owned `humpty:stfu` |
| `tmpl-bullet` · `tmpl-clear` | from `claude-*`; old names kept as aliases |
| `kolds` · `kolds-ref` | the design system in one word; cite-before-building |
| `lobby` | READ a repo's `lobby/` queue on arrival |

`tmpl-wl-*` was designed against the actual bypass the user named: humpty's `st`/`stf`/`stfu` **decay** on clean turns, so the agent waits them out. These don't decay, carry concrete word counts, and spell out the dodges (reply-splitting, "one more thing", code-block smuggling, trailing questions).

## 2 — three new ref cards

`ref-skill` (tmpl · wl · mode · kolds · lobby · maintain) · `ref-humpty` (dial · clamp · laws · gate · lobby) · `ref-repo`. The last is **generated** by `repo-map.sh --card` from `01-repos.md`, so the vault surface and the shell surface can't drift. 14 cards now; all render, widths ≤79.

## 3 — clip-drop rebuilt

- **`~/_inbox` is the home.** A bare word is a **folder inside it**, never a path — the old behaviour created `./review` in the shell's cwd, which is how a stray `review/` appeared inside kol-ds-ui. Path-shaped words are stripped to their last segment; `--dir` is the explicit override.
- **Named repo flags** — `--kol-ds-ui` · `--humpty` · `--kol-website` · `--dotfiles` — derived from the `## lobby` registry in `files/folders.md`, so registering a lobby (one row) creates its flag with no code change.
- **`--help` rewritten examples-first** (the old one was a wall of mode prose).
- Two lobbies created with INDEX contracts: `~/.dotfiles/lobby/` and `kol-website/lobby/`. Registry repointed off the untracked `kol-dumpty/lobby` onto `humpty/lobby`.
- Verified: bare drop · folder word · repeat-into-same-folder · word+note · `../escape` defence · repo flag end-to-end.

## 4 — ported to humpty

`kol-dumpty/humpty/lobby/tmpl-family.md` — the family, plus the honest port question: `tmpl-wl-*` is honour-system today; a Stop hook counting body words would make it enforceable, exactly as footer-gate already does for shape.

## Open

- `kol-dumpty/lobby/text-overload.md` — still untracked, belongs in humpty; `agent-grant.md` belongs in jabberwocky.
- humpty plugin could adopt the `tmpl-` prefix wholesale, retiring the local `tmpl-stfu` alias.
- `ref-repo` has no `kolds` section (kol-ds-ui is the section name) — cosmetic.
