# remote — quick reference

Filter: `ref-remote <word …>` · ssh · mosh · tailscale · vnc · smb — biskup & acyr

## ssh

| keys                          | does                              |
|--------------------------------|------------------------------------|
| `ssh biskup@100.116.173.43`   | iMac, keyless via tailscale SSH   |
| `ssh acyr`                    | LAN 192.168.1.23, auto-tmux       |
| `ssh acyr@100.120.6.62`       | acyr, off-LAN via tailscale       |
| `ssh biskup@<ip> '<cmd>'`     | one-shot, no tty — scripts, agents |
| `-o BatchMode=yes`            | never hang on a password prompt   |
| `-o ConnectTimeout=8`         | fail fast when the host is asleep |

## mosh

| keys                           | does                              |
|---------------------------------|------------------------------------|
| `mosh biskup@100.116.173.43`   | biskup, roaming/latency-tolerant  |
| `racyr`                        | alias: mosh acyr + auto-tmux      |

## tailscale

| keys                | does                        |
|---------------------|------------------------------|
| `tailscale status`  | list tailnet devices + IPs  |
| `tailscale ip -4`   | this device's tailnet IP    |

## vnc

| keys                           | does                                |
|---------------------------------|--------------------------------------|
| `vnc://biskup@100.116.173.43`  | Finder → Connect to Server, screen  |

## smb

| keys                           | does                                |
|---------------------------------|--------------------------------------|
| `smb://biskup@100.116.173.43`  | Finder → Connect to Server, files   |
| `smb://<name>.local`           | ✗ mDNS does not route over tailscale |
| `⌘K` in Finder                 | Connect to Server — use the IP      |

## volumes

| keys                     | does                        |
|---------------------------|------------------------------|
| `/Volumes/4TB_Diskur`    | biskup — fonts, archive     |
| `/Volumes/BISKUP_8TB`    | biskup — 8TB store          |
| `/Volumes/kol-ssd-4000`  | biskup — 4TB ssd            |
| `/Volumes/kol-ssd-480`   | biskup — 480GB ssd          |

[e] — list what is mounted on the iMac:

```sh
ssh biskup@100.116.173.43 'ls -d /Volumes/*'
```

----
doc: docs/operations/04-remote-machine/03-tailscale-remote-access.md
