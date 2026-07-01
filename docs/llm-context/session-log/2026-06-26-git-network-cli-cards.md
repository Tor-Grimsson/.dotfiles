# Session: four new `00-kol-cli` cards — Git, Network, Tailscale+Jellyfin, Storage

**Date:** 2026-06-26
**Agent:** Grim (Claude Opus, `~/.dotfiles`, iMac)
**Summary:** Added four `docs/00-kol-cli/` practical cards — `04-git-github`, `05-network-security`, `06-tailscale-jellyfin`, `07-storage-redundancy` — the synthesis/deep-dive layer over the per-tool docs. Anchored to the real setup (ssh hosts, live tailnet + Jellyfin server, B2 remote, actual disks), not generic dumps.

## Changes Made

### Files Added
- `docs/00-kol-cli/04-git-github.md` (`guide`) — git-vs-gh split; everyday **git syntax grouped by task** (look / branch / commit / sync / undo / stash / rebase); the **gh layer** (PRs, issues, CI runs, `gh api`); worked **workflows** (feature→PR→CI→merge, review a PR, hotfix, linear catch-up); a **worktree section** linking the full `14-git-worktrees` guide (not duplicated); a **Risks & when-not** table (work-losing commands + safe form — `--force-with-lease`, `reflog`, `clean -nd`, `revert` over rewriting shared history); quick reference.
- `docs/00-kol-cli/06-tailscale-jellyfin.md` (`guide`) — follow-up: after the user asked to "write up the setup," probed the live state and found the **whole stack already stood up** (Jellyfin *Skipholt* on the iMac, reachable over the tailnet + MagicDNS `tail485b10.ts.net`, firewall off). So it's an explain-it/use-it card — terms, **the `…ts.net:8096` URL decoded + how to change each part**, Tailscale CLI, users & devices, tips. Bumped `09-tailscale`/`10-jellyfin` `draft`→`active`. (First drafted this as a `05-network-security/11` playbook in the wrong folder — user wanted it in `00-kol-cli`; moved + deleted the stray.)
- `docs/00-kol-cli/05-network-security.md` (`guide`) — SSH + this machine's real `~/.ssh/config` hosts (`ubuntu-vm`, `github.com`, `orb`); SSH workflows (scp/rsync, `-L`/`-J`/`-D`, **remote logging** via `journalctl -fu` + tmux-on-remote); **SSH-over-Tailscale with its exact dependency chain** (both ends on the tailnet + MagicDNS + sshd/key, or Tailscale SSH); Termius as the mobile front door; the **Jellyfin invite-a-user reality** (no Plex-style email invite — admin creates each account, scope libraries, get the device on the tailnet via share-a-node, Quick Connect); **iperf3 the 9/10 way** (`-s`/`-c` + `-R`/`-P 4`/`-u -b`); arp-scan→nmap discovery pair; secrets (`~/.secrets` vs the `bw`/`bwenv` vault chain + the `ANTHROPIC_API_KEY` billing trap); risks table; quick reference.
- `docs/00-kol-cli/07-storage-redundancy.md` (`guide`) — deep dive on two-drive redundancy: **redundancy ≠ backup + 3-2-1**, RAID levels/implementation (incl. the macOS AppleRAID=HFS+, not-APFS caveat), the tool matrix (rsync / rclone / Disk Utility / Time Machine / CCC / Backblaze Personal vs B2), how sync works (size-mtime vs checksum, mirror vs copy vs bisync, delta, versioning, the `--delete` trap), file access, and an **A→Z two-8TB-drive demo** (unbox → format APFS → nightly versioned `rsync` mirror → encrypted B2 off-site; real RAID-1 as the alternative). Grounded in live state — `kolkrabbi:` B2 remote, macOS ships limited **`openrsync`** (→ `brew install rsync`), `kol-<type>-<GB>` disk naming.

### Files Modified
- `docs/INDEX.md` — **four** rows added to the **Quick reference** card table (04–07). Cards, not per-tool docs → **tool count unchanged (78)**.
- Reciprocal `related:` backlinks added to the source docs: `04-dev-languages/{12-gh,14-git-worktrees}`, `05-network-security/{01-nmap,02-arp-scan,03-bitwarden-cli,05-termius,07-iperf3,08-vault-to-env-pattern,09-tailscale,10-jellyfin}`, and `11-cloud-sync/01-rclone` (was `related: []`); plus cheatsheet↔cards. `09-tailscale`/`10-jellyfin` also point to `06`.
- **Drift fixed en route:** `05-network-security/01-nmap.md` `related:` pointed at the non-existent `06-iperf3` → corrected to `07-iperf3`. Also completed the `12-gh`↔`14-git-worktrees` reciprocity (gh now links worktrees back).

## Current State

### Working
- All 12 wikilink targets in the two cards resolve to real files (verified). New `04`/`05` auto-mirror to the kol-vault (relink denylist picks up new `NN-*` in `00-kol-cli/`).
- Cards reflect the live setup, but flag where it's still plan-not-live: the tailnet ACL/share-a-node deployment is the model, not yet drilled — the cards say so rather than pretending it's done. Bumped `09-tailscale`/`10-jellyfin` `draft`→`active` (content is trustworthy now; only the real deployment remains).

### Known Issues
- None outstanding.

## Next Steps
1. Once the Tailscale tailnet + Jellyfin sharing are actually exercised, tighten the card's "(plan, not yet drilled)" hedges into confirmed steps.
