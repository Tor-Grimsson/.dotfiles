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

## Notes

- The session (`BW_SESSION`) lives only in the current shell. New terminal → one prompt again.
- `bw lock` / `bw logout` / closing the terminal kills the session.
- Single secrets without unlocking the table: `bw get password <name>`, `bw get username <name>`.
- Tradeoff: with the Keychain item set up, anyone on your **unlocked** Mac account can run
  `bwu`. The login-password prompt is the only buffer. Acceptable for a personal account.
