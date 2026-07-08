---
title: Bitwarden CLI
type: reference
status: active
updated: 2026-06-05
description: Command-line client for the Bitwarden password manager, used to read and manage vault items from the terminal.
aliases:
  - bw
tags:
  - domain/security
  - pattern/cli
  - integration/brew-formula
  - provider/bitwarden
links:
  website: https://bitwarden.com/
  repo: https://github.com/bitwarden/clients
  manual: https://bitwarden.com/help/cli/
  brew: https://formulae.brew.sh/formula/bitwarden-cli
covers:
  - Login, unlock, and session-key workflow
  - Fetching secrets for scripts and the terminal
  - Writing items into the vault (GUI and CLI), targeting folders
related:
  - "[[04-bitwarden|Bitwarden desktop]]"
  - "[[08-vault-to-env-pattern|Vault → env pattern]]"
  - "[[../00-kol-cli/05-network-security|Network & remote card]]"
---

## Summary
Bitwarden CLI (`bw`) is the scriptable client for the Bitwarden vault. It logs in, unlocks the vault, and reads or writes items — passwords, secure notes, fields — directly from the terminal, returning values as plain text or JSON for piping into other tools.

This vault lives on the **EU server** (`https://vault.bitwarden.eu`) — see `meta/BITWARDEN-SETUP.md` for the one-time per-machine setup (server config, login, Keychain-stored master password).

## Why installed
It puts vault secrets within reach of the shell so credentials never have to be hand-copied out of the GUI. It pairs with the Bitwarden desktop app: the app is the daily driver, the CLI is for pulling a secret into a script or grabbing a password without leaving the terminal.

## The session model (read this once)

`bw` is stateless between commands. After `bw login` (once per machine), every shell needs an **unlocked session**:

```
bwu                      # our helper (shell/.zshrc): reads master password from
                         # macOS Keychain (item bw-master) → export BW_SESSION
```

`BW_SESSION` lives only in that shell. New terminal → run `bwu` again. `bw lock`, `bw logout`, or closing the window kills it. Everything below assumes an unlocked session.

## Reading secrets

```sh
bwl                              # our helper: all items as folder|type|name|user table
bwl jackett                      # same, filtered by search term
bw get password Jackett          # one secret, by item name (or id)
bw get username GitHub
bw get notes some-note
bw get item Jackett | jq         # the full item as JSON
bw list items --search aws | jq  # search, full JSON
bw list items --folderid <id>    # everything in one folder
```

`bw get` wants **exactly one match** — it errors on ambiguity; use the item id (from `bw get item`/`bw list items`) when names collide.

## Writing a password into the vault — step by step

Two paths. **The app is the simple one** — the CLI pipeline exists to keep secrets out of chat logs and shell history when working with an agent.

### Path A — desktop app / web vault (simplest)

1. Open the Bitwarden app (or https://vault.bitwarden.eu).
2. New item → type **Login**.
3. Name it (e.g. `Jackett`), pick the folder (e.g. `kol-tokens`), paste the key into **Password**. Save.
4. In any terminal: `bw sync` — the CLI sees it immediately after.

### Path B — pure CLI

**Step 1** — unlock:
```sh
bwu
```

**Step 2** — find the target folder's id (items reference folders by id, not name):
```sh
bw list folders | jq -r '.[] | "\(.id)  \(.name)"'
```
No folder yet? Create it and note the id it prints:
```sh
bw get template folder | jq '.name="kol-tokens"' | bw encode | bw create folder
```

**Step 3** — read the secret into a shell variable without echoing it:
```sh
read -rs SECRET        # cursor sits silent; paste the secret, press Enter
```

**Step 4** — build the item from a template and create it:
```sh
bw get template item \
  | jq --arg k "$SECRET" '.type=1
      | .name="ITEM_NAME"
      | .folderId="FOLDER_ID_FROM_STEP_2"
      | .notes=null
      | .login={password:$k}' \
  | bw encode \
  | bw create item
```

What each stage does:
| Stage | Does |
|---|---|
| `bw get template item` | emits a skeleton item as JSON ([templates](https://bitwarden.com/help/cli/#create)) |
| `jq --arg k "$SECRET"` | injects the secret as a jq variable — never typed into the command line |
| `.type=1` | item type: 1 login, 2 secure note, 3 card, 4 identity |
| `.folderId=…` | targets the folder — **id, not name** |
| `.notes=null` | strips the template's placeholder note |
| `bw encode` | base64-encodes the JSON (required by `create`/`edit`) |
| `bw create item` | writes it; prints the created item including its `id` |

**Step 5** — clean up and propagate:
```sh
unset SECRET
bw sync
bwl ITEM_NAME          # verify
```

### Editing and deleting

```sh
# change a field on an existing item (fetch → patch → encode → edit)
bw get item <id-or-name> | jq '.login.password="NEW"' | bw encode | bw edit item <id>

# rotate = same as above with the new key; or delete + recreate:
bw delete item "$(bw get item ITEM_NAME | jq -r .id)"

# move an item to another folder
bw get item <id> | jq '.folderId="<new-folder-id>"' | bw encode | bw edit item <id>
```

### Conventions in this repo

- Tokens/API keys live in folder **`kol-tokens`**, one Login item per secret, key in the **password** field, username empty.
- Scripts consume them as env vars (e.g. `JACKETT_API_KEY`) or fetch at runtime via `bw get password <item>` — see [[07-torrent|Torrent scripts]] for a live example.
- Secrets never appear as literals in tracked files (AGENT-CONTEXT contract).

## Syntax reference

```sh
bw status                        # serverUrl, user, locked/unlocked
bw sync                          # pull latest vault state
bw lock / bw logout              # drop session / deauthenticate (logout resets server to .com!)
bw generate -ulns --length 24    # password generator (upper/lower/numbers/symbols)
bw get template item|folder|item.login   # all skeleton shapes
bw list items|folders|collections [--search X] [--folderid ID]
bw <command> --help              # per-command flags
```

Manuals: [CLI reference](https://bitwarden.com/help/cli/) · [vault items](https://bitwarden.com/help/managing-items/) · [folders](https://bitwarden.com/help/folders/) · `bw --help`.

## Future use
`bw send` for sharing one-off encrypted secrets; automated vault exports for backup; a `bwenv <ITEM>` helper that unlocks and exports in one word if the env-var dance gets old.
