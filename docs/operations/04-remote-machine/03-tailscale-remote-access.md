---
title: Tailscale SSH + mosh — keyless remote access from the iPad
type: guide
status: active
updated: 2026-07-11
audience: internal
description: Reach the Macs as SSH servers from the iPad (Blink) over the tailnet with no keys or passwords — swap the sandboxed GUI Tailscale for the `tailscaled` daemon, flip the tailnet SSH ACL to accept mode, and connect over mosh for mobile resilience.
aliases:
  - tailscale-remote-access
  - blink-mosh-tailscale
  - keyless-ssh-tailnet
tags:
  - domain/network
  - provider/tailscale
  - pattern/cli
related:
  - "[[INDEX|Remote machine]]"
  - "[[01-ssh-toolkit|SSH toolkit]]"
  - "[[02-remote-dev-workflow|Remote dev workflow]]"
  - "[[06-tailscale-jellyfin|Tailscale & Jellyfin]]"
---

# Tailscale SSH + mosh — keyless remote access from the iPad

## Purpose

Get a real shell on either Mac from the iPad, from anywhere, with **no SSH keys and no passwords** — the tailnet identity *is* the credential. Tailscale SSH does the auth; mosh makes the connection survive a phone switching wifi/cellular. The one non-obvious blocker: the GUI Tailscale app **cannot** be an SSH server (it's sandboxed), so the daemon build has to replace it.

## Prerequisites

- All devices on the same tailnet (`tor-grimsson.github`, Free) and logged into the same Tailscale account (`autogroup:self` then covers iPad → Mac with no per-device rule).
- Admin access to the tailnet Access Controls (to flip the SSH ACL).
- `tailscale` + `mosh` in `brewfile-cli` (both present as of 2026-07-11).
- Blink Shell on the iPad (App Store) as the mosh client.

## The tailnet

| Node | Role | Tailnet IP |
|---|---|---|
| `biskup` (Intel iMac) | SSH server | `100.116.173.43` |
| `yrs-imac` | SSH server | `100.66.68.91` |
| `ipad-pro-12-9-gen-5` | client (Blink) | `100.86.238.99` |

## Walkthrough

### 1. Replace the GUI app with the `tailscaled` daemon (each Mac)

`tailscale up --ssh` / `tailscale set --ssh` fail on the GUI build with a **"sandboxed GUI build"** error — both App-Store and standalone GUI variants are sandboxed, macOS blocks the SSH server, and no flag fixes it (`up` vs `set` was never the issue).

```sh
# quit + delete the GUI Tailscale first — run ONE Tailscale only
brew install tailscale
sudo brew services start tailscale     # install alone does NOT run tailscaled
sudo tailscale up --ssh                # authenticate at the printed URL
```

`tailscale up --ssh` turns SSH on in one step. Once the node is up, `tailscale set --ssh` toggles SSH without re-auth. Binary check on the Intel box: `/usr/local/bin/tailscale` (Homebrew is `/usr/local`, not `/opt/homebrew`) confirms the daemon build, not a stale GUI path.

### 2. Flip the tailnet SSH ACL to accept mode (keyless)

The default `ssh` rule ships as `"action": "check"` — periodic **browser** re-auth, which Tailscale's own client handles but Blink can't. In **Access Controls → Tailscale SSH**, turn Check mode **Off** so the rule reads `accept`:

```json
"ssh": [
  {
    "action": "accept",
    "src":    ["autogroup:member"],
    "dst":    ["autogroup:self"],
    "users":  ["autogroup:nonroot", "root"]
  }
]
```

With `accept`, there are **no SSH keys or passwords** — the credential is tailnet identity. Blink connects with an empty key/password and lands in the shell.

### 3. Connect over mosh

`mosh` (v1.4.0, `mosh-server` on `PATH`) is installed on both Macs. From Blink:

```sh
mosh biskup@100.116.173.43
```

Near-zero config: mosh bootstraps over SSH, then hands off to a UDP session in **60000–61000**, which the tailnet carries. Only pin `--port` if it hangs *after* the SSH step.

> Shift+Enter (and other modified keys) won't line-break over mosh — mosh 1.4.0 doesn't carry the extended-key protocol. For Claude Code sessions that need it, use plain **ssh**, not mosh. See [[01-ssh-toolkit|SSH toolkit]].

### 4. Prevent the host sleeping (still to apply)

A sleeping Mac drops SSH/mosh. Two options, pick per machine:

| Approach | Command | Survives reboot? |
|---|---|---|
| Durable system setting | `sudo pmset -a sleep 0 disksleep 0` (`pmset -g` to confirm) | yes |
| Toggleable, no setting change | `caffeinate -i` in a persistent tmux pane | no — re-run after reboot |

## Verification

- `tailscale status` / `tailscale ip -4` on each Mac; the green **SSH** badge in the admin console.
- From Blink: `mosh biskup@100.116.173.43` lands in a shell with no prompt for a key or password.

## Troubleshooting

- **"sandboxed GUI build" on `up --ssh`.** The GUI app is still installed — delete it, use the `brew` daemon (step 1).
- **mosh connects then hangs.** The UDP range (60000–61000) isn't reachable on the path — check the firewall, not mosh.
- **Blink prompts for a key/password.** The ACL is still in `check` mode — redo step 2.

## Status

- **Sleep-prevention:** applied on `yrs-imac` — `sudo pmset -a sleep 0 disksleep 0` (durable, survives reboot). On this iMac (`biskup`) it's optional and not applied.
- **Reachability:** `yrs-imac` has admin access and stays always-on — no host alias needed. This iMac is saved in Blink as `acyr@<magic-ip>` (`acyr` = admin user).
