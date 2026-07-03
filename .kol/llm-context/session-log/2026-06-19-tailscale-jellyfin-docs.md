# Session: Tailscale + Jellyfin docs (remote access planning)

**Date:** 2026-06-19
**Agent:** Claude (kol-labs-single session, cross-repo into `~/.dotfiles`)
**Summary:** Two new draft docs in `05-network-security/` covering Tailscale (mesh VPN, ACLs, mobile) and Jellyfin (self-hosted media server, user management) — written ahead of actually installing either, to plan remote access to a home Jellyfin server and to a client's machine.

## Changes Made

### Files Modified
- `docs/05-network-security/09-tailscale.md` — new, `type: guide`, `status: draft`. Purpose, core concepts (tailnet/MagicDNS/ACLs/share-a-node/exit-nodes), walkthroughs for remote SSH to own server and for connecting into a client's machine via "share a node", an ACL setup section (tagging devices, scoped `grants` example, isolation note for shared nodes), a Tailscale+Jellyfin section, and a mobile section (iOS/Android app behavior, battery, cellular vs Wi-Fi, MDM caveat).
- `docs/05-network-security/10-jellyfin.md` — new, `type: reference`, `status: draft`. Summary/why/use-case/win/how-to-use (local + remote-via-Tailscale + native-app server-field note) plus a new **User management** section: Dashboard → Users, per-library access scoping, parental controls, permission toggles, stream/bandwidth limits, Quick Connect, and the explicit note that Jellyfin has no Plex-style guest-invite email flow.
- `docs/05-network-security/INDEX.md` — added table rows for both new docs.

### Features Added/Removed
- No code/script changes — documentation only.

## Current State

### Working
- Both docs are internally consistent, cross-linked (`related:`), and follow the kol-docs frontmatter/archetype contract (guide vs reference).
- Section INDEX lists all 10 entries correctly.

### Known Issues
- **Neither Tailscale nor Jellyfin is actually installed yet** — both docs are `status: draft` deliberately. Per the catalog convention ("one reference doc per *installed* tool"), the root `docs/INDEX.md` tool count (currently 71) was **intentionally not bumped** — these don't count until installed + verified.
- ACL JSON in the Tailscale doc is an illustrative template (tag names `tag:server`/`tag:personal`, port list) — not yet applied to a real tailnet, since there is no tailnet yet.
- The "share a node" mechanism for the client-machine scenario is described from documentation, not verified by hand.

## Next Steps
1. Install Tailscale on whatever machine will run Jellyfin (`brew install tailscale` or app) and on at least one client device; flip both docs to `status: active` once live.
2. Stand up Jellyfin itself if not already running; verify the LAN URL works before layering Tailscale on top.
3. Once both are live: bump root `docs/INDEX.md` catalog count (71 → 73, category 05 → 12), and tighten the ACL template to the real device tags actually assigned.
