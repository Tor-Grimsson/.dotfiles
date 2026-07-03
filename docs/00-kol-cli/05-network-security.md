---
title: Network, remote & secrets
type: guide
status: active
updated: 2026-06-26
description: The practical layer over the network toolset — SSH into boxes (incl. over the Tailscale VPN and exactly what that depends on), tail remote logs, share a Jellyfin server with another person, measure a link with iperf3, find what's on the LAN, and get secrets from the vault into a process. Workflows and examples, not a tool dump.
aliases:
  - network-security
  - kol-network
  - ssh-tailscale
tags:
  - domain/network
  - domain/security
  - pattern/cli
covers:
  - SSH basics + this machine's ~/.ssh/config hosts
  - SSH workflows — copy files, port-forward, jump host, keep-alive, remote logging
  - SSH over the Tailscale VPN and its exact dependency chain
  - Termius — when the GUI client earns its place
  - Jellyfin — getting to the "invite someone as a user" state
  - iperf3 the way it's used 9 times out of 10
  - arp-scan + nmap — find hosts, then fingerprint them
  - secrets — ~/.secrets vs the Bitwarden vault chain
related:
  - "[[09-tailscale|Tailscale]]"
  - "[[10-jellyfin|Jellyfin]]"
  - "[[05-termius|Termius]]"
  - "[[07-iperf3|iperf3]]"
  - "[[01-nmap|Nmap]]"
  - "[[02-arp-scan|arp-scan]]"
  - "[[03-bitwarden-cli|Bitwarden CLI]]"
  - "[[08-vault-to-env-pattern|Vault → env pattern]]"
  - "[[06-tailscale-jellyfin|Tailscale + Jellyfin setup]]"
  - "[[01-cli-cheatsheet|CLI cheatsheet]]"
---

# Network, remote & secrets

The jobs, in order of how often they come up: **reach a box** (SSH), **reach it from anywhere** (Tailscale VPN), **share a service on it** (Jellyfin), **measure the link** (iperf3), **find what's out there** (arp-scan/nmap), and **feed it secrets** (vault → env). This is the workflow card; per-tool depth is in the linked `05-network-security` docs.

---

## 1. SSH — reach a box

`ssh user@host` opens a shell on another machine. The win is `~/.ssh/config`: name a host once, then just `ssh <name>`.

This machine's config already has:

```sshconfig
Host ubuntu-vm           # ssh ubuntu-vm  → straight in
  HostName <lan-ip>
  User kolkrabbi

Host github.com          # git push uses this — keychain'd key, no token
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519

Include ~/.orbstack/ssh/config   # 'orb' host for OrbStack Linux VMs
```

So `ssh ubuntu-vm` works with no IP, user, or key to remember. Add a host the same way:

```sshconfig
Host media
  HostName 192.168.1.50
  User kolkrabbi
  IdentityFile ~/.ssh/id_ed25519
  ServerAliveInterval 60     # ping every 60s so an idle session isn't dropped
```

**Keys, once per box:** `ssh-copy-id media` pushes your public key into the box's `authorized_keys` — after that, no password. Keys live in `~/.ssh/`; the macOS keychain holds the passphrase (`UseKeychain yes`), so the agent loads it on demand.

---

## 2. SSH workflows — the moves you reach for

| Task | Command |
|---|---|
| Run one command, don't open a shell | `ssh media 'df -h'` |
| Copy a file up / down | `scp file media:~/` · `scp media:~/file .` |
| Copy a folder | `scp -r dir media:~/` (or `rsync -avz dir media:~/` for big/repeated) |
| Interactive file browser | `sftp media` |
| **Tail a remote log live** | `ssh media 'journalctl -fu jellyfin'` (systemd) · `ssh media 'tail -f /var/log/x.log'` |
| Local port-forward (reach a remote service as if local) | `ssh -L 8096:localhost:8096 media` → open `localhost:8096` |
| Jump through a bastion to an inner box | `ssh -J bastion inner-host` |
| SOCKS proxy through the box | `ssh -D 1080 media` → point a browser at SOCKS `localhost:1080` |
| Keep a long job alive across drops | SSH in → run **`tmux`** on the box → detach (`Ctrl-a d`); reconnect + `tmux a` |

> **Remote logging, the honest version:** for a one-off, `ssh host 'journalctl -fu <service>'` streams it live and you `Ctrl-C` out. For something you babysit, SSH in and run the tail **inside tmux on the remote** so a dropped connection doesn't kill it — the session keeps running and you reattach. No agent or log-shipping stack needed for a homelab.

---

## 3. SSH over the VPN (Tailscale) — and what it depends on

The point of [Tailscale](../05-network-security/09-tailscale.md) is reaching your boxes **from anywhere** without port-forwarding, a static IP, or exposing port 22 to the public internet. It's a WireGuard mesh; NAT traversal is handled for you.

**The dependency chain — exactly what "SSH over VPN" needs:**

1. **Tailscale on both ends**, signed into the **same tailnet**: `tailscale up` on the target box *and* on your laptop/phone. That's the whole VPN dependency — nothing on the router.
2. **MagicDNS** on (admin console) so the box has a stable name: `ssh kolkrabbi@ubuntu-vm.<tailnet>.ts.net`. Without it, use the `100.x.y.z` Tailscale IP from `tailscale status`.
3. **Normal SSH still applies** at the target: an `sshd` running + your key in its `authorized_keys`. Tailscale moves the *packets* privately; it doesn't replace SSH auth.

```sh
tailscale status                                   # list tailnet devices + IPs/names
ssh kolkrabbi@ubuntu-vm.<tailnet>.ts.net           # SSH over the mesh, no port-forward
```

**Shortcut — Tailscale SSH** (`tailscale up --ssh` on the target) lets Tailscale broker auth via your *tailnet identity*, so step 3's key management disappears entirely — access is governed by tailnet ACLs instead of `authorized_keys`. Worth it once more than one device is involved.

**Reaching someone else's machine** (a client): don't merge tailnets. They install Tailscale, sign into *their* account, then **share that one node** to your identity. It appears in your device list scoped to just that box — no router config, no public RDP/VNC, no third-party remote-desktop tool. (Status: the share-a-node path is the plan, not yet drilled — confirm the primitive when you first do it.)

> Default tailnet ACL = every device can reach every device. Fine for a solo tailnet; **tighten it** (device tags + scoped grants — `tag:server` opening only `tcp:22`/`tcp:8096`) before a client's node or a second person joins. Template in [tailscale](../05-network-security/09-tailscale.md).

---

## 4. Termius — when the GUI earns it

[Termius](../05-network-security/05-termius.md) is the graphical SSH client (a desktop+mobile app), not a replacement for `ssh`. Reach for it when:

- You're on the **phone/iPad** and want a saved host list with keys attached — two taps to a shell, no typing host strings.
- You want **SFTP in the same window** as the terminal, or saved **port-forward profiles**, or a synced host list across devices.

For everyday desktop work the `~/.ssh/config` + `ssh <name>` flow above is faster. Termius shines as the **mobile** front door to the same boxes (pair it with Tailscale on the phone and you reach the homelab from anywhere).

---

## 5. Jellyfin — getting to "invite someone as a user"

The thing to know up front: **Jellyfin has no Plex-style email invite.** Every viewer is a real account *you* create on the server. "Inviting" someone is two independent layers — give their device network reach, and give their account library access — and you narrow both.

**Step by step:**

1. **Create the account.** Dashboard → **Users** → Add User (admin only). They get a username + password, their own watch history, watchlist, resume state.
2. **Scope what they see.** Per-user **library access** — give them "Movies", hide a private library. Set **permissions** (downloads, deletion, remote access, live TV), a **parental rating** cap, and **stream/bitrate limits** so one viewer can't eat all your transcode capacity.
3. **Get their device to the server** — the network layer:
   - **Their own devices, remotely:** their device joins the tailnet (full member) or you **share the Jellyfin node** to them (so they reach *only* that box — see [tailscale](../05-network-security/09-tailscale.md)). Then they point the Jellyfin app at `http://<jellyfin>.<tailnet>.ts.net:8096`.
   - **On your LAN:** just the server's local `http://<ip>:8096` — no VPN needed.
4. **Easy sign-in on a TV/console:** **Quick Connect** — Jellyfin shows a 6-digit code, they approve it from an already-signed-in session, no password typing on an awkward keyboard.

> Two layers, both scoped: **Tailscale decides if their device can *reach* the box; Jellyfin decides what that account can *see and do*.** A houseguest account scoped to "Movies" + a shared node scoped to `tcp:8096` = they stream movies and touch nothing else. (The Jellyfin user/permission model is solid and usable now; the tailnet share-a-node scoping is the one deployment step left to drill when you actually onboard someone.)

---

## 6. iperf3 — measure the link (the 9/10 case)

When a transfer feels slow, [iperf3](../05-network-security/07-iperf3.md) tells you whether it's the **network** or the app/disk. It generates pure synthetic traffic, so the number is the link's real ceiling. Nine times out of ten it's literally two commands:

```sh
# On the box you're testing TO (the receiver): start the server
iperf3 -s

# On the other box: 10-second TCP test, prints sustained throughput
iperf3 -c <server-ip>
```

The three flags worth knowing beyond that:

| Flag | Why |
|---|---|
| `-R` | reverse direction — server→client, catches up/down asymmetry |
| `-P 4` | 4 parallel streams — a single stream often can't saturate a fast/Wi-Fi/VPN link |
| `-u -b 100M` | UDP at a target rate → reports **jitter + packet loss** (Wi-Fi / VPN quality) |

Use it to sanity-check the Tailscale path too: `iperf3 -c <tailscale-ip>` tells you whether you got a direct WireGuard path or fell back to a slower relay.

---

## 7. Find what's on the network — arp-scan → nmap

The discovery pair. **arp-scan finds hosts, nmap fingerprints them.**

```sh
# 1. Every device on the LAN — IP, MAC, vendor. Layer-2, so it catches boxes
#    that drop pings (a headless server, an IoT thing).
sudo arp-scan --localnet

# 2. What that box actually runs — open ports + service versions
nmap -sV 192.168.1.50

# Other everyday nmap forms
nmap -sn 192.168.1.0/24        # ping sweep — who's alive, no port scan
nmap -p- 192.168.1.50          # all 65535 TCP ports on one host
```

Typical use: "what's this unknown device / where did the headless box land" → `arp-scan --localnet` reads the vendor off the MAC (Apple, Espressif, Ubiquiti…) and gives you the IP; `nmap -sV` then says what's listening. See [arp-scan](../05-network-security/02-arp-scan.md) · [Nmap](../05-network-security/01-nmap.md). (Only scan networks you own or are authorized on; both want `sudo`.)

---

## 8. Secrets — vault → process

Two models, same principle: **secrets are never literals in tracked files** — only `${VAR}` refs, with the value pulled from the vault and exported into the launching shell.

**`~/.secrets`** — the simple machine-local model. A `chmod 600` file of `export VAR=…`, sourced by `.zshrc`. Untracked; recreate on a new machine by pasting from the vault. Good for a couple of keys.

**Bitwarden vault chain** — the canonical, multi-machine model ([Bitwarden CLI](../05-network-security/03-bitwarden-cli.md) · [vault → env](../05-network-security/08-vault-to-env-pattern.md)):

```sh
bwu                                       # unlock once per shell (master pw from Keychain)
export SOME_TOKEN="$(bw get password X)"  # vault → shell env
some-tool                                 # inherits SOME_TOKEN; nothing hits disk

bwl                  # list vault items (folder|type|name|user)
bws Glif             # fetch a NOTES-field secret (long JWTs live in notes)
bwenv && claude      # export the known tokens (Glif, Jackett) in one word
```

The pattern in one sentence: a process inherits the env of the shell that launched it — so **unlock → export → launch from that shell**. New terminal = empty env = do it again.

> ⚠️ **The one trap:** never `export ANTHROPIC_API_KEY` on a machine running Claude Code on a subscription — an exported key makes `claude` bill the **API** instead of your Max/Pro plan. Set provider keys only where a *non-Claude* tool consumes them (e.g. `llm` on the iMac). The MBP deliberately has no `~/.secrets`.

---

## 9. Risks & when-not

| Area | Risk | Rule |
|---|---|---|
| SSH exposure | port 22 open to the public internet = constant brute-force | reach boxes over **Tailscale**, not a router port-forward; keys only, disable password auth |
| Tailscale ACL | default = every device reaches every device | fine solo; **tag + scope grants** before a client/second user joins |
| Sharing a box | adding an outsider as a full tailnet member exposes *all* your devices | use **share-a-node** — it exposes only that one box |
| Jellyfin | a new account with no scoping sees your whole library | set **per-user library access** + stream caps on every account you create |
| Scanning | arp-scan/nmap on a network you don't own is hostile (and sometimes illegal) | only scan your own / authorized networks |
| Secrets | `~/.secrets` is plaintext on disk; the vault is the source of truth | `chmod 600`, keep the vault canonical, never the repo; mind the `ANTHROPIC_API_KEY` trap |

---

## 10. Quick reference

| Task | Command |
|---|---|
| SSH to a saved host | `ssh ubuntu-vm` |
| SSH over the VPN | `ssh user@<host>.<tailnet>.ts.net` |
| Push your key to a box | `ssh-copy-id <host>` |
| Copy a file up | `scp file host:~/` (big/repeated: `rsync -avz`) |
| Tail a remote log | `ssh host 'journalctl -fu <service>'` |
| Reach a remote port locally | `ssh -L 8096:localhost:8096 host` |
| Keep a job alive | `tmux` on the remote → detach → `tmux a` |
| List tailnet devices | `tailscale status` |
| Measure a link | `iperf3 -s` (one box) · `iperf3 -c <ip>` (other) |
| Find LAN devices | `sudo arp-scan --localnet` |
| Fingerprint a host | `nmap -sV <ip>` |
| Unlock the vault | `bwu` then `bw get password <item>` |
| Export known tokens | `bwenv` |

---

*Living doc — the practical layer over `docs/05-network-security`. Per-tool depth in the linked docs. Symlinked into the kol-vault for print.*
