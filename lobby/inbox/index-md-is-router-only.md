# Ticket: INDEX.md must only route — never be the content

## What you said

"INDEX.md is an index, its not for other purpose then to explain the other files in the folder, I keep saying it, but its not landing. Where does it need to be explained such that I dont have to say it again?"

## Where it's currently landing wrong

`~/.dotfiles/claude/packages/kol-docs/kol-docs-md/02-doc-anatomy.md` — the canonical doc every repo's `.kol/docs-framework/` copies from, and what `/scaffold-docs-system` reads before writing anything.

It says the opposite of your rule, in three places:

- **Line 46:** "Single-doc folders are fine. `01-architecture/INDEX.md` IS the architecture doc, with `type: decisions` in frontmatter."
- **Lines 54–55** (under "Have an INDEX when"): "The folder contains one substantive doc that IS the folder's content (single-doc subfolder)."
- **Lines 62–64** (under "Types based on role"): "Single-doc folder → INDEX *is* that doc, with the relevant `type:` in frontmatter (`decisions`, `audit`, etc.)."

## What happened because of it

Following that doc literally, I wrote two INDEX.md files in studio16 that ARE the content, not routers:

- `docs/documentation/00-overview/INDEX.md` — the overview text lives directly in INDEX.md.
- `docs/documentation/01-file-conversion/INDEX.md` — the whole file-conversion reference doc (scripts, specs, usage, worked example) lives directly in INDEX.md.

Both need to become: `INDEX.md` (router, describes/links the sibling doc) + a separate numbered content file. Left as-is in studio16 for now — didn't want to guess the corrected shape and rewrite twice.

## Open question the fix needs to settle

For a folder that only holds one doc, once INDEX.md can never be that doc — two ways to go, and the doctrine should pick one and say so explicitly:

1. **Keep the folder.** `INDEX.md` becomes a real (if one-row) router pointing at the actual file inside it, e.g. `01-file-conversion/INDEX.md` → `01-file-conversion/01-scripts.md`. Folder still reserves the namespace for future growth.
2. **Drop the folder.** No subfolder, no INDEX, for a single doc — just a numbered file at the parent level (`documentation/01-file-conversion.md`). Promote to folder + INDEX only once a second doc actually shows up.

I asked you this as a clarifying question and you redirected me to file this ticket instead of picking an answer myself or editing dotfiles directly — so it's still open.

## Where this might actually live

You mentioned it might be humpty's territory rather than a plain dotfiles-lobby ticket — I didn't chase that down, wasn't sure which repo/path actually owns kol-docs doctrine fixes. Move this wherever it belongs.
