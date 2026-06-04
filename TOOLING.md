---
title: dotfiles — tooling audit & sync
type: audit
status: active
updated: 2026-06-04
description: Snapshot of the brew + Claude tooling across the Intel iMac and Apple-Silicon MBP, the Brewfile drift, cross-arch portability bugs, per-tool rationale, and the sync plan.
audience: personal
tags:
  - project/dotfiles
  - domain/audit
  - domain/tooling
sources:
  - Brewfile
  - bootstrap.sh
  - scripts/transmission_scan.sh
  - ~/.claude/settings.json
  - brew leaves --installed-on-request (both machines)
covers:
  - formula + cask inventory
  - Brewfile-vs-reality drift
  - cross-arch portability bugs
  - per-tool reference (pdf, python, security, speech, dedup, media, shell, fs)
  - .claude as a dotfiles source-of-truth
  - watchlist of new brew candidates
related:
  - "[[Brewfile]]"
  - "[[bootstrap.sh]]"
  - "[[BITWARDEN-SETUP]]"
---

# dotfiles — tooling audit & sync

Snapshot taken **2026-06-04**. This repo is shared by two Macs that have drifted; this doc is the single source of truth for what's installed, why, and what still needs to converge.

> **Per-tool catalog:** every tool now has its own reference doc under [[docs/INDEX|docs/]] — 54 docs across 11 categories, each with verified links (website/repo/manual/brew) and a why/use/win/how/future write-up. This file is the **audit**; `docs/` is the **catalog**.

## The two machines

| | iMac ("this computer") | MBP ("that computer") |
|---|---|---|
| Arch | Intel | Apple Silicon |
| brew prefix | `/usr/local` | `/opt/homebrew` |
| Leans | media / server (transmission, handbrake, clamav, iperf3) | recon / mobile (nmap, arp-scan, whisper-cpp, zellij) |

The shared `Brewfile` is **unified** (chosen 2026-06-04): identical on both machines. Consequence — running `brew bundle` on the MBP also installs the media/torrent stack, and on the iMac also installs the recon stack. That's intentional.

> **Ghosts.** The iMac was set up first and has run longest, so its extra installs are *partly deliberate, partly ghosts* (stale ad-hoc installs that drifted in). The MBP is the fresher, cleaner machine. Because the Brewfile is unified, **prune the iMac's ghosts first** (`brew autoremove`, then eyeball the iMac-only leaves) — otherwise the next `brew bundle` propagates that cruft to the MBP.

## Drift: Brewfile vs reality

The old `Brewfile` listed 19 formulae; both machines had installed far more ad-hoc and never wrote it back. Three-way diff (old Brewfile · iMac leaves · MBP leaves):

| Formula | In old Brewfile | iMac | MBP | Verdict |
|---|:--:|:--:|:--:|---|
| arp-scan, bitwarden-cli, img2pdf, neofetch, nmap, pdf2svg, zellij | ✓ | — | ✓ | keep (MBP→both) |
| broot, imagemagick, jq, mpv, neovim, pipx, pngpaste, tmux, tree, yazi | ✓ | ✓ | ✓ | keep (shared core) |
| ffmpeg | ✓ | dep | dep | keep (also a dep) |
| node | ✓ | ✓ | — | keep (MBP uses pnpm-managed; see below) |
| **pnpm** | — | ✓ | ✓ | **added** |
| **rclone** | — | ✓ | ✓ | **added** |
| **uv** | — | — | ✓ | **added** |
| **whisper-cpp** | — | — | ✓ | **added** |
| **clamav** | — | ✓ | — | **added** (quarantine) |
| **handbrake, iperf3, jdupes, transmission-cli, watch** | — | ✓ | — | **added** |
| **powerlevel10k, zsh-completions, zsh-syntax-highlighting** | — | ✓ | — | **added** (see shell note) |
| pkgconf, poppler | — | ✓ | dep | **excluded** — arrive as deps |

Net: Brewfile went from 19 → 34 formulae. Deps (`pkgconf`, `poppler`) are deliberately *not* listed — `pdf2image`/`yazi`/`imagemagick` pull them.

---

## Tool reference by category

### Filesystem & navigation
- **tree** — static recursive tree print. No interaction.
- **yazi** — full TUI file manager (Rust, async I/O). Image/PDF previews need `ffmpeg`/`poppler`.
- **broot** — tree overview + fuzzy jump + run commands. Lighter than yazi.

### Monitoring
- **watch** — runs a command on an interval (default 2 s), redraws fullscreen. procps-ng 4.0.6. *Not* a filesystem tool — you use it as `watch -n2 transmission-remote -l` to poll torrents. General-purpose.

### Python: uv vs pipx
Both manage Python, different jobs — they overlap only at "run a CLI tool".

| | **pipx** | **uv** |
|---|---|---|
| Point | Install standalone Python **CLI apps**, one isolated venv each | All-in-one Python **project + dep + version** manager (Rust, 10–100× faster) |
| Purpose | Keep tools (ruff, httpie, yt-dlp) off global site-packages, no cross-tool conflicts | Replace pip + pip-tools + virtualenv + pyenv + pipx in one binary |
| Practical | `pipx install ruff` · `pipx run cowsay` | `uv venv` · `uv add` (project deps) · `uv python install 3.12` · `uvx ruff` / `uv tool install ruff` |

`uv tool` / `uvx` does exactly what pipx does. **uv is the modern superset** — recommend consolidating onto uv and migrating pipx tools (`pipx list` → reinstall via `uv tool install`), then dropping pipx. Kept both for now to avoid breaking muscle memory.

### PDF & images
- **pdf2svg** — PDF page → SVG **vector** (Inkscape/editable pipeline).
- **img2pdf** — images → PDF, **lossless** (embeds JPEG/PNG, no recompression). Scan-to-PDF.
- **pdf2image** — *dropped from the Brewfile 2026-06-04* — its `pdffonts`/`pdftoppm` binaries clash with poppler's symlinks. For PDF→raster use poppler's `pdftoppm`/`pdftocairo`, or the Python `pdf2image` lib via pipx/uv.
- **imagemagick** — swiss-army raster convert/resize/composite; can rasterize PDF with ghostscript.
- **poppler** — PDF render lib + CLI (`pdftotext`, `pdftoppm`, `pdfinfo`). Dep of pdf2image.
- **pngpaste** — clipboard PNG → file.

Note: `pdf2svg` (was MBP) and `pdf2image` (iMac) point opposite directions (vector vs raster); unified Brewfile gives both to both. Candidate add: **tdf** (TUI PDF viewer) — see watchlist.

### Network & security
- **nmap** — port/host/service scanning, NSE scripts.
- **arp-scan** — layer-2 ARP discovery + MAC-vendor fingerprinting on the local LAN.
- **iperf3** — active throughput measurement (TCP/UDP/SCTP) between two hosts. Network diagnostics, not security.
- **bitwarden-cli** (`bw`) — vault access + secret scripting from the terminal.
- **clamav** — antivirus; here it's wired to the torrent quarantine, see Media.

### Speech (separate — not security)
- **whisper-cpp** — local speech-to-text. OpenAI Whisper reimplemented in C/C++ (ggml), CPU/Metal-accelerated, no API. Transcribe audio/video → text/subtitles: `whisper-cli -m model.bin audio.wav`. Needs a model file downloaded first. MBP only.

### Media & torrents
- **mpv** — terminal-friendly player.
- **ffmpeg** — convert/encode/stream; dep of mpv/handbrake/whisper-cpp.
- **handbrake** — `HandBrakeCLI` preset-driven transcoder.
- **transmission-cli** — BitTorrent daemon/client; drive it with `transmission-remote`.
- **clamav** — antivirus, **not** media per se. Driven by `scripts/transmission_scan.sh`: on torrent completion, `clamscan -r --move=_Quarantine` the download, log results, strip `.exe/.lnk/.url/.nfo`, notify. Update defs with `freshclam`.

### Shell & prompt
- **tmux** — multiplexer.
- **powerlevel10k** — zsh prompt theme. `.p10k.zsh` config is vendored in `shell/`.
- **zsh-completions**, **zsh-syntax-highlighting** — zsh plugins.

⚠️ **Duplication:** the MBP gets p10k + zsh plugins via an **oh-my-zsh custom plugin**, while the iMac installed them via **brew**. The unified Brewfile now installs the brew copies on both. Pick one source — recommend brew on both and drop the oh-my-zsh copies — so they can't drift.

### Dev
- **neovim** · **node** · **pnpm** · **jq** — standard. `pnpm` can self-manage node (`pnpm env use`), which is why the MBP had no brew `node`. The unified Brewfile installs brew `node` everywhere; harmless, but drop it from the Brewfile if you'd rather let pnpm own the runtime on the MBP.

### Dedup — the real discussion
You already run **jdupes**. Here's the full landscape:

| Tool | Form | Matches | Best for |
|---|---|---|---|
| **jdupes** *(have)* | CLI | exact (size+hash) | fast exact-dupe sweeps; dedupe/hardlink/summarize |
| fdupes | CLI | exact | the original — slower, superseded by jdupes. **skip** |
| **rmlint** | CLI | exact + empty dirs/files, broken symlinks, dupe dirs | **safe mass cleanup** — emits a reviewable shell script before deleting; APFS/btrfs reflink |
| **czkawka** | GUI + CLI | exact **and fuzzy** — similar images (perceptual), similar video/music, broken files | **media libraries / near-dupes** |
| dupeguru | GUI | fuzzy name/content/music | older, less maintained; czkawka supersedes. **skip** |

**In the Brewfile now** (added 2026-06-04): **jdupes** (quick exact CLI), **rmlint** (scripted, reflink-aware mass purge — emits a review script before deleting), **czkawka** (`czkawka_cli` — fuzzy near-dupes for media). Skipped: fdupes/dupeguru (superseded). Bonus, *not* added: **fclones** (Rust — the fastest pure-CLI *exact* deduper; add it if jdupes ever drags on huge trees).

### Build dependencies (not deliberate installs)
- **pkgconf** — ships `.pc` metadata so compilers find a lib's cflags/link flags. Pulled by imagemagick/poppler.
- **poppler** — PDF render lib (+ CLI). Pulled by pdf2image and yazi previews.
- **python@3.x** — pulled by many formulae; *not* the pipx/uv-managed Python. A dependency, not a deliberate install.

All three omitted from the Brewfile on purpose.

---

## GUI / casks

| Cask | Purpose |
|---|---|
| firefox@developer-edition | Browser |
| iterm2 | Terminal |
| visual-studio-code | Code editor |
| raycast | Launcher / command palette |
| hiddenbar | Hide menu-bar items |
| stats | Menu-bar system monitor |
| marta | Two-pane file manager |
| namechanger | Batch file renaming |
| keka | Archiver |
| disk-drill | File recovery |
| appcleaner, pearcleaner | App uninstallers |
| kap | Screen recorder |
| keycastr | Keystroke visualizer (screencasts) |
| openscreen | Screen recorder + video editor (siddharthvaddem tap) |
| obsidian | Markdown knowledge base |
| orbstack | Docker / Linux VMs |
| termius | SSH client |
| bitwarden | Password manager (desktop) |
| font-meslo-lg-nerd-font, fontgoggles | Font + font viewer |

> **MBP casks folded in 2026-06-04.** Captured `brew list --cask` from the MBP and added the three it had that the iMac didn't: `visual-studio-code`, `keycastr`, `openscreen` (via `tap "siddharthvaddem/openscreen"`). Cask sets are now reconciled across both machines.

> **Removed from the Brewfile 2026-06-04:** `codex`, `atv-remote`, `mucommander`, `transnomino`, `alt-tab`. They're dropped from the manifest (so they won't propagate to the MBP) but **still installed locally** — `brew uninstall --cask <name>` if you want them actually gone.

---

## Cross-arch portability bugs

Shared dotfiles across Intel (`/usr/local`) + Apple Silicon (`/opt/homebrew`) means **no hardcoded brew prefixes**. Two live bugs found:

1. **`~/.claude/settings.json` hooks** once hardcoded a pinned Intel node path. **Resolved 2026-06-04** — those hooks (the caveman setup, the only hook user) were removed from the repo entirely, so there's no hook node path left to break across arches.
2. **`scripts/transmission_scan.sh`** hardcodes `/opt/homebrew/bin/clamscan` — but transmission+clamav run on the **Intel iMac** (`/usr/local`), so the script currently can't find clamscan there. **Fixed**: changed to bare `clamscan`.

Rule going forward: use the command name (rely on PATH) or `$(brew --prefix)/bin/...`, never a literal prefix.

## Dangling tap
`maniacsan/torrra` was tapped on the iMac but torrra was never installed (not in pip/pipx/brew). **Untapped 2026-06-04** (`brew untap maniacsan/torrra`).

---

## .claude as a dotfiles source-of-truth

**Done 2026-06-04** — to stop the Claude config drifting between machines (and to get the skills/agents onto both), these now live in the repo under `claude/`, symlinked back into `~/.claude/`. `bootstrap.sh` re-creates the links on a fresh machine:

```
~/.dotfiles/claude/
  CLAUDE.md         # global personality / rules
  settings.json     # portable (bare `node`); no hooks — caveman fully removed
  skills/           # kol-bucket, kol-docs, init-agent-context(+sync), init-scaffold,
                    #   gsap-* (8), algorithmic-art, glif-art
  agents/           # kol-{color,div,docs,type}-agent — KOL design-system subagents
  packages/         # shared skill deps: bucket (rclone wrapper → ~/.local/bin),
                    #   kol-docs-framework, init-agent-context-templates, algorithmic-art-templates
  hooks/            # empty (.gitkeep) — caveman hooks removed
  commands/         # placeholder (.gitkeep)
  output-styles/    # placeholder (.gitkeep)
```

**Not synced** (runtime / machine-local / derivable): `projects/` (memory + sessions), `history.jsonl`, `todos/`, `statsig/`, `shell-snapshots/`, `plugins/` (re-installed from the marketplace via `settings.json`), `cache/`, `backups/`, `file-history/`.

> **Skill dependencies live in `claude/packages/`** — the kol-docs `_framework` (1.1 MB) and the init-agent-context templates are *dependencies*, not skill internals, so they sit in `packages/` and the skills reference them by path (copied from the canonical kol-system source; re-sync via `init-agent-context-sync`).

---

## Watchlist — new brew candidates (from 2026-06-04 `brew update`)

| Candidate | What | Verdict |
|---|---|---|
| **tdf** | TUI PDF viewer | **try** — fits the PDF toolchain |
| bun | JS runtime/bundler/test | optional — you're on pnpm/node |
| gixy | NGINX config security analyzer | optional — MBP security kit |
| exo / mirai / vmlx | run local AI models on Apple Silicon | interesting (MBP), not needed |
| cc-pocket / open-island / ping-island | remote/status companions for Codex/Claude agents | evaluate — you already run `codex` |
| rcmd | Right-Cmd app switcher | skip — you have alt-tab + raycast |
| mister-plimsoll | disk-fullness menu-bar monitor | skip — you have stats + disk-drill |

---

## Open items

**Done this pass (2026-06-04):**
- [x] `Brewfile-mirror.txt` kept byte-identical to `Brewfile` (maintain on every change).
- [x] Untapped `maniacsan/torrra`.
- [x] Dotfiled `~/.claude` (CLAUDE.md, settings.json, skills, hooks + commands/agents/output-styles placeholders); settings.json node path made portable.
- [x] Fixed `transmission_scan.sh` clamscan path.
- [x] Trimmed 5 casks from the Brewfile (codex, atv-remote, mucommander, transnomino, alt-tab — still installed locally).
- [x] Added dedup CLIs `rmlint` + `czkawka`.
- [x] Folded in MBP casks (`visual-studio-code`, `keycastr`, `openscreen` + tap); cask sets reconciled.
- [x] `brew autoremove` preview — no orphaned deps to prune.
- [x] Replaced `neofetch` → `fastfetch` (neofetch was pulled from Homebrew; the bundle failed on it first).

**Bundle conflicts surfaced 2026-06-04 (one-time fixes, run on the iMac):**
- [ ] `brew link --overwrite bitwarden-cli` — an old `bw` already sits at `/usr/local/bin/bw`.
- [ ] `brew install --cask hiddenbar --force` — *optional*; takes over the existing v1.8 app (cask wants 1.10).
- [ ] `brew trust --cask siddharthvaddem/openscreen/openscreen` — silence the untrusted-tap warning (becomes mandatory in Homebrew 6.0).
- [x] Dropped `pdf2image` (poppler symlink clash) and `cask "macfuse"` (kext sudo dance) from the Brewfile.

**Still open:**
- [ ] `rm -rf ~/.claude-server-commander` — orphaned Desktop Commander MCP logs (last used 9 Mar; MCP no longer wired).
- [ ] macfuse is left out of the bundle — `brew install --cask macfuse` by hand if a fresh machine needs it.
- [ ] Review iMac-only *leaves* for unwanted ghosts (autoremove only catches orphaned deps, not unwanted explicit installs).
- [ ] Resolve p10k / zsh-plugin duplication — brew vs oh-my-zsh, pick one.
- [ ] Decide pipx → uv consolidation.
- [ ] Decide whether brew `node` stays on the MBP (vs pnpm-managed).
- [ ] Many packages outdated on both (`brew update` 2026-06-04) — `brew upgrade` at your discretion; not run here.
- [ ] Optional adds: tdf (TUI PDF viewer); fclones (faster exact dedup).
- [ ] Optionally `brew uninstall --cask` the 5 trimmed apps if you want them gone locally.
- [x] Removed deprecated `tmate` + `qlstephen` (brew was disabling both).
