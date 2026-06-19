---
title: Tailscale
type: guide
status: draft
updated: 2026-06-19
description: Mesh VPN (WireGuard-based) for reaching your own machines remotely and connecting two separate people's devices into one private network.
aliases:
  - tailscale
tags:
  - domain/network
  - integration/brew-cask
related:
  - "[[05-termius|termius]]"
---

# Tailscale

## Purpose

A private mesh VPN between devices — no port-forwarding, no static IP, no self-hosted VPN server. Built on WireGuard, coordinated through Tailscale's control plane, NAT traversal handled for you.

## Why it's relevant here

Two concrete use cases on the table:

1. **Remote access to your own Jellyfin server.** Install Tailscale on the server and on a client device; hit the server's Tailscale IP or MagicDNS hostname (e.g. `http://jellyfin-box.tailnet-name.ts.net:8096`) instead of opening port 8096 on the router. No public exposure.
2. **Remoting into a client's machine.** Both machines join the same tailnet (or Tailscale's [share a node](https://tailscale.com/kb/1084/sharing) feature shares just one device across tailnets) → you get a private IP to her box without her exposing anything to the public internet, and without a third-party remote-desktop tool in the middle.

## Core concepts

- **Tailnet** — your private network of devices, identified by login (Google/GitHub/Microsoft/email).
- **MagicDNS** — devices get a stable hostname (`device.tailnet-name.ts.net`) instead of remembering IPs.
- **ACLs** — per-device/per-user access rules (JSON policy in the admin console), so you can scope who reaches what.
- **Sharing a node** — invite an external Tailscale user to reach *one specific device* of yours without joining your tailnet wholesale. This is the mechanism for the client-machine scenario — it doesn't require merging networks.
- **Exit nodes** — route all traffic through one tailnet device (not needed for the SSH/Jellyfin cases here, but worth knowing it exists).

## Walkthrough — remote SSH to your own server

1. Install Tailscale on the server (`brew install tailscale` or the official app) and run `tailscale up` to join your tailnet.
2. Install Tailscale on the client device, `tailscale up` with the same account.
3. `tailscale status` on either machine lists the tailnet's devices and their Tailscale IPs/hostnames.
4. SSH as normal, just point at the Tailscale hostname: `ssh user@device.tailnet-name.ts.net`.
5. Optional: Tailscale SSH (`tailscale up --ssh`) lets it manage SSH access itself via the tailnet identity, skipping key management entirely.

## Walkthrough — connecting to a client's machine

1. Client installs Tailscale on her machine, signs in with her own account (her tailnet, not yours).
2. From the Tailscale admin console, she uses **share node** to invite your Tailscale identity to that one device.
3. You accept the share — her machine now shows up in *your* device list, scoped to just that node, with whatever access her account permits.
4. Reach it the same way as any tailnet device: hostname/IP, SSH, RDP/VNC, or Jellyfin/whatever service runs on it.

This avoids: VPN config exchange, port-forwarding on her router, exposing RDP/VNC to the public internet, or trusting a third-party remote-support tool.

## Setting up ACLs

ACLs are a JSON policy file edited in the admin console (`Access Controls` tab at [login.tailscale.com/admin/acls](https://login.tailscale.com/admin/acls)). Default policy allows every device to reach every other device — fine for a one-person tailnet, worth tightening once a client's shared node or a second person joins.

1. **Tag your devices first.** Tags are the stable handle ACLs key off (better than hostnames, which can change). Define them under `tagOwners`, then apply via `tailscale up --advertise-tags=tag:server` on the device (or set it in the admin console's device menu).
   ```json
   "tagOwners": {
     "tag:server":  ["autogroup:admin"],
     "tag:personal": ["autogroup:admin"]
   }
   ```
2. **Write grants scoped to tags, not "everyone."** Replace the wildcard default with explicit rules:
   ```json
   "grants": [
     {
       "src": ["autogroup:member"],
       "dst": ["tag:server"],
       "ip":  ["tcp:22", "tcp:8096"]
     }
   ]
   ```
   This says: your own tailnet members can SSH (22) and reach Jellyfin (8096) on anything tagged `tag:server` — nothing else, no other ports.
3. **Scope a shared node separately.** A device shared into your tailnet via "share a node" only ever exposes itself — it's invisible to ACL rules targeting your other tags, so the client's machine can't be reached by anything you grant to `tag:server`/`tag:personal` and vice versa. No extra ACL needed purely for isolation, but you can still scope what *you* can do *to* the shared node if more than basic access is offered.
4. **Test before trusting it.** `tailscale status` plus an actual `ssh`/`curl` attempt from a non-admin device — ACL mistakes fail closed (you lose access) more often than they fail open, so check the obvious path still works after a change.
5. **Iterate.** The policy file has a built-in editor with validation in the admin console; invalid JSON or unknown tags get flagged before you can save.

## Tailscale + Jellyfin

Already covered in depth in [[10-jellyfin|jellyfin]] — the short version: install Tailscale on the Jellyfin box, then point any client at `http://<tailscale-hostname>:8096` instead of the LAN IP or a port-forward. If ACLs are in place, the device running Jellyfin needs `tag:server` (or equivalent) and a grant opening `tcp:8096` to whichever tags/devices should be able to stream.

## Tailscale on mobile

- Official apps for iOS and Android — install, sign into the same tailnet account, toggle the VPN profile on (uses the platform's standard "VPN connection" system UI, not a custom always-on hack).
- Once connected, the phone resolves tailnet MagicDNS hostnames and reaches tailnet IPs exactly like a desktop node — no per-app configuration beyond pointing the app (Jellyfin's mobile client, an SSH client, etc.) at the Tailscale hostname.
- **Battery/connectivity behavior:** Tailscale on mobile can be left on permanently (it's a lightweight WireGuard tunnel, not constant polling) or toggled on only when needed — toggling on-demand is the safer default if you're worried about battery or simply don't need the tailnet most of the time.
- **Cellular vs Wi-Fi:** works on both; this is exactly the case that replaces "be on the home Wi-Fi to reach Jellyfin" — direct connections use the carrier's NAT traversal same as Wi-Fi, falling back to Tailscale's relay (DERP) servers if a direct path can't be established.
- **MDM/managed devices:** if a phone is under work MDM, check whether it restricts installing a personal VPN profile before relying on this for a client's managed device.

## Open questions / not yet decided

- Whether to put the Jellyfin server's Tailscale node behind an ACL restricting it to specific devices, or leave it open to the whole tailnet.
- Whether Tailscale SSH replaces existing key-based SSH entirely, or runs alongside it.
- Client-machine scenario hasn't been tested yet — confirm "share a node" is the right primitive (vs. a full second tailnet user) once you're actually setting it up.
- ACL policy above is a starting template, not yet applied to the real tailnet — confirm tag names and ports once devices are actually tagged.

## Future use

If more client machines need occasional remote access, the "share a node" pattern repeats per-client without ever merging tailnets — worth standardizing into a short checklist once done twice.
