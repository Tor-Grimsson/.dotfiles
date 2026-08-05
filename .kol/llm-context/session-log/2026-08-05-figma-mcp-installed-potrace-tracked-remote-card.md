# Session: Figma MCP wired in, potrace tracked, and the remote card learns how an agent actually connects

**Date:** 2026-08-05
**Agent:** Claude Code (Grim) — MBP
**Summary:** The Figma MCP server went from "researched" to connected and writing, potrace turned out to be installed-but-untracked, and `ref-remote` gained the three things this session proved about reaching the iMac.

## Changes Made

### Files Modified
- `brewfile-cli:112` — **new line** `brew "potrace"` under PDF & images; it was already on the machine and in neither brewfile
- `ref/remote.md` — `## ssh` gained the one-shot form + `-o BatchMode=yes` + `-o ConnectTimeout=8`; `## smb` gained the `.local`-over-tailscale failure; **new `## volumes` section** with biskup's four disks and an `[e]` block
- `claude/settings.json:38` — `figma@claude-plugins-official` in `enabledPlugins`, written by the installer itself
- `docs/documentation/07-pdf-images/INDEX.md` — potrace row, 4 → 5 tools
- `docs/documentation/04-dev-languages/INDEX.md` — Figma MCP row, 11 → 12 tools
- `docs/documentation/INDEX.md` — both category counts and descriptions
- `docs/documentation/07-pdf-images/{01-imagemagick,03-pdf2svg}.md` — `related:` cross-refs to potrace
- `docs/documentation/04-dev-languages/13-framer-agent.md` — `related:` cross-ref to the Figma doc

### Files Added
- `docs/documentation/04-dev-languages/14-figma-mcp.md` — the decision record: remote vs desktop, the Full-seat wall on writing, the client allowlist, the tool surface
- `docs/documentation/07-pdf-images/05-potrace.md` — the PNM/BMP-only input wall and the ImageMagick pipe that clears it

### Installed (by the user, not the agent)
- `figma@claude-plugins-official` — Claude Code plugin, OAuth'd, connected as Kolkrabbi with a Full seat on three teams
- `fonttools 4.63.0` via `uv tool install` — glyph-level work: cmap coverage scans, outline extraction

## Current State

### Working
- Figma MCP writes to the canvas — `use_figma`, `upload_assets`, `get_screenshot` all exercised for real against a live client file
- `ref --lint` clean at **22 cards**; `ref-remote volumes` and `ref-remote ssh` both render
- The documented potrace pipe was run, not quoted — `magick … pnm:- | potrace -s -o out.svg -` produced a valid 736-byte SVG
- Non-interactive SSH to the iMac (`biskup@100.116.173.43`) reads the 4TB font library — 7,344 font files, 428 families

### Known Issues
- **A duplicate `.claude/settings.json` sits at the repo root.** The plugin install wrote the enablement at *both* user and project scope, and the project one resurrects the repo-local `.claude/` retired 2026-07-03. The move to `_tmp/` was **denied by a permission classifier**, so it is still there. Cosmetic — user scope is what makes the plugin work everywhere.
- `tmux/layout-picker.sh:3` still says `prefix C-d`; the live bind is `prefix C-o`. Carried from 2026-08-04.

### Two findings worth keeping
1. **A Claude Code plugin self-tracks.** `~/.claude/settings.json` is the symlinked `claude/settings.json`, so installing a plugin writes its own entry into the repo. Nothing to pre-add, nothing to sync — the same mechanism `rust-analyzer-lsp` already used.
2. **mDNS does not route over Tailscale.** Finder's `smb://Thordur's iMac.local` fails while `smb://100.116.173.43` works. The Finder error reads as "server unavailable" and is actually name resolution. Now carded.

### The report-shape fault this session kept hitting
The command the user asked for was buried under a header card, a table and a footer — three times, on a yes/no question, until he had to shout for it. The rule broken is the existing one: **a one-line answer skips the shape entirely**. Restating that the command *had* been given was worse than the burying.

## Next Steps
1. Retire the root `.claude/settings.json` to `_tmp/` when the classifier allows it — user scope already carries the plugin.
2. Fix `tmux/layout-picker.sh:3` — a one-line comment naming the wrong bind.
3. `bin/font-sheet` is a candidate: the ImageMagick "render a word in every font file without installing any" script proved itself and currently lives only in a client repo.
