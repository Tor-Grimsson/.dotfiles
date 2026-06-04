# Bitwarden CLI — per-user setup

The shell helpers (`bwu`, `bwl`) ship in `shell/.zshrc` and apply to every user of these
dotfiles. But three things are **per-user / per-machine** and must be done once by each
account (e.g. `biskup` on the iMac). Do these after `bootstrap.sh` has run.

## 0. Prerequisites

- `bootstrap.sh` has run for this user (installs `bitwarden-cli` via Brewfile, symlinks `.zshrc`).
- Verify the CLI exists: `bw --version`.

## 1. Point the CLI at the EU vault

The CLI defaults to `bitwarden.com`. Our vault is **EU** — switch it:

```sh
bw config server https://vault.bitwarden.eu
bw config server          # confirm: prints https://vault.bitwarden.eu
```

Note: `bw logout` resets the server back to `.com`. Re-run this line after any logout.

## 2. Log in

```sh
bw login you@email.com
```

Enter the account password + 2FA if prompted. `bw status` should then show
`"status":"locked"` with the EU `serverUrl`.

## 3. Store the master password in macOS Keychain (Touch ID / login-password gated)

`bwu` reads the master password from a Keychain item named `bw-master`. Create it with an
empty trusted-app list (`-T ""`) so **every** read pops a macOS auth prompt — your login
password stands in front of the vault:

```sh
security add-generic-password -a "$USER" -s bw-master -T "" -w
```

It prompts for the password to store — enter your **Bitwarden master password** (entered
twice to confirm). Nothing is typed into git or a file; it lives only in your Keychain.

To change it later: delete then re-add.

```sh
security delete-generic-password -s bw-master
security add-generic-password -a "$USER" -s bw-master -T "" -w
```

## 4. Use it

In any new terminal:

```sh
bwu          # pops Mac login-password prompt → Allow → vault unlocked for this shell
bwl          # grouped table: folder | type | name | username
bwl github   # filtered by search term
```

`bwl` auto-calls `bwu` if no session is set, so usually you just run `bwl`.

When the auth dialog appears, click **Allow** (releases once, prompts again next shell).
Do **not** click **Always Allow** — that whitelists `security` permanently and removes the
password gate.

## 5. Store a new secret (API key / token) via the CLI

Keep secrets in the vault, never in tracked files. Store each as a **Login** item whose
**password** field holds the secret and whose **name** matches the env var it feeds — so
retrieval is a clean `bw get password <NAME>`.

How the CLI builds an item: `bw get template item` prints a blank item as JSON → you fill it
in with `jq` → `bw encode` base64-encodes it (what `bw create`/`bw edit` read on stdin) →
`bw create item` saves it. The `type` field picks the kind: **1 = login**, 2 = secure note,
3 = card, 4 = identity.

Create one **without the key ever touching shell history** (`read -rs` hides the input, `jq`
injects it as a variable, never as a command-line argument):

```sh
bwu                                   # unlock first (sets BW_SESSION for this shell)
read -rs SECRET                       # type/paste the key — input hidden — press Enter
bw get template item \
  | jq --arg k "$SECRET" '.type=1 | .name="JACKETT_API_KEY" | .login.password=$k' \
  | bw encode | bw create item
unset SECRET                          # drop it from the shell
bw sync                               # (optional) push so other devices pull it
```

- **Convention:** item name == env var name (`JACKETT_API_KEY`, `GLIF_API_TOKEN`). One secret per item.
- Needs `jq` (ships via the Brewfile) and an unlocked vault.

Read it back, edit, or delete (get the id from `bwl` or the first line below):

```sh
bw get password JACKETT_API_KEY                      # → the secret
ID=$(bw get item JACKETT_API_KEY | jq -r .id)        # find the id
bw get item "$ID" | jq '.login.password="NEWKEY"' | bw encode | bw edit item "$ID"
bw delete item "$ID"
```

> **Rotate, don't just hide.** A key that was ever committed to a file is compromised even
> after you remove it (git history keeps it). Generate a fresh one in the service, store the
> new one here, and retire the old. (E.g. the Jackett key pulled out of `bin/tor-search`.)

## 6. Load a secret into the shell env

Scripts and configs read these as env vars — `bin/tor-search` wants `JACKETT_API_KEY`,
`claude/settings.json` wants `GLIF_API_TOKEN` (both `${...}` references, never literals).
Export them from the vault on demand:

```sh
export JACKETT_API_KEY="$(bw get password JACKETT_API_KEY)"
export GLIF_API_TOKEN="$(bw get password GLIF_API_TOKEN)"
```

**Do not put these unconditionally in `.zshrc`.** Each call needs an unlocked vault, so every
new terminal would block on a `bwu` prompt and add latency. Load on demand. A one-word helper
(add to `shell/.zshrc` next to `bwu`/`bwl`):

```sh
bwenv() {                       # bwenv JACKETT_API_KEY  → unlock if needed, export it
  bwu >/dev/null || return 1
  export "$1"="$(bw get password "$1")"
}
```

Run `bwenv JACKETT_API_KEY` in any shell that needs it (e.g. before `tor-search`). The
session caches after the first `bwu`, so repeat calls in the same terminal don't re-prompt.

## Notes

- The session (`BW_SESSION`) lives only in the current shell. New terminal → one prompt again.
- `bw lock` / `bw logout` / closing the terminal kills the session.
- Single secrets without unlocking the table: `bw get password <name>`, `bw get username <name>`.
- Tradeoff: with the Keychain item set up, anyone on your **unlocked** Mac account can run
  `bwu`. The login-password prompt is the only buffer. Acceptable for a personal account.
