# Repoint or retire the g-nav jump family — 26 of 27 targets are dead

**Staged:** 2026-07-31 · from the dotfiles lobby-system session
**Change:** one file (`shell/functions/g-nav.zsh`), plus the `ref-shell` rows describing it.

---

## The problem, in one case

`gapparat -4` is documented as "jump to the design system". It jumps nowhere:

```
$ ls -d ~/dev/projects/kol-apparat
"/Users/biskup/dev/projects/kol-apparat": No such file or directory
```

`kol-apparat/` and `kol-client/` **do not exist**. The estate was reorganised — repos are now top-level (`kol-ds-ui`, `kol-website`, `kol-chess`, `kol-ds-fxr`, `kol-vault`, `kol-glass`) plus two families (`kol-apps/`, `kol-dumpty/`) — and `g-nav.zsh` never followed.

Measured 2026-07-31:

| function | targets | dead |
|---|---|---|
| `gapparat` | 12 | **12** |
| `gclient` | 8 | **8** |
| `gdev` (flags) | 7 | **6** — only `--studio` survives |
| `ghome` · `gdot` · `gobs` · `gicloud` | — | 0, these are fine |

**26 of 27 flagged targets are dead.** Each still prints its `-h` help as if it worked, and `_gnav_act` `cd`s into a non-existent path, so the failure surfaces as a bare `cd: no such file or directory` with no hint that the *map* is wrong.

Cost this session: `gapparat -4` was used as the worked example for the `-c` copy flag in `ref-shell` — a dead path documented as canonical usage. Caught only because the same reorganisation had broken `/lobby-ds` (six skills pointed at `kol-apparat/kol-design-system`).

## The fix

Rebuild `gapparat` and `gclient` against the live estate, or retire them:

- **`gclient`** → client repos now live under `kol-apps/` as `kol-client-*`. Repoint at `~/dev/projects/kol-apps`, or fold into `gdev`.
- **`gapparat`** → the family is gone entirely. Its members are either top-level repos (already reachable) or no longer exist. Strong case for **deletion** rather than repointing — a jump family with no family to jump to is dead weight.
- **`gdev`** → drop `--monorepo`, `--typefaces`, `--dashboard`, `--chords`, `--imweb`, `--kclaude`; keep `--studio`.

Cross-check every target against `docs/operations/systems/repo-map/01-repos.md` — the hand-kept truth for the estate, already listing the 29 live repos.

Then remove the ⚠ block added to `ref/shell.md` § `paths — copy the cwd` on 2026-07-31 and restore a **live** path as the `-c` worked example.

## Rejected alternative

A shell-startup check validating every target and warning on a dead one. Rejected: it runs on every shell start, forever, to report a fact that changes maybe twice a year — and it would have *masked* this by making breakage feel routine. The estate already has a drift tool, `bin/repo-map.sh`, and that is where a periodic check belongs, not in the prompt path.

## Definition of done

- [ ] `gapparat` deleted, or every target resolves
- [ ] `gclient` deleted or repointed at `kol-apps/`
- [ ] `gdev` flags pruned to the ones that exist
- [ ] Every surviving target verified with `ls -d`
- [ ] `ref-shell` ⚠ block removed, `-c` example uses a live path
- [ ] `docs/documentation/01-shell-terminal/13-shell-functions.md` synced

---

## ✅ RESOLUTION — 2026-08-01

**Deleted, not repointed.** The user's call: *"yeah just delete I dont use it, it was
before I had the bookmarks for that purpose"* — the whole `g*` jump family is superseded
by the tmux bookmarks system (`prefix C-b` open · `B` add-cwd · `A` typed).

Seven functions removed: `ghome` · `gdot` · `gdev` · `gobs` · `gapparat` · `gclient` ·
`gicloud`, plus the `_gnav_act` / `_gnav_help` helpers they shared.

**Kept:** `zshrc` and `cwd` — not jump shortcuts, not covered by bookmarks, and `cwd`
was added deliberately on 2026-07-31. Neither used the `_gnav_*` helpers, so both
survived intact.

`shell/functions/g-nav.zsh` → **`shell/functions/paths.zsh`** — a file named for a
family that no longer exists is the same stale map that caused this ticket.

- [x] `gapparat` deleted
- [x] `gclient` deleted — deletion chosen over repointing at `kol-apps/`
- [x] `gdev` deleted entirely, including `--studio` (bookmarks cover it)
- [x] Surviving functions verified live — `type` resolves `cwd`/`zshrc`, all seven `g*` "not found"
- [x] `ref-shell` ⚠ block removed; `-c` examples now use `cwd`/`zshrc`, both live
- [x] `shell/.zshrc:162-163` source line + comment repointed at `paths.zsh`
- [x] `docs/documentation/01-shell-terminal/13-shell-functions.md` — **no-op**: it only ever
      documented `killport`; g-nav was never in it. The DoD line assumed a sync that had no target.

**Fixed in passing:** `ref/shell.md` pointed at `ref-tmux bookmarks`; the section is
`## bookmark`, singular — the filter returned *nothing tagged "bookmarks" in tmux*.
