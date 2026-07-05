---
title: Remote dev workflow — editor, git/gh, secrets, collaboration
type: guide
status: active
updated: 2026-07-05
description: Doing real work on a box you only reach over SSH — nvim's clipboard gap through tmux, git/gh auth without a synced macOS Keychain, unlocking the Bitwarden vault with no GUI, the Claude Code API-key trap, and running a two-GitHub-account fork/PR loop to practice the collaboration flow.
audience: internal
aliases:
  - remote-dev-workflow
tags:
  - domain/network
  - domain/tooling
  - pattern/cli
related:
  - "[[INDEX|Remote machine]]"
  - "[[01-ssh-toolkit|SSH toolkit]]"
  - "[[04-dev-languages/10-neovim-config|Neovim config]]"
  - "[[04-dev-languages/12-gh|GitHub CLI]]"
  - "[[00-kol-cli/05-network-security|Network, remote & secrets]]"
---

# Remote dev workflow — editor, git/gh, secrets, collaboration

## Purpose

`bootstrap-cli.sh` gets a foreign/SSH box provisioned (see [How this repo works](../21-dotfiles/INDEX.md)). This is the next layer: actually working on it — nvim as the editor, `git`/`gh` for push/pull/PRs, secrets with no GUI available, and a two-GitHub-account setup for practicing the real collaboration flow.

## Prerequisites

- `bootstrap-cli.sh` already run on the box (nvim, tmux, gh, bw all installed + configured).
- [SSH toolkit](01-ssh-toolkit.md) for the transport side (auto-attach tmux, agent forwarding) — this doc assumes you're already inside a session.

## Walkthrough

### 1. Secrets with no GUI — `bw` still works

It looks like `bwu`/`bwl` (`shell/.zshrc:135`) need a GUI, because on the daily-driver Macs they read the master password from a Keychain item created with `security add-generic-password -T ""` — deliberately set up so **every** read pops a macOS auth dialog. That item was never created on a fresh remote box, though, and the alias already accounts for that:

```sh
bwu() {
  local pw; pw="$(security find-generic-password -a "$USER" -s bw-master -w 2>/dev/null)"
  if [ -n "$pw" ]; then
    export BW_SESSION="$(BW_PASSWORD="$pw" bw unlock --passwordenv BW_PASSWORD --raw)"
  else
    export BW_SESSION="$(bw unlock --raw)"
  fi
}
```

No Keychain item → `$pw` is empty → falls straight to `bw unlock --raw`, a plain password prompt at the SSH terminal. No GUI anywhere in that path. `bwl` calls `bwu` automatically if no session is set.

**What you actually need on a fresh box:**
1. `bw config server https://vault.bitwarden.eu` (if the vault is EU — same as `meta/BITWARDEN-SETUP.md` step 1).
2. `bw login you@email.com` once — 2FA (if enabled) is a code typed at the terminal, not a browser popup.
3. Just use `bwu` / `bwl` / `bwenv` from then on — typing the master password once per new SSH session.

Skip `BITWARDEN-SETUP.md`'s step 3 (storing the password in Keychain) entirely — there's no local session to gate with Touch ID/login-password on a box you're not physically at, and the fallback path above already works without it.

`~/.secrets` (untracked, `chmod 600`, sourced by `.zshrc`) is still there as the simpler model for anything you'd rather not fetch from the vault every shell.

> **The one trap that repeats everywhere this comes up:** never export `ANTHROPIC_API_KEY` in `~/.secrets` on a box running Claude Code on a subscription (Max/Pro) — an exported key makes `claude` bill the **API** instead. `bootstrap-cli.sh` installs `claude` on every box it touches, including foreign ones, so this applies here too.

### 2. Git/GitHub auth — skip SSH, use `gh` over HTTPS

The tracked `ssh/config`'s `Host github.com` block is tied to a specific key + this repo owner's macOS Keychain (`UseKeychain yes`) — it doesn't carry over to a different Mac's Keychain, foreign box or not.

Cleaner for a box like this: authenticate `gh` once, let it be the git credential helper.

```sh
gh auth login          # pick GitHub.com → HTTPS → "Login with a web browser"
                        # — the browser step happens on ANY device you open the
                        # printed URL on; the remote box itself needs no browser
gh auth setup-git       # git push/pull now authenticate via gh's stored token
```

No new SSH key to generate and register just for a box you might throw away. `gh auth status` / `gh repo view --web`... actually, skip `--web` entirely on this box:

**Avoid `--web` / `gh browse` on a headless box** — both try to open a literal browser process on the machine you're SSH'd into, which either fails or does nothing useful with no logged-in GUI session there. Stick to text output: `gh pr view`, `gh pr diff`, `gh pr checkout <n>`, `gh run watch`.

### 3. Clipboard over SSH + tmux

**tmux's own copy mode (`prefix [` → `y`) is fixed** (2026-07-05): `tmux/.tmux.conf` now sets `set -g set-clipboard on` + `set -g allow-passthrough on`, and the `y`/mouse-drag bindings use `copy-selection-and-cancel` instead of piping to `pbcopy`. tmux relays the copy via **OSC 52** to the outer terminal (iTerm2 supports it), so a yank from a remote tmux session lands on *this* Mac's clipboard, not the remote box's. Works identically whether tmux is local or remote — nothing to think about, just `y`.

**nvim's own yank (`"+y`, `unnamedplus`) is still the open gap.** `nvim/lua/grim/core/options.lua:32` sets `opt.clipboard:append("unnamedplus")` — nvim shells out to `pbcopy`/`pbpaste` directly, bypassing tmux's relay entirely. On a remote box that still lands in *that box's* clipboard, invisible to you. Fix (not yet applied): give nvim 0.10+'s built-in OSC52 clipboard provider via `vim.g.clipboard`, or the `ojroques/vim-oscyank` plugin. Until then, `"+y` inside nvim only moves text within nvim's own registers — copy through **tmux's** copy mode instead (`prefix [`, select, `y`) when you need something out of a remote nvim session onto your local clipboard.

### 4. Two GitHub accounts — practicing the real collaboration flow

Don't try to run two identities through one shared clone — fighting `git`/`gh`'s single-active-account model teaches the wrong lesson. Set it up the way an actual outside contributor would:

1. `gh auth login` as account **A** (repo owner), then `gh auth login` as account **B** (contributor) — `gh` stores both; `gh auth switch -u <username>` picks which is active.
2. **Account B forks the repo** on GitHub. Clone **the fork**, not the original — that clone is where all of B's work happens.
3. Inside that clone, set the identity locally (no `--global`, so it doesn't leak into other clones):
   ```sh
   git config user.name  "B's name"
   git config user.email "B's email"
   ```
4. Push a branch to the fork, then `gh pr create` — this opens a real PR from B's fork branch against A's original repo. Exactly the external-contributor flow, not a simulation of it.

If SSH (rather than `gh`+HTTPS) is the git transport for this, account B needs its own key + an `IdentitiesOnly yes` host alias — see [SSH toolkit § 4](01-ssh-toolkit.md#4-identitiesonly--per-identity-keys--multiple-accounts-one-machine).

## Troubleshooting

- **First `nvim` launch feels slow / spams messages.** Normal — `mason.nvim` installs LSP servers per filetype on first open, and treesitter compiles parsers. Needs network; one-time cost per box.
- **Everything feels laggy over the connection.** Interactive UI (telescope live-grep, nvim-tree toggling) round-trips every keystroke — a genuinely high-latency link (satellite, poor wifi) will feel it no matter what's configured. Not fixable from this side; a lower-latency network path is the only lever.

## Related
- [SSH toolkit](01-ssh-toolkit.md) — the transport layer this workflow runs on top of.
- [Neovim config](../04-dev-languages/10-neovim-config.md) · [GitHub CLI](../04-dev-languages/12-gh.md)
