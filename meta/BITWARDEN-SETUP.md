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

## 5. Store a secret (API key / token)

Each secret = one **Login** item; **item name = the env var name** (e.g. `JACKETT_API_KEY`),
the key goes in the **password** field. Needs `jq` (in the Brewfile).

1. Unlock: `bwu`
2. Read the key into a hidden variable (paste, then Enter):
   ```sh
   read -rs SECRET
   ```
3. Create the item:
   ```sh
   bw get template item | jq --arg k "$SECRET" '.type=1 | .name="JACKETT_API_KEY" | .login.password=$k' | bw encode | bw create item
   ```
4. Wipe the variable: `unset SECRET`
5. Push to other devices: `bw sync`

Read it back: `bw get password JACKETT_API_KEY`

Replace a key (rotation): re-run 1–3 with the new key, then delete the old item:
```sh
bw delete item "$(bw get item JACKETT_API_KEY | jq -r .id)"
```

## 6. Load a secret into the shell env

Scripts read these as env vars — `bin/tor-search` → `JACKETT_API_KEY`,
`claude/settings.json` → `GLIF_API_TOKEN`.

1. Unlock: `bwu`
2. Export it:
   ```sh
   export JACKETT_API_KEY="$(bw get password JACKETT_API_KEY)"
   ```

Don't put step 2 in `.zshrc` unconditionally — every new shell would block on the unlock prompt.
The `bwenv` helper (implemented in `shell/.zshrc`, 2026-06-05) loads the known tokens on demand:
```sh
bwenv && claude   # unlock once (Keychain-fed), export GLIF_API_TOKEN + JACKETT_API_KEY, launch
```
Field gotchas baked into it: `Glif` token lives in the item's **notes** (`bw get notes Glif`),
`Jackett` in the password field. The launched process inherits the env — that's how
`claude/settings.json`'s `${GLIF_API_TOKEN}` ref resolves.

## Notes

- The session (`BW_SESSION`) lives only in the current shell. New terminal → one prompt again.
- `bw lock` / `bw logout` / closing the terminal kills the session.
- Single secrets without unlocking the table: `bw get password <name>`, `bw get username <name>`.
- Tradeoff: with the Keychain item set up, anyone on your **unlocked** Mac account can run
  `bwu`. The login-password prompt is the only buffer. Acceptable for a personal account.
