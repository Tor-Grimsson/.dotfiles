---
_template:
  version: 1
  path: .kol/llm-context/plan.md
  sync: skip
---

# dotfiles — future exploration

Not-yet-committed ideas. Graduate items into `llm-context/AGENT-CONTEXT.md` (Open items) when they become real work.

---

## mbp ↔ iMac Claude reconcile

**Premise:** the MBP's `~/.claude` lives in iCloud Workbox and has diverged (different CLAUDE.md, different skills) from the repo. Bring it under git without losing the fresher iCloud-side work.

### shape
A one-time merge run from either machine: union the skills (newest-wins on collisions), reconcile CLAUDE.md, then point the MBP's `~/.claude` at the repo via `bootstrap.sh`. Leave the iCloud copy as a frozen backup until verified.

### open questions
- Is the MBP's `~/.claude` a symlink into iCloud, or a real dir copied there? Determines the cutover steps.
- Which CLAUDE.md wins, or do they merge? (User: "idc, whatever" — default to the newer MBP one, port any repo-only rules.)

### kill criteria
If the MBP work turns out to be throwaway, just `bootstrap.sh` the MBP and overwrite.

---

## macOS defaults coverage

`macos/defaults.sh` is a baseline. Could grow: trackpad/scroll tuning, Safari/Finder power-user flags, screenshot subtypes, hot corners — but keep it to defaults the user actually wants, not a 300-line dump.

---

## Zero-friction torrent search

**Premise:** anywhere in the UI → global hotkey → terminal drops down → `tor-search query` → pick → downloading. Full friction analysis in `docs/12-scripts/07-torrent.md` § Streamlining.

### shape
1. launchd user agents (`KeepAlive`) for Jackett + `transmission-daemon` — no cold start, the big win.
2. iTerm2 Hotkey Window (built-in) as the global-hotkey terminal — zero code.
3. Optional: self-healing daemon start + query stash inside `tor-search`; fzf result picker; loop mode.

### open questions
- launchd plists tracked in the repo (machine-local paths — Jackett binary is gitignored) or documented per-machine in `meta/`?
- Does the iMac want transmission-daemon always-on, or on-demand?

### kill criteria
If the hotkey window goes unused after a few weeks, drop the launchd agents and keep plain `tor-search`.

---

## Doc link syntax — wikilinks vs standard markdown  (ONGOING — not deciding today, revisit later)

**Premise:** the kol-docs catalog + the Obsidian vault use Obsidian `[[wikilinks]]`. Outside Obsidian (mdcat, GitHub, pandoc) those render as raw text, and image **embeds** `![[img.png]]` don't render in the yazi mdcat preview at all (mdcat is CommonMark, `![[...]]` isn't). Surfaced while wiring mdcat as the `.md` previewer: should docs move toward standard markdown for portability? **Deferred.**

### where the conversation landed
- **Keep wikilinks** — Obsidian-native, concise; embeds + block-refs + autocomplete + rename-safety. Cost: raw text everywhere else; images invisible in mdcat.
- **Go full standard** (`[label](path.md)` / `![](img.png)`) — renders in mdcat/GitHub/pandoc. Cost: verbose, loses note-transclusion `![[note]]` (no CommonMark equivalent) + block-refs, and **diverges from the kol-docs `[[path|display]]` convention** (it's mandated in CLAUDE.md).
- **Split — the leaning option, not committed:** images as standard `![](...)` (render in mdcat *and* Obsidian), note links stay `[[...]]`. Snag: Obsidian's *Files & Links → "Use [[Wikilinks]]"* toggle is vault-wide, so flipping it to get standard image-embeds-on-paste *also* makes note links standard — so the split needs manual authoring discipline, not a setting.

### open questions
- Do we actually read image-heavy notes in the terminal? If not, the whole thing is moot.
- Is GitHub/pandoc rendering of these docs a real workflow, or only Obsidian + mdcat?
- If we ever switch: new-links-only via the toggle, or bulk-convert existing via the **Link Converter** community plugin?

### current state (no action taken)
- dotfiles `docs/` has ~**0** `![[...]]` image embeds and 1 standard `![](...)` image → nothing to convert there; the question is really about the broader vault + future authoring habit.
- No syntax changed, no plugin installed, no vault setting touched.

### kill criteria
If terminal/GitHub reading never becomes a habit, keep wikilinks as-is and close this — converting + diverging from the kol-docs convention isn't worth it for cosmetic link rendering.

---

Nothing here is committed. This is a thought exercise until items move to `llm-context/AGENT-CONTEXT.md`.
