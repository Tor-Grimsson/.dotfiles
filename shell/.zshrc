# ── Powerlevel10k instant prompt (must stay first) ───────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# brew completions must be on fpath BEFORE oh-my-zsh runs compinit.
# HOMEBREW_PREFIX comes from brew shellenv in .zprofile (arch-correct on both machines).
fpath=("${HOMEBREW_PREFIX:-/usr/local}/share/zsh-completions" "${HOMEBREW_PREFIX:-/usr/local}/share/zsh/site-functions" $fpath)

# Homebrew's dirs under /usr/local are group-writable by design (Intel). oh-my-zsh's
# compaudit flags that and refuses to load completions; we trust the admin group on a
# personal machine, so skip the check rather than chmod against Homebrew.
ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$(npm config get prefix)/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/tools:$PATH"
export PATH="$HOME/bin:$PATH"
[ -d "/Applications/WebStorm.app/Contents/MacOS" ] && export PATH="/Applications/WebStorm.app/Contents/MacOS:$PATH"

# ── conda (MBP-only, /opt/miniconda3 — pending consolidation, TOOLING.md § Python)
if [ -d /opt/miniconda3 ]; then
  __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  elif [ -f /opt/miniconda3/etc/profile.d/conda.sh ]; then
    . /opt/miniconda3/etc/profile.d/conda.sh
  fi
  unset __conda_setup
fi

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt inc_append_history

export EDITOR=vim

# ── Keybindings ───────────────────────────────────────────────────────────────
bindkey '^[^?' backward-kill-word
bindkey '^[b' backward-word
bindkey '^[f' forward-word

# ── Tools ─────────────────────────────────────────────────────────────────────
source "$HOME/Library/Application Support/org.dystroy.broot/launcher/bash/br" 2>/dev/null || true
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# yazi: cd to where you quit
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "${@:-~/thatComp--iMac}" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ── Aliases ───────────────────────────────────────────────────────────────────
alias mx='dotenv -- claude'
alias trm='transmission-remote'
alias tdash='watch -n 1 transmission-remote -l'
alias obs='open "obsidian://open?path=/Users/biskup/dev/projects/kol-vault"'
alias v-bridge='rclone sync "/Users/biskup/Library/Mobile Documents/com~apple~CloudDocs/Workbox/kol-vault-mgmt/kol-vault-workbox" "/Users/biskup/Library/Mobile Documents/iCloud~md~obsidian/Documents/kol-vault-workbox" --exclude-from "/Users/biskup/Library/Mobile Documents/com~apple~CloudDocs/Workbox/kol-vault-mgmt/kol-vault-workbox/.rcloneignore" --delete-excluded -vP'
alias v-backup='rclone copy "/Users/biskup/Library/Mobile Documents/com~apple~CloudDocs/Workbox/kol-vault-mgmt/kol-vault-workbox" "kolkrabbi:kolkrabbi/kol-vault-mgmt/kol-vault-workbox" --exclude-from "/Users/biskup/Library/Mobile Documents/com~apple~CloudDocs/Workbox/kol-vault-mgmt/kol-vault-workbox/.rcloneignore" -vP'
alias v-push='v-bridge && v-backup'

# ── Bitwarden ─────────────────────────────────────────────────────────────────
# unlock + export session key; reads master password from macOS Keychain (item: bw-master), falls back to prompt
bwu() {
  local pw; pw="$(security find-generic-password -a "$USER" -s bw-master -w 2>/dev/null)"
  if [ -n "$pw" ]; then
    export BW_SESSION="$(BW_PASSWORD="$pw" bw unlock --passwordenv BW_PASSWORD --raw)"
  else
    export BW_SESSION="$(bw unlock --raw)"
  fi
}

# list items as folder|type|name|username table, sorted (optional search term)
bwl() {
  [ -z "$BW_SESSION" ] && bwu
  local folders; folders="$(bw list folders)" || return
  bw list items ${1:+--search} ${1:+"$1"} | jq -r --argjson f "$folders" '
    ($f | map({(.id // "null"): .name}) | add) as $fm
    | ["login","note","card","identity"] as $t
    | map({
        folder: ($fm[(.folderId // "null")] // "No Folder"),
        type:   ($t[.type - 1] // "other"),
        name:   .name,
        user:   (.login.username // "-")
      })
    | sort_by(.folder, .type, .name)
    | .[] | "\(.folder)\t\(.type)\t\(.name)\t\(.user)"
  ' | column -t -s $'\t'
}

# fetch the notes field of an item
bws() { bw get notes "$1"; }

# ── Local secrets (not in git) ────────────────────────────────────────────────
[ -f ~/.secrets ] && source ~/.secrets
