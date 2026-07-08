---
title: Jellyfin
type: reference
status: active
updated: 2026-06-26
description: Self-hosted media server (free Plex alternative) — library, transcoding, and apps; reached remotely over Tailscale instead of port-forwarding.
aliases:
  - jellyfin
tags:
  - domain/media
  - domain/network
related:
  - "[[09-tailscale|tailscale]]"
  - "[[../00-kol-cli/06-tailscale-jellyfin|Tailscale + Jellyfin setup]]"
  - "[[../00-kol-cli/05-network-security|Network & remote card]]"
---

# Jellyfin

## Summary
Jellyfin is a free, open-source media server — the self-hosted alternative to Plex/Emby. It indexes a movie/TV/music library, transcodes on the fly for whatever device is watching, and serves a web UI plus native apps (Roku, Android/iOS, Android TV, Kodi, etc.).

## Why installed
Runs as the home media server. Local network access is automatic; the remote-access question (watching away from home, or from a phone on cellular) is solved by [[09-tailscale|Tailscale]] rather than opening ports on the router.

## Most common use case
Browse the library and stream a file from a client app or browser, on the LAN or — via Tailscale — from anywhere.

## Biggest win
No subscription, no licensing on hardware-transcode features (the Plex paywall), full control of the library and metadata.

## How to use

### Local
- Server runs at `http://<server-ip>:8096` on the LAN.
- First-run wizard: create admin user, point at media folders, let it scan.

### Remote, via Tailscale
1. Install Tailscale on the Jellyfin server itself (`tailscale up`), confirm it shows in `tailscale status`.
2. Install Tailscale on the remote client (phone, laptop) signed into the same tailnet.
3. Hit the server's Tailscale hostname instead of the LAN IP: `http://jellyfin-box.tailnet-name.ts.net:8096` (MagicDNS) or the Tailscale IP directly.
4. No router port-forward, no public exposure — the connection only exists between tailnet-joined devices.
5. Native apps: most Jellyfin clients (Android/iOS/Android TV) accept any reachable host/IP in their server-address field, so the Tailscale hostname works the same as a LAN address — just enter it as the server URL.

### Sharing access (e.g. a household member or a friend, not just your own devices)
- Their device needs to be on the tailnet (full member) or have your Jellyfin node shared to them via Tailscale's "share a node" (see [[09-tailscale|tailscale]]) if they shouldn't see your other devices.
- Separately, Jellyfin has its own per-user accounts/permissions — Tailscale governs *network* reachability, Jellyfin governs *library* access. Both layers apply.

## User management

Jellyfin has its own user system, separate from Tailscale's network-level access (Tailscale gets a device *to* the server; Jellyfin decides what that person can *see and do* once there).

- **Dashboard → Users** (admin only) — add/remove users, each gets their own login, watch history, watchlist, and resume state.
- **Per-user library access** — a user can be restricted to specific libraries (e.g. a client or houseguest sees "Movies" but not a personal/private library).
- **Parental controls** — per-user max content rating, plus optional access schedules (time-of-day restrictions).
- **Permissions toggles** — per user: allow media deletion, allow downloading/syncing, allow remote access at all, allow live TV, allow camera-upload, admin privileges.
- **Simultaneous stream / bandwidth limits** — cap concurrent streams or bitrate per user, useful if a remote viewer is on a slow connection or to stop one account from hogging transcode capacity.
- **Quick Connect** — a 6-digit code flow for signing a new device into an existing account without typing a password — handy for TV apps or a client's device where typing credentials is awkward.
- **Invites vs accounts** — Jellyfin doesn't have a built-in "guest invite" email flow like Plex; every viewer needs an actual Jellyfin account created by the admin. (Plex's friend-invite system is the one feature Jellyfin doesn't replicate — worth knowing going in.)

**Practical pairing with Tailscale:** create a Jellyfin account scoped to only the libraries a given person should see, *and* (if using shared-node or tailnet-membership) scope the Tailscale side so they reach only the Jellyfin port and nothing else on that box. Two independent layers, both narrowed.

## Future use
- Hardware transcoding (Intel QuickSync / Apple Silicon VideoToolbox) if CPU transcode becomes a bottleneck with remote streams.
- Tailscale ACLs scoping the Jellyfin node if the tailnet grows to include devices that shouldn't reach it.
