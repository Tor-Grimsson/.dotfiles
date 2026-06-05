# rclone — per-machine setup

`rclone.conf` holds a Backblaze **B2 application key** (secret), so it is **not tracked** in
this repo and **not symlinked** by `bootstrap.sh` — it stays machine-local. The credentials
live in Bitwarden instead; recreate the conf on a fresh machine from there.

## The remote

`kolkrabbi:` — a Backblaze B2 bucket. Used by the `v-backup` / `v-push` aliases in
`shell/.zshrc` to push the Obsidian vault workbox to the CDN bucket.

```
[kolkrabbi]
type = b2
account = <B2 keyID>          # from Bitwarden username field
key = <B2 application key>    # from Bitwarden password field
hard_delete = true
```

## Credentials in Bitwarden

Item **`rclone – kolkrabbi — b2`** (folder `kol-tokens`):
- username = `account = <B2 keyID>`
- password = `key = <B2 application key>`

⚠️ Quirk: the `account = ` / `key = ` prefixes (rclone-conf syntax) are baked into the
field values, so strip them when reading. (There's also a separate `Backblaze B2
Credentials` item — that's the B2 *account master* key, a different thing; don't confuse them.)

## Recreate the conf on a new machine

```sh
bwu
ITEM="rclone – kolkrabbi — b2"
ACCT="$(bw get username "$ITEM" | sed -E 's/^account = //')"
KEY="$(bw get password "$ITEM" | sed -E 's/^key = //')"
rclone config create kolkrabbi b2 account "$ACCT" key "$KEY"
rclone config update kolkrabbi hard_delete true
unset KEY
rclone lsd kolkrabbi:        # verify
```

Rotating the key: regenerate in the Backblaze console, update the Bitwarden item
(`bw edit item`), then re-run the `rclone config` lines above.
