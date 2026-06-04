---
name: kol-bucket
description: Browse, fetch, and upload to the Kolkrabbi Backblaze B2 CDN bucket via the `bucket` CLI wrapper. Use when the user asks about CDN files, asset URLs, listing/inspecting bucket contents, or uploading/downloading media. Default remote is kolkrabbi:kolkrabbi/website (the public CDN lane).
---

# kol-bucket

Thin rclone wrapper for the Kolkrabbi Backblaze B2 CDN bucket. Lives at `~/.local/bin/bucket`.

## Bucket model

- **Remote name:** `kolkrabbi` (configured in `~/.config/rclone/rclone.conf`)
- **Bucket:** `kolkrabbi`
- **Default lane:** `website/` (public CDN). Top-level lanes:
  - `art-prints/` — print files grouped by print folder
  - `asset-library/` — collections and sub-collections
  - `hls-library/` — HLS video output (`.m3u8` + `.ts` segments)
  - `data-library/` — chess JSON/PGN (not media)
- **Public CDN URL pattern:** `https://f005.backblazeb2.com/file/kolkrabbi/website/<path>`
- **HLS noise rule:** `segment_*.ts` files are filtered out of `tree` output by default — every `.m3u8` references hundreds of them.

## Commands

| Verb | Args | What |
|---|---|---|
| `bucket ls` | `[path]` | List directory contents |
| `bucket tree` | `[path]` | Tree view (drops `segment_*.ts`) |
| `bucket cat` | `<file>` | Stream a file to stdout |
| `bucket url` | `<file>` | Print the public CDN URL |
| `bucket up` | `<local> <remote-path>` | Upload (with progress) |
| `bucket down` | `<remote> [local]` | Download (default: `./`) |
| `bucket sync` | `<local> <remote-path>` | **Mirror — deletes remote files missing locally** |
| `bucket rm` | `<file>` | Delete a single file |

Paths are relative to the default lane (`website/`). To target a different lane or the bucket root, override via env var:

```bash
BUCKET_REMOTE=kolkrabbi:kolkrabbi BUCKET_CDN_BASE=https://f005.backblazeb2.com/file/kolkrabbi bucket ls
```

## How to use

- **Browse / lookup:** run `bucket ls`, `bucket tree`, `bucket cat` directly. Read-only commands are on the allowlist — no permission prompts.
- **URLs:** `bucket url path/to/file.jpg` returns the canonical CDN URL. Don't reconstruct by hand.
- **Uploads:** `bucket up ./local-folder website-path/` — confirm scope with the user first.
- **Sync:** destructive on the remote side. Always dry-run first: `rclone sync ./local kolkrabbi:kolkrabbi/website/path -P --dry-run`. Only use `bucket sync` after confirming with the user.
- **`command not found`:** wrapper lives at `~/.local/bin/bucket` — check it's on PATH (`echo $PATH`) or invoke by absolute path.

## Related

- rclone config (account + key): `~/.config/rclone/rclone.conf`, `[kolkrabbi]` remote
- Setup doc: `/Users/kolkrabbi/dev/backblaze/05-backblaze-setup.md`
- Tree-snapshot helper: `/Users/kolkrabbi/dev/backblaze/cdn-bucket-helper/refresh-cdn.sh` — writes `cdn-tree.md` to cwd
