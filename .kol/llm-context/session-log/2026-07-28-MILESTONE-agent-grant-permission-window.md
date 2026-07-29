# 🏁 Milestone: agent-grant — time-boxed permission windows

**Date:** 2026-07-28
**Agent:** Grim (Claude Code)
**Arc:** A keybind that briefly grants the agent read-git + download rights, then takes them back by itself.
**Delivered:** `prefix g` toggles a self-expiring window (default 15m) of read-only git + downloads, enforced by a new PreToolUse gate; visible while open (statusline badge + per-turn reinforce inject); documented as agent-system module 11 and lobbied for porting.

## What closed

- **The settings deny** → done: `Bash(git:*)` deny rules left `settings.json` (deny list now empty) for `claude/hooks/git-gate.sh` — runtime-liftable, repo stays clean on every toggle.
- **CLI + flag contract** → done: `bin/agent-grant` (`[min]`/`off`/`status`/`toggle`); flag = one line, expiry epoch, at `~/.claude/.agent-grant` — untracked, self-deleting when stale, no timers anywhere.
- **Gate semantics** → done: closed = deny with unlock hint; open = allow read-only git (`log/show/diff/status/blame/branch/remote/…` + `clone/fetch`) and `wget`/`curl`; git writes denied **always**; chained/`$(…)`/multiline smuggling → "ask". The parser only downgrades (allow→ask→deny), never widens; bare-path `/usr/bin/git` falls to the normal prompt.
- **Agent awareness + visibility** → done: `agent-reinforce.sh` injects "window open, Nm left" every turn while active; statusline shows `[GRANT git Nm]` (block survives the same-day humpty statusline rework).
- **Keybind + reference** → done: `bind g` in `.tmux.conf` (C-g was lazygit, G was move-window — plain g was free); keys card `## #tmux #claude`; `02-tmux.md` synced same turn.
- **Docs + porting** → done: module doc `docs/kol-agent-system/11-grant.md` + INDEX row (11 · Trust) + map hooks line; porting note at kol-dumpty `lobby/agent-grant.md` (path trued after the repo's same-day rename from kol-humpty-dumpty).
- **Verification** → done: 18-case verdict battery green against a sandboxed flag dir; one real bug caught live — the heredoc ate the hook's stdin JSON, fixed by env handoff (`HOOK_INPUT`).
- **Arming** → done: recorded as user routine — one Claude Code restart snapshots the new PreToolUse hook, `prefix r` loads the bind. Nothing pending on the agent.

## The arc (brief)

- One session, one load-bearing move: a deny in tracked settings can't be lifted at runtime without dirtying the repo, and deny beats allow everywhere — so the block became a hook that reads a flag per tool call. Grant/revoke is instant, expiry is arithmetic.
- Three consumers (gate, reinforce, statusline) share the same 3-line freshness check on one flag-file contract; that contract generalizes to any "never, except briefly" permission — which is exactly what the lobby note stages for the jabberwocky family.
- Spans this log only; prior state: session 42 (`2026-07-28-alpha-dashboard-width-yellow-hints.md`), with the humpty arc (43) running in a parallel session.
