---
name: kol-appliant
description: Check or bring a tool/solution up to the kol-appliant standard — the 5-point documentation contract (in-point install chain · category home + neighbours · purpose surface [usage/hotkeys/use-cases/sources/links] · KOL-accessible via keys/files · dups map) plus the definition-of-done (--help works, keys/files registered). Use when adding a new tool/script to the repo, when the user says "make this kol-appliant" / "/kol-appliant <tool>", or to audit an existing tool's docs for gaps.
---

# kol-appliant

Bring a tool or solution up to — or audit it against — the **kol-appliant** standard: every tool has an immediate, findable, complete home, never buried. Full spec: `docs/operations/03-kol-docs-system-setup/01-kol-appliant-tool-standard.md`.

## When
- A new tool/script/solution ships → run the DoD before calling it done.
- "make X kol-appliant" / "/kol-appliant X" → audit X and fix the gaps.
- Auditing the catalog → run per tool.

## The Definition of Done — walk it for tool `<T>`, fix each gap

1. **In-point** — the install/enable chain in one place.
   - brew tool → a line in `brewfile-cli` or `brewfile-gui`; non-brew (pipx/uv/built-in) → a documented install path; `bin/` script → on PATH via `bin/`.
   - Check: `grep -n <T> brewfile-cli brewfile-gui` or confirm `bin/<T>` exists.
2. **Home** — a catalog doc under the right `docs/` family **+ a row in that family's `INDEX`**.
   - `bin/` scripts → `docs/scripts/` (by family); installed tools → `docs/documentation/<NN-category>/`.
   - Check: `grep -rl <T> docs/` → has a doc? If not, author one via `/kol-docs-md`.
3. **Purpose** — the doc answers all of: **usage · hotkeys · use-cases · sources · external links**.
4. **KOL-accessible** — keybinds registered in `keys` (via `/keys-add`), home folder in `files` (via `/files-add`). If `<T>` has neither, mark N/A.
   - Check: `keys <T>` · `grep <T> keys/keybinds.md files/folders.md`.
5. **`--help`** — for a `bin/` script, `<T> --help` prints usage and exits 0. Lint the whole `bin/` at once with **`help-lint`** (`bin/help-lint`; static, skips binaries).
6. **Dups** — the doc maps `<T>`'s other locations/mentions (`grep -rn <T>`), so nothing goes stale silently.

## Report
A short checklist: which of the 6 hold, which you fixed, which are N/A. Hand a whole missing doc to `/kol-docs-md`; a missing keybind/folder to `/keys-add` / `/files-add`.

## Notes
- Section-level history = **git** (`git blame`, `git log -L`); the doc carries `updated:`. No section-hash changelog system.
- This skill enforces the standard; the standard itself is the reference doc linked above.
