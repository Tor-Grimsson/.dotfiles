---
title: Vault → env pattern
type: playbook
status: active
updated: 2026-06-05
description: How a secret travels from the Bitwarden vault into a process's environment — the one pattern, drilled five times with example services.
tags:
  - domain/security
  - pattern/cli
  - provider/bitwarden
covers:
  - The store → unlock → export → inherit chain
  - Password field vs notes field fetches
  - Script self-fetch fallback and ${VAR} config refs
related:
  - "[[03-bitwarden-cli|Bitwarden CLI]]"
---

## 0. Prerequisites

- `bw` logged in, Keychain item `bw-master` set up (`meta/BITWARDEN-SETUP.md` §1–4).
- The helpers from `shell/.zshrc`: `bwu` (unlock), `bws` (notes fetch), `bwenv` (known tokens → env).

**The whole pattern is one sentence:** a process inherits the environment of the shell that
launched it — so fetch the secret from the vault, `export` it, then launch from that same shell.

```sh
bwu                                       # 1. unlock once (Keychain-fed)
export SOME_TOKEN="$(bw get password X)"  # 2. vault → shell env
some-tool                                 # 3. tool inherits SOME_TOKEN
```

Nothing is ever written to disk. New terminal = empty env = do it again (or use `bwenv`).

## 1. Acme Maps — CLI tool reads an env var

The `acme` CLI expects `ACME_MAPS_TOKEN` in the environment.

```sh
# store once (password field)
bw get template item | jq '.name="ACME_MAPS_TOKEN" | .login={"password":"am_live_8842xyz"} | .type=1' \
  | bw encode | bw create item

# every session that needs it
bwu
export ACME_MAPS_TOKEN="$(bw get password ACME_MAPS_TOKEN)"
acme geocode "Reykjavík"        # inherits the token
```

## 2. Fogbank AI — `${VAR}` ref in a config file (the Glif/MCP shape)

`fogbank.json` is tracked in git, so it must never hold the literal key. It holds a **ref**:

```json
{ "apiKey": "${FOGBANK_API_KEY}" }
```

The ref resolves from the env of the process that reads the config — so the launcher shell
must carry the var:

```sh
bwu
export FOGBANK_API_KEY="$(bw get notes Fogbank)"   # long JWT → stored in NOTES, not password
fogbank-studio                                      # reads config, resolves ${FOGBANK_API_KEY}
```

Same shape as `claude/settings.json` → `${GLIF_API_TOKEN}`: repo holds the ref, vault holds the value, the shell bridges them at launch.

## 3. Tidepool Analytics — script self-fetches as fallback (the tor-search shape)

A script can fall back to the vault itself when the env var is missing, so it works
in fresh shells without manual exports:

```sh
#!/usr/bin/env bash
# tidepool-report.sh — needs TIDEPOOL_SECRET
TIDEPOOL_SECRET="${TIDEPOOL_SECRET:-$(bw get password TIDEPOOL_SECRET)}" || {
  echo "tidepool: vault locked — run bwu first" >&2; exit 1; }
curl -s -H "Authorization: Bearer $TIDEPOOL_SECRET" https://api.tidepool.example/v1/report
```

Pre-exporting still wins (one vault hit per shell, not per run):

```sh
bwu && export TIDEPOOL_SECRET="$(bw get password TIDEPOOL_SECRET)"
tidepool-report.sh   # uses the env copy, skips the vault
```

## 4. Lighthouse CDN — machine-local config recreated from the vault (the rclone shape)

`lighthouse` wants a config file at `~/.config/lighthouse/auth.toml`. The FILE stays
machine-local (gitignored); the vault is the source you recreate it from:

```sh
bwu
mkdir -p ~/.config/lighthouse
cat > ~/.config/lighthouse/auth.toml <<EOF
key_id = "$(bw get username LIGHTHOUSE_KEY)"
secret = "$(bw get password LIGHTHOUSE_KEY)"
EOF
chmod 600 ~/.config/lighthouse/auth.toml
```

Machine dies → nothing lost: re-run the block on the next machine. The repo never sees the secret, only (optionally) this recreate recipe.

## 5. Brimstone Mail — one-shot inline, no export at all

For a single command, skip the export and substitute inline — the secret lives only in
that one process's argument/env, never in the shell:

```sh
bwu
BRIMSTONE_SMTP_PASS="$(bw get password BRIMSTONE_SMTP_PASS)" msmtp --host smtp.brimstone.example -t < mail.txt
```

`VAR=value cmd` sets the var for `cmd` only — gone when the command exits.

## 6. One-shot: file → folder → vault → env

The whole chain in one terminal sitting. A key arrived as a file (`key.txt`); it goes into
the vault under the `kol-tokens` folder, then into the env, and the file dies:

```sh
bwu                                                        # 1. unlock

FOLDER_ID=$(bw list folders \
  | jq -r '.[] | select(.name=="kol-tokens") | .id')       # 2. folder NAME → ID (items take ids)

# 3. file content read straight into jq — never typed, never in history
bw get template item \
  | jq --arg k "$(< key.txt)" --arg f "$FOLDER_ID" '
      .type=1
      | .name="ACME_API_KEY"
      | .folderId=$f
      | .notes=null
      | .login={password:$k}' \
  | bw encode | bw create item                             # 4. write to vault

rm key.txt                                                 # 5. secret lives in vault now, not disk
bw sync                                                    # 6. push to other devices

export ACME_API_KEY="$(bw get password ACME_API_KEY)"      # 7. vault → env
acme-tool                                                  # 8. inherits it
```

Folder doesn't exist yet? One extra line before step 3:

```sh
bw get template folder | jq '.name="kol-tokens"' | bw encode | bw create folder
```

Full stage-by-stage anatomy of the jq pipeline: [[03-bitwarden-cli|Bitwarden CLI]] § Writing a password into the vault.

## 7. Verification

```sh
echo "${ACME_MAPS_TOKEN:+set}"     # prints "set" without leaking the value
env | grep -c FOGBANK              # 1 = exported, 0 = launcher won't see it
```

The real items in this vault: `Glif` (token in **notes** → `GLIF_API_TOKEN`),
`Jackett` (password field → `JACKETT_API_KEY`). `bwenv` exports both in one word:

```sh
bwenv && claude
```
