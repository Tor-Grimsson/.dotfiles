# 2026-06-05 — two-machine sync (iMac)

Converged both machines after the MBP had been pulled/rebased. iMac had uncommitted local work on top of a stale base; standard ritual ran clean: `git stash -u` → `git pull --rebase` → `git stash pop` (auto-merge of `shell/.zshrc`, verified — only the local additions, nothing from the MBP side clobbered).

- Committed + pushed as `c177baf` ("synco"): new `docs/13-terminal-browsers/` category (carbonyl, w3m, INDEX), `docs/INDEX.md` row, and the `carbonyl()` Docker function + `hn` alias in `shell/.zshrc`.
- User verified the other machine afterwards — both clean on `c177baf`.
- All git run by the user; agent advised only.

## Next steps
- None. Sync ritual for reference: stash `-u` (untracked dirs!), pull --rebase, pop, eyeball any auto-merged file before committing.
