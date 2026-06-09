# ── Powerlevel10k instant prompt (must stay first) ───────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""   # p10k is sourced from Homebrew after oh-my-zsh (below), not as an omz theme
plugins=(git sudo brew macos extract copypath copyfile colored-man-pages dirhistory command-not-found gh web-search)
# fzf-tab / zsh-autosuggestions / zsh-syntax-highlighting are sourced from Homebrew
# at the end of this file (not oh-my-zsh custom plugins) — see TOOLING.md.

# brew completions must be on fpath BEFORE oh-my-zsh runs compinit.
# HOMEBREW_PREFIX comes from brew shellenv in .zprofile (arch-correct on both machines).
fpath=("${HOMEBREW_PREFIX:-/usr/local}/share/zsh-completions" "${HOMEBREW_PREFIX:-/usr/local}/share/zsh/site-functions" $fpath)

# Homebrew's dirs under /usr/local are group-writable by design (Intel). oh-my-zsh's
# compaudit flags that and refuses to load completions; we trust the admin group on a
# personal machine, so skip the check rather than chmod against Homebrew.
ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

# Powerlevel10k theme — sourced directly from Homebrew (single source on both Macs;
# not an oh-my-zsh theme, so no machine-local custom/themes symlink or clone is needed).
[[ -r "${HOMEBREW_PREFIX:-/usr/local}/share/powerlevel10k/powerlevel10k.zsh-theme" ]] && source "${HOMEBREW_PREFIX:-/usr/local}/share/powerlevel10k/powerlevel10k.zsh-theme"

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
alias obs='open "obsidian://open?path=$HOME/dev/projects/kol-vault"'
alias v-bridge='rclone sync "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Workbox/kol-vault-mgmt/kol-vault-workbox" "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/kol-vault-workbox" --exclude-from "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Workbox/kol-vault-mgmt/kol-vault-workbox/.rcloneignore" --delete-excluded -vP'
alias v-backup='rclone copy "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Workbox/kol-vault-mgmt/kol-vault-workbox" "kolkrabbi:kolkrabbi/kol-vault-mgmt/kol-vault-workbox" --exclude-from "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Workbox/kol-vault-mgmt/kol-vault-workbox/.rcloneignore" -vP'
alias v-push='v-bridge && v-backup'

# edge-tts: read the clipboard aloud (Microsoft neural voices, plays via mpv)
# pbpaste → sanitizer (emoji stripped; markdown markers stripped; §→"section"; dashes/brackets→pauses) → edge-playback
unalias speak 2>/dev/null  # shells predating the function still carry the old alias; guard re-source
speak() {
  edge-playback --text "$(pbpaste | perl -CSD -pe '
    s/\[([^\]]*)\]\([^)]*\)/$1/g;                 # markdown link -> its label
    s/[\x{1F000}-\x{1FAFF}\x{2600}-\x{27BF}\x{2B00}-\x{2BFF}\x{2190}-\x{21FF}\x{FE00}-\x{FE0F}]//g;  # emoji + dingbats
    s/[*`#>|~]+//g;                               # markdown markers
    s/^\s*[-\x{2022}]\s+//;                       # list bullets
    s/\x{A7}\s*/section /g;                       # section sign -> the word
    s/[\x{2014}\x{2013}]/, /g;                    # em\/en dash -> pause
    s/[()\[\]{}]/, /g;                            # brackets -> pause
    s/(?:^|\s)\K\/+(\s|$)/, /g;                   # dangling slashes (a\/b lists) -> pause
    s/_+/ /g;
    s/(,\s*)+/, /g; s/,\s*([;:.])/$1/g; s/ {2,}/ /g;  # collapse stutter
  ')"
}

# carbonyl: Chromium in the terminal (via OrbStack/Docker)
carbonyl() {
  docker run -ti --rm fathyb/carbonyl --fps 30 --force-effective-connection-type=3G "$@"
}
alias hn='carbonyl https://news.ycombinator.com'

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

# load API tokens from vault into this shell's env (one keychain-fed unlock)
# run before launching anything that needs them: `bwenv && claude`
bwenv() {
  [ -z "$BW_SESSION" ] && { bwu >/dev/null || return 1; }
  export GLIF_API_TOKEN="$(bw get notes Glif)"         # token lives in NOTES, not password
  export JACKETT_API_KEY="$(bw get password Jackett)"  # password field
}

# ── Local secrets (not in git) ────────────────────────────────────────────────
[ -f ~/.secrets ] && source ~/.secrets


# –– fzf bat 
export FZF_DEFAULT_OPTS="
    --height 60%
    --layout=reverse
    --border
    --preview '[ -d {} ] && eza -T --level=2 --color=always {} || bat --color=always --style=numbers {}'
  "

  export BAT_THEME="ansi"
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix --exclude .git'
  source <(fzf --zsh)
  alias cat='bat --paging=never'

# ── zsh plugins via Homebrew (not oh-my-zsh custom plugins — see TOOLING.md) ──
# Load order: fzf-tab before the wrappers; zsh-syntax-highlighting dead last.
# Guarded so a machine that hasn't run `brew bundle` yet won't error.
HB="${HOMEBREW_PREFIX:-/usr/local}"
# fzf-tab — fzf-powered Tab completion (needs compinit, which oh-my-zsh already ran).
[[ -r "$HB/share/fzf-tab/fzf-tab.zsh" ]] && source "$HB/share/fzf-tab/fzf-tab.zsh"

  # fzf-tab — dir-aware preview in Tab completions (mirrors FZF_DEFAULT_OPTS above)
  zstyle ':completion:*' menu no                            # hand the menu off to fzf-tab
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # colorize filename candidates
  zstyle ':fzf-tab:*' switch-group '<' '>'                  # move between completion groups with < / >
  zstyle ':fzf-tab:complete:*' fzf-preview '[ -d "$realpath" ] && eza -T --level=2 --color=always "$realpath" || bat --color=always --style=numbers "$realpath" 2>/dev/null'

# zsh-autosuggestions — grey ghost-text from history.
[[ -r "$HB/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$HB/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
# zsh-syntax-highlighting — MUST be the last thing sourced in this file.
[[ -r "$HB/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HB/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
