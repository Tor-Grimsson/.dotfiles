---
title: Tailscale + Jellyfin setup
type: guide
status: active
updated: 2026-07-01
audience: internal
description: What every piece is (tailnet, MagicDNS, ACL, the "box"), how the `http://thordurs-imac.tail485b10.ts.net:8096` address is actually built and how to change its parts, the Tailscale CLI, and how to add users and devices — for this live setup (Jellyfin "Skipholt" on the iMac).
aliases:
  - tailscale-jellyfin
  - jellyfin-setup
tags:
  - domain/network
  - domain/media
  - pattern/cli
related:
  - "[[09-tailscale|Tailscale (reference)]]"
  - "[[10-jellyfin|Jellyfin (reference)]]"
  - "[[05-network-security|Network & remote card]]"
---

# Tailscale + Jellyfin setup

The whole stack is already live (verified 2026-06-26): Tailscale connected on all 4 devices, MagicDNS on, and the **Jellyfin server running on the iMac** (`thordurs-imac`, server name *Skipholt*, v10.11.3), reachable over the VPN. Nothing to install — this card explains *what each piece is* and *how to drive it*.

---

## 1. The terms — one line each

| Term | What it is |
|---|---|
| **Jellyfin box** | The computer that runs the server 24/7 and holds the media. **Here: the iMac.** iPad/iPhone/MacBook are *clients*. |
| **`tailscale up`** | The CLI command that connects a device to your tailnet. The menu-bar app's *Connected* toggle **is** `tailscale up` — you only type it on a GUI-less box (a Linux server). |
| **Tailnet** | Your private network of devices, named after your login (`Tor-Grimsson@github`). |
| **MagicDNS** | Tailscale giving each device a **name** instead of an IP. Already on. |
| **ACL** | Rules for which device reaches which device/port. You're on the default (all-your-devices-reach-all) — only matters once an outsider joins. |
| **Exit node** | A tailnet device that routes *all* your internet traffic (like a normal VPN). That menu item — leave it off; not needed here. |

---

## 2. The address, decoded — `http://thordurs-imac.tail485b10.ts.net:8096`

You never typed that URL; **MagicDNS built it.** Every part:

| Part | What it is | Set by |
|---|---|---|
| `http://` | scheme — plain HTTP is fine **inside** the tailnet (the WireGuard tunnel is already encrypted) | — |
| `thordurs-imac` | the **device's name** in Tailscale (the iMac) | you, when the device joined (renameable) |
| `tail485b10` | your **tailnet's unique ID** | auto-assigned by Tailscale |
| `ts.net` | Tailscale's own domain (the public suffix all tailnets sit under) | Tailscale (fixed) |
| `:8096` | the **port** Jellyfin's server listens on | Jellyfin default |

**How it's created:** with MagicDNS on, Tailscale auto-generates `<device-name>.<tailnet>.ts.net` for **every** device the moment it joins. So the iMac is `thordurs-imac.tail485b10.ts.net`, your phone is `iphone-13-pro-max.tail485b10.ts.net`, etc. The `:8096` is just where Jellyfin answers. The IP form `http://100.91.192.16:8096` is the exact same thing without the name.

### Changing the parts

| Want to change | Where | Note |
|---|---|---|
| **Device name** (`thordurs-imac`) | [admin console](https://login.tailscale.com) → Machines → the device → rename | the MagicDNS name updates to match |
| **Tailnet name** (`tail485b10` → e.g. `tor-grimsson`) | admin console → **Settings → Tailnet name** | URLs become `thordurs-imac.tor-grimsson.ts.net`; **breaks any saved/bookmarked old URLs** |
| **The port** (`:8096`) | Jellyfin Dashboard → Networking → port | rarely worth it; leave 8096 |
| **The `ts.net` suffix** | not changeable | needs a custom domain + HTTPS certs — advanced, skip |

> Rule: prefer the **MagicDNS name** over the `100.x` IP — the name survives if the IP ever changes.

---

## 3. Tailscale CLI (it's on PATH: `/usr/local/bin/tailscale`)

| Command | Does |
|---|---|
| `tailscale status` | list every tailnet device — names + `100.x` IPs |
| `tailscale ip` | this device's Tailscale IP |
| `tailscale ip <device>` | another device's IP by name |
| `tailscale ping <device>` | test the tailnet path (tells you direct vs relayed) |
| `tailscale netcheck` | NAT/relay diagnostics for this machine |
| `tailscale up` / `tailscale down` | connect / disconnect (= the menu-bar toggle) |
| `tailscale cert <name>` | issue an HTTPS cert for a device (only if you want `https://`) |

Jellyfin itself has no CLI — it's the menu-bar **Jellyfin.app** (server) + the web dashboard. Health-check it any time:

```sh
curl -s http://100.91.192.16:8096/System/Info/Public   # "StartupWizardCompleted":true = healthy
```

---

## 4. Your devices (this tailnet)

| Device | Tailscale IP | Role |
|---|---|---|
| `thordurs-imac` | `100.91.192.16` | **the Jellyfin box** (server *Skipholt*) |
| `kolkrabbis-macbook-pro` | `100.123.233.87` | client |
| `ipad-pro-12-9-gen-5` | `100.86.238.99` | client |
| `iphone-13-pro-max` | `100.99.53.61` | client |

**Add a device:** install Tailscale on it, sign in with the **same** account, toggle on → it appears in `tailscale status` with its own `100.x` IP and MagicDNS name. That's it.

**Connect a client to Jellyfin:** install the **Jellyfin** app → Add Server → `http://thordurs-imac.tail485b10.ts.net:8096` → sign in. (The MacBook already has *Jellyfin Media Player.app*.)

---

## 5. Users (Jellyfin) — adding a viewer

Jellyfin has **no Plex-style email invite** — you create each account. "Inviting" = two independent layers:

**Account layer** — on the iMac (or any browser at the server URL, as admin):
1. **Dashboard → Users → `+`** → username + password.
2. **Library Access** → tick only what they should see.
3. Optional: cap simultaneous streams / bitrate, set a parental rating, toggle off downloads/deletion.
4. **Quick Connect** (Dashboard) = 6-digit code sign-in for TVs/consoles — no password typing.

**Network layer** (only if it's *someone else's* device, not yours):
1. They install Tailscale, sign into **their own** account.
2. You: admin console → Machines → `thordurs-imac` → `⋯` → **Share…** → their email.
3. They accept → their device reaches **only the iMac**, nothing else of yours.

> Two layers, both narrowed: Tailscale decides if their device can *reach* the box; Jellyfin decides what their account can *see*.

---

## 6. Tips & tricks

- **Keep the box awake.** If the iMac sleeps, Jellyfin is unreachable. Prevent sleep (System Settings → Displays/Battery) or run `caffeinate -d` while serving.
- **HTTP is fine here.** Plain `http://` works inside the tailnet — the tunnel is already encrypted. Want a green lock + no port number? See §7 (Tailscale Serve).
- **Mobile app "could not connect to server"?** Prefix the address with `http://`. The Jellyfin app defaults to `https`, there's no TLS cert on the bare tailnet address, so it fails the handshake **silently** — looks like the server is down when it isn't. `http://thordurs-imac.tail485b10.ts.net:8096` connects.
- **Name beats number.** Bookmark the MagicDNS URL, not the `100.x` IP.
- **Can't connect from a device?** Check Tailscale is **on** there; try the `:8096` IP form (rules out DNS); `tailscale status` should list the box.
- **Tailscale SSH** (`tailscale up --ssh` on a box) lets you `ssh` between tailnet devices with no key management — handy once you add a Linux box.
- **macOS firewall is off here**, so inbound works. If you ever turn it on, allow *Jellyfin* (System Settings → Network → Firewall).
- **Find your tailnet name** any time: `tailscale status` (FQDNs) or admin console → DNS.

---

## 7. HTTPS the easy way — Tailscale Serve

Want a real cert (green lock, no `http://` gotcha) **and** to drop the `:8096` port? Skip a custom domain — `tailscale serve` reverse-proxies Jellyfin over HTTPS on the existing MagicDNS name, one command, cert auto-provisioned.

1. **Enable certs** — [admin console](https://login.tailscale.com) → **DNS** → turn on **HTTPS Certificates** (one-time, per tailnet). MagicDNS is already on.
2. **Serve it** (on the iMac, where Jellyfin runs):
   ```sh
   tailscale serve --bg 8096      # --bg = persistent, survives reboot
   tailscale serve status         # confirm it's proxying
   ```
3. **Browse to** `https://thordurs-imac.tail485b10.ts.net` — real cert, no port, no `http://`. Point the client apps' server address at the same.

> **Why not a custom domain (for private access)?** A CNAME (`jellyfin.mydomain.com` → the `ts.net` name) only resolves on-tailnet *and* mismatches Tailscale's `*.ts.net` cert → https breaks. A real cert on your own name means running Caddy with a DNS-01 challenge — too many moving parts for a solo setup. Stay on Serve + the `ts.net` name. Save the custom domain for if you ever go **public** (reverse proxy + Let's Encrypt + internet exposure) — a different, bigger build.

---

*Living doc — this tailnet's reality. Tool depth: [[09-tailscale|Tailscale]] · [[10-jellyfin|Jellyfin]]. Symlinked into the kol-vault for print.*
