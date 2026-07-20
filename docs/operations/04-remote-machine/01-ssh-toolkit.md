---
title: SSH toolkit — config power features & alternative tools
type: guide
status: active
updated: 2026-07-11
description: What actually extends plain `ssh` — the ~/.ssh/config directives worth knowing (auto-attach tmux on connect, ControlMaster, ProxyJump, agent forwarding) and the third-party tools people reach for beyond it (mosh, autossh, Eternal Terminal, sshrc, sshfs).
audience: internal
aliases:
  - ssh-toolkit
  - ssh-power-features
tags:
  - domain/network
  - pattern/cli
related:
  - "[[INDEX|Remote machine]]"
  - "[[02-remote-dev-workflow|Remote dev workflow]]"
  - "[[03-tailscale-remote-access|Tailscale SSH + mosh]]"
  - "[[05-network-security|Network, remote & secrets]]"
  - "[[09-tmux-tips|tmux tips & tricks]]"
---

# SSH toolkit — config power features & alternative tools

## Purpose

Plain `ssh user@host` is one command out of a much bigger surface. This is the layer above it: `~/.ssh/config` directives that change what a connection *does* (auto-attach a session, reuse auth, hop through a bastion, forward your local keys), and the point at which a different tool altogether is the better answer (roaming networks, tunnels that must stay up, a box you don't want to configure at all).

## Prerequisites

- OpenSSH client (macOS built-in — `ssh -V` to check).
- tmux, already in `brewfile-cli`, for the session-persistence pattern below.
- This machine's real config lives at `ssh/config` (symlinked to `~/.ssh/config`) — `ubuntu-vm`, `github.com`, an `Include` for OrbStack, and (as of 2026-07-05) the `acyr` block below, live. Everything else here is additive to that.

## Walkthrough

### 1. Auto-attach tmux on connect — the single best upgrade, adopted

Instead of `ssh host` then typing `tmux new -A -s main` every time, put the second step *in the SSH config* so one command does both. Live in `ssh/config` since 2026-07-05:

```sshconfig
Host acyr
  HostName 192.168.1.23
  User acyr
  RemoteCommand tmux new -A -s main
  RequestTTY yes
  ForwardAgent yes
```

`ssh acyr` now drops you straight into a tmux session named `main` — created if it doesn't exist, reattached if it does (`new -A` = new-or-attach). Disconnect however you want (close the laptop, network drops), `ssh acyr` again picks up exactly where you left off. This is the real answer to "list/resume my SSH sessions" — see [[09-tmux-tips#Session tricks|tmux tips → Session tricks]] for the full session-command reference (`tmux ls`, `tmux a -t <name>`, etc.), this just automates the "get into one" step.

One gotcha: `RemoteCommand` replaces the default shell — if you ever need a plain shell on that host (no tmux), `ssh -o RemoteCommand=none acyr` overrides it for one connection.

**Usage example — first connect, work, drop the connection, come back:**

```sh
$ ssh acyr
# → lands in tmux session "main" (created fresh — first connect)

[main] $ nvim some-file.lua
# ... editing, close the laptop lid, wifi drops, whatever ...

# later, from anywhere:
$ ssh acyr
# → same "main" session, nvim buffer still open, exactly as left it

$ tmux ls           # (run from inside a session, on the remote)
main: 1 windows (created Sat Jul  5 ...)  (attached)
```

No `tmux new`/`tmux a` ever typed by hand — the config did both.

### 2. ControlMaster / ControlPath / ControlPersist — connection reuse

Different problem: not resuming a session, just skipping repeated auth handshakes to the *same* host.

```sshconfig
Host *
  ControlMaster auto
  ControlPath ~/.ssh/sockets/%r@%h-%p
  ControlPersist 10m
```

Needs `mkdir -p ~/.ssh/sockets` once (the directory isn't created automatically). First connection to a host opens the real session; every `ssh`/`scp`/`git` to that same host for the next 10 minutes (from *any* terminal) reuses it — no repeated key/2FA prompt, near-instant connect.

```sh
ssh -O check host     # is a master connection alive for this host?
ssh -O exit host       # kill it
ssh -O stop host       # stop accepting new multiplexed connections; existing stay up
ls ~/.ssh/sockets/      # every live control socket, one per host — the closest thing to a "list"
```

Worth it if you connect to the same host often in a session (repeated `scp`/`git fetch`/quick commands). Skip it if you mostly open one long-lived tmux session per visit — nothing left to reuse.

### 3. ProxyJump — bastion hosts

```sshconfig
Host inner-host
  HostName 10.0.0.5
  ProxyJump bastion
```

`ssh inner-host` transparently hops through `bastion` first. Equivalent one-off: `ssh -J bastion inner-host`. Chains: `ProxyJump bastion1,bastion2`.

### 4. IdentitiesOnly + per-identity keys — multiple accounts, one machine

If more than one SSH key is loaded in the agent (e.g. two GitHub accounts — see [[02-remote-dev-workflow|remote dev workflow]]), SSH will offer them **in load order** until the server accepts one — noisy, and sometimes the wrong key gets offered first and the server counts the failed attempt. Pin it explicitly:

```sshconfig
Host github.com-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
  IdentitiesOnly yes
```

`IdentitiesOnly yes` means "only ever offer `IdentityFile`, ignore everything else in the agent." Clone with the alias host, not `github.com`: `git clone git@github.com-work:org/repo.git`.

### 5. ForwardAgent — use your local keys, don't copy them over

```sshconfig
Host acyr
  ForwardAgent yes
```

The remote box can then `git clone`/`git push` using **your local machine's** loaded SSH keys, without ever putting a private key on the (disposable, foreign) box. The trade-off: anyone with root on that remote box can, while you're connected, ask your forwarded agent to sign things — don't forward to a box you don't trust. For a throwaway test box you control, it's the right call over copying a key onto it.

### 6. Include — split config by purpose

Already in use (`Include ~/.orbstack/ssh/config` at the top of this repo's `ssh/config`, for OrbStack Linux VMs). Same pattern scales to anything else that wants to own its own host blocks without hand-editing the main file.

## Other tools — when SSH itself isn't the right layer

**Recommendation: mosh, paired with the `RemoteCommand` auto-attach above — adopted.** `mosh` is in `brewfile-cli` (installs on both real machines + any future foreign box), and `shell/.zshrc` has the alias — mosh doesn't read `RemoteCommand`, so it's spelled out explicitly there:

```sh
alias racyr='mosh acyr -- tmux new -A -s main'
```

`ssh acyr` → auto-tmux via the config. `racyr` → same thing over mosh, survives the network dying.

**Usage example — the difference shows up when the network doesn't cooperate:**

```sh
$ racyr
# → mosh handshakes over SSH once, then switches to UDP; drops into tmux "main"

# close the laptop lid, walk to another room, reconnect to a different wifi —
# with plain `ssh acyr` this would print "Write failed: Broken pipe" and die.

# with mosh: nothing happens. The terminal just keeps working once the
# network's back — no reconnect, no re-typed command, tmux "main" untouched.
```

The actual failure mode in this workflow is network hiccups — wifi switch, laptop sleep, a flaky connection — killing the SSH connection and forcing a manual reconnect. tmux already means zero work lost when that happens; mosh's job is making the *reconnect* itself invisible instead of a dead terminal. Skip the rest below for a workflow like this one: ControlMaster solves slow repeat-auth (not the problem here — one long session, not twenty quick ones), autossh is for unattended tunnels, sshrc/sshfs solve "don't want to configure the remote" (moot once it's fully bootstrapped).

| Tool | What it actually buys you | Trade-off |
|---|---|---|
| **mosh** | UDP transport — survives IP roaming (wifi→cellular, laptop sleep/wake) with instant local echo, no lag-typing feel | No port forwarding, no agent forwarding; needs a UDP port range reachable |
| **Eternal Terminal (`et`)** | TCP-based, same reconnect-survives-drops idea as mosh, keeps closer to normal SSH behavior (forwarding still works) | Less ubiquitous than mosh; needs `etserver` running on the remote |
| **autossh** | Auto-restarts a dropped SSH connection/tunnel — built for a port-forward or reverse-tunnel that must stay up unattended | Solves *tunnels*, not interactive session loss — pair with tmux for the latter |
| **sshrc** ([Russell91/sshrc](https://github.com/Russell91/sshrc)) | Injects **your local** aliases/functions/bashrc snippets into the remote shell for that session only — nothing installed on the remote, ever | Good fit for a disposable/foreign box you don't want to configure at all |
| **sshfs** | Mounts a remote directory as a local filesystem (`sshfs host:/path /local/mount`) — edit remote files with local-only tools, no remote editor needed | Filesystem-level latency on every read/write; not a fit for a fast edit-heavy loop |

None of these replace the RemoteCommand/tmux pattern above for "resume exactly where I left off" — mosh/et solve the *transport* dropping, tmux solves the *session* surviving either way. They compose (`mosh host -- tmux new -A -s main` works fine).

## Troubleshooting

- **ControlMaster socket left stale after a hard crash.** `ssh -O exit host` fails ("no such file")? Just `rm ~/.ssh/sockets/<name>` — a new `ssh` recreates it.
- **`ForwardAgent` silently not forwarding.** Check the remote's `authorized_keys`/sshd config isn't stripping `AllowAgentForwarding` (default is yes, but hardened boxes sometimes disable it) — `ssh-add -l` on the remote should list your local keys if forwarding is live.
- **mosh connects then hangs.** Almost always the UDP port range (60000–61000 default) isn't open on the path — check the remote's firewall, not mosh itself.
