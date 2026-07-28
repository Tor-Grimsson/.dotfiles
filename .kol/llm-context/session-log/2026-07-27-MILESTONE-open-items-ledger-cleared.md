# 🏁 Milestone: Open-items ledger audited and cleared

**Date:** 2026-07-27
**Agent:** Grim (Fable 5)
**Arc:** The AGENT-CONTEXT "Open items (live)" ledger — 9 unchecked items + 12 closed strike-through rows accumulated since 2026-06-04 — audited against reality and taken to zero.
**Delivered:** An empty ledger. Every item verified on disk before its verdict; one load-bearing rule rescued into Known gotchas before the sweep.

## What closed
- `rm ~/.claude-server-commander` → **done** (dir already gone from disk; item contradicted a closed row two lines below it)
- `~/.zshrc-bak` delete-after-settling → **done** (file already gone)
- Optional adds czkawka/tdf/fclones → **resolved** (czkawka in `brewfile-cli:64` all along; tdf/fclones already parked in TOOLING.md — line was a duplicate)
- Skills cut 2026-06-04 re-add review → **parked** at `llm-plan/01-parking-lot.md` (~2 months cold; revisit only if a client/publication workflow returns)
- Vault dedup (B2/rclone overlap) → **closed as noise** (labeling hygiene, zero operational impact; key lives in untracked `~/.config/rclone/rclone.conf`)
- pipx → uv consolidation → **closed as answered-by-reality** (both in `brewfile-cli` deliberately: uv for projects, pipx solely carries edge-tts — verified)
- Home-dir declutter → **dropped** (June cosmetic wishlist, lived without it for 2 months)
- MCP gated handoff → **closed as solved-by-reality** (its blocker — glif token not reaching the env — is moot: token wired in `~/.claude.json`, glif MCP connected and working this session; handoff file stays in `session-bridge/` as passive history, its own gate makes it inert)
- `brew upgrade` when convenient → **closed as chore-not-issue** (user's own cadence; TOOLING.md owns drift)
- 12 `[x]` strike-through rows → **swept** (each already archived in its session log)
- **Rescued:** the ANTHROPIC_API_KEY-vs-subscription billing rule (lived only inside dead items) → now a Known gotcha in AGENT-CONTEXT

## The arc (brief)
- User flagged the ledger as stale; audit verified every checkable claim on disk (ls/grep/pipx list) rather than trusting the text.
- First pass closed the provably-dead and swept the closed rows; second pass killed the three "decision" items the user called noise — all three had been answered by how things settled.
- Final pass proved the last two needed no user input either (glif token already delivered; brew upgrade is a chore) and emptied the section.
- Session-to-session threads (tailscale node confirm, reboot-protocol verify) were never Open-items — they live in the "Last updated" chain with their own arcs.
