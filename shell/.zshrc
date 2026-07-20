# Prompt: Powerlevel10k — instant prompt below, config sourced at the END of this file.
# (starship is kept as a parked alternate: its config + init line live at the bottom, commented — flip to switch back.)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ─────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""   # no omz theme — Powerlevel10k is sourced from Homebrew at the end of file
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

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/tools:$PATH"
export PATH="$HOME/bin:$PATH"
[ -d "/Applications/WebStorm.app/Contents/MacOS" ] && export PATH="/Applications/WebStorm.app/Contents/MacOS:$PATH"

# ── fnm — per-project Node version, auto-switch on cd (reads .nvmrc/.node-version); docs/documentation/16-version-management
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd)"

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
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt inc_append_history
setopt hist_ignore_all_dups   # a repeated command erases its older duplicates — keeps the fzf Ctrl-R picker dense
setopt hist_reduce_blanks     # strip extra whitespace before saving

export EDITOR=nvim

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
    local default="$HOME/thatComp--iMac"   # iMac start dir; falls back to cwd where it doesn't exist (MBP)
    [ $# -eq 0 ] && [ -d "$default" ] && set -- "$default"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ── Aliases ───────────────────────────────────────────────────────────────────
alias vim='nvim'   # the configured editor is nvim (repo nvim/ → ~/.config/nvim)
alias nnow='NVIM_APPNAME=nvim-now nvim'   # the from-scratch build (repo nvim-now/), parallel to the daily config
alias cc='clear'
alias cl='claude'
alias cllm='llm -c'   # continue the previous llm conversation (logged to SQLite)
alias llmc='llm chat'   # interactive llm REPL
# reveal: Finder at PATH (default cwd); `reveal -f` = new FLOATING window on the current AeroSpace workspace. See bin/fs-reveal.sh
alias reveal='fs-reveal.sh'
killport() { kill -9 $(lsof -ti:$1); }
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

# gcalcli: Google Calendar in the shell (--military = 24h time on the view commands)
alias cag='gcalcli agenda --military'                  # upcoming (now → a week)
alias cday='gcalcli agenda today tomorrow --military'  # today only (the "day view")
alias cw='gcalcli calw --military'                     # week grid
alias cm='gcalcli calm --military'                     # month grid
alias cq='gcalcli quick'                               # cq "Dentist Thu 2pm" — natural-language add
alias cadd='gcalcli add'                               # guided add (prompts title/when/where)
# morning briefing: today's full schedule (recurring included) + the month-ahead
# one-offs from cplan (recurring hidden). cplan is the bin/ script.
cbrief() {
  print -P "%F{cyan}── Today ──%f"
  gcalcli agenda today tomorrow --military
  print -P "\n%F{cyan}── Coming up (30d, one-offs) ──%f"
  cplan --30d-p
}

# ── Location shortcuts (g-nav) ────────────────────────────────────────────────
source "$HOME/.dotfiles/shell/functions/g-nav.zsh"

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

# ── Remote work (acyr test box) ───────────────────────────────────────────────
# mosh survives network drops/roaming; `Host acyr` in ssh/config auto-attaches
# tmux, but mosh doesn't read RemoteCommand, so it's typed explicitly here.
alias racyr='mosh acyr -- tmux new -A -s main'

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
  export FZF_ALT_C_OPTS="--preview 'eza -T --level=2 --color=always {}'"      # Alt-C: tree-preview the dir before cd
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"    # Ctrl-R: fzf history search
  source <(fzf --zsh)

  # atuin — SQLite-backed shell history. --disable-ctrl-r so fzf keeps Ctrl-R;
  # --disable-up-arrow so plain Up stays zsh history (see the Up/Down block below).
  # atuin still reachable on Ctrl-P and Shift+Up. fzf keeps Ctrl-T/Alt-C.
  # Guarded so a machine that hasn't run `brew bundle` yet won't error.
  if command -v atuin >/dev/null; then
    eval "$(atuin init zsh --disable-ctrl-r --disable-up-arrow)"
    bindkey '^P' atuin-search   # Ctrl-P → atuin full search
  fi

  # ── Up/Down history — three tiers ──────────────────────────────────────
  #   Up         zsh prefix search — type `git`, Up cycles only git-* history (empty line = previous cmd)
  #   Shift+Up   atuin picker, seeded with whatever you've typed
  #   Opt+Up     plain chronological history, prefix ignored ("normal" up)
  # Shift/Opt arrows arrive as CSI seqs (\e[1;2A / \e[1;3A) via Ghostty (macos-option-as-alt)
  # through tmux (extended-keys on). If a tier does nothing, `cat -v` + press the key to see what it sends.
  # This block must stay AFTER the atuin eval — it binds atuin's atuin-up-search widget.
  autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
  zle -N up-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey '^[[A'    up-line-or-beginning-search    # Up
  bindkey '^[[B'    down-line-or-beginning-search  # Down
  bindkey '^[OA'    up-line-or-beginning-search    # Up   (application-cursor mode)
  bindkey '^[OB'    down-line-or-beginning-search  # Down (application-cursor mode)
  bindkey '^[[1;2A' atuin-up-search                # Shift+Up   → atuin
  bindkey '^[[1;2B' atuin-up-search                # Shift+Down → atuin
  bindkey '^[[1;3A' up-line-or-history             # Opt+Up   → plain history
  bindkey '^[[1;3B' down-line-or-history           # Opt+Down → plain history
  alias cat='bat --paging=never'
  # eza — modern ls (icons need the Nerd Font, which is installed)
  alias ls='eza --group-directories-first --icons'
  alias ll='eza -lah --git --icons --group-directories-first'
  alias la='eza -a --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons --group-directories-first'

  # fe — fuzzy-pick a file (fd → fzf, bat preview) and open it in nvim; optional arg prefilters the list.
  fe() {
    local f
    f=$(fd --type f --hidden --exclude .git | fzf --query="$1" --select-1 --exit-0 \
          --preview 'bat --color=always --style=numbers {}') && nvim "$f"
  }

  # fzv — fzf that renders images (svg/png/jpg…) in the preview via chafa; text/dirs fall back to bat/eza.
  # Plain `fzf` stays text-only; use `fzv` when you want to see the picture. chafa's symbol output
  # is plain colored text, so it survives tmux + fzf redraws where the Kitty/Sixel protocols don't.
  fzv() {
    fzf --preview '[ -d {} ] && eza -T --level=2 --color=always {} ||
      { [[ {} =~ \.(svg|png|jpe?g|gif|webp|bmp|tiff?|heic|avif)$ ]] &&
          chafa -f symbols -s "${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" {} ||
        bat --color=always --style=numbers {}; }'
  }

  # to — jump to a bookmarked folder by tag (data: ~/.dotfiles/files/folders.md; `files <tag>` prints it).
  # `to kol` filters to #kol: one match cd's straight in, several fzf-pick; no arg picks from all.
  # A function, not a bin/ script, because only the shell itself can change its own directory.
  to() {
    local data="$HOME/.dotfiles/files/folders.md"
    [[ -f "$data" ]] || { print -u2 "to: no data at $data"; return 1 }
    local paths
    paths=$(awk -v tags="$*" -v home="$HOME" '
      BEGIN { nt = split(tolower(tags), want, " ") }
      /^## / { shw = 1; h = tolower($0); for (i = 1; i <= nt; i++) if (index(h, want[i]) == 0) shw = 0; next }
      shw && $1 !~ /^#/ && NF { p = $1; sub(/^~/, home, p); print p }
    ' "$data")
    [[ -n "$paths" ]] || { print -u2 "to: nothing tagged: $*"; return 1 }
    local target
    if [[ $(print -r -- "$paths" | wc -l) -eq 1 ]]; then
      target=$paths
    else
      target=$(print -r -- "$paths" | fzf --height 40% --reverse --prompt 'to> ' \
        --preview 'eza -la --icons --group-directories-first --color=always {} 2>/dev/null || ls -la {}') || return
    fi
    cd -- "$target"
  }

# zoxide — smarter cd: `z <fragment>` jumps to the best-matching visited dir, `zi` picks via fzf.
# Guarded so a machine that hasn't run `brew bundle` yet won't error.
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

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

# ── shell vi-mode (zsh-vi-mode) ────────────────────────────────────────────
# THE OFF-SWITCH: set VI_MODE=false below + `exec zsh` → instantly back to emacs
# mode, nothing else to touch. It's a toggle, not a one-way door.
# Inert until `brew install zsh-vi-mode` — the [[ -r ]] guard skips it, so staging
# this changes nothing live until you install AND leave VI_MODE=true.
# Config verified against the official README (github.com/jeffreytse/zsh-vi-mode).
# Full walkthrough: docs/documentation/01-shell-terminal/28-zsh-vi-mode.md
VI_MODE=true
ZVM_PLUGIN="$HB/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"   # brew's documented path
if [[ "$VI_MODE" == true ]] && [[ -r "$ZVM_PLUGIN" ]]; then
  # zvm_config runs at the right point during sourcing — the ONLY correct place for
  # options that reference plugin-defined vars ($ZVM_CURSOR_*, $ZVM_MODE_*).
  function zvm_config() {
    ZVM_TERM=xterm-256color                     # cursor-shape sequences that survive tmux (README: matters per-emulator)
    ZVM_CURSOR_STYLE_ENABLED=true
    ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK    # block cursor in normal mode
    ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM     # beam cursor in insert mode
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT         # each new prompt starts in INSERT — type normally, Esc when you want motions
    # ZVM_VI_INSERT_ESCAPE_BINDKEY=jk           # ← uncomment to add jk-as-Esc (real Esc still works too)
  }
  source "$ZVM_PLUGIN"
  # zsh-vi-mode re-inits zle at the first prompt, wiping earlier keybinds. The
  # README's documented fix: re-apply insert/main-keymap binds in zvm_after_init.
  # (normal/visual-mode binds would instead go in zvm_after_lazy_keybindings.)
  function zvm_after_init() {
    source <(fzf --zsh)                                    # Ctrl-R fzf · Ctrl-T · Alt-C
    command -v atuin >/dev/null && bindkey '^P' atuin-search
    # Up/Down history tiers (mirror of the block earlier in this file)
    bindkey '^[[A'    up-line-or-beginning-search
    bindkey '^[[B'    down-line-or-beginning-search
    bindkey '^[OA'    up-line-or-beginning-search
    bindkey '^[OB'    down-line-or-beginning-search
    bindkey '^[[1;2A' atuin-up-search                      # Shift+Up  → atuin
    bindkey '^[[1;2B' atuin-up-search
    bindkey '^[[1;3A' up-line-or-history                   # Opt+Up    → plain history
    bindkey '^[[1;3B' down-line-or-history
    # emacs conveniences KEPT in insert mode so it won't fight you while learning
    bindkey -M viins '^A'   beginning-of-line
    bindkey -M viins '^E'   end-of-line
    bindkey -M viins '^K'   kill-line
    bindkey -M viins '^[b'  backward-word
    bindkey -M viins '^[f'  forward-word
    bindkey -M viins '^[^?' backward-kill-word
  }
fi

# zsh-syntax-highlighting — MUST be the last thing SOURCED in this file.
[[ -r "$HB/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HB/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ── Prompt: Powerlevel10k ───────────────────────────────────────────────────────
# Theme sourced from Homebrew (not an omz custom theme); config from ~/.p10k.zsh
# (symlinked from ~/.dotfiles/shell/.p10k.zsh). Instant prompt is at the top of this file.
[[ -r "$HB/share/powerlevel10k/powerlevel10k.zsh-theme" ]] && source "$HB/share/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Parked alternate — starship. Config kept at ~/.dotfiles/starship/starship.toml (Gruvbox).
# To switch back: comment out the two Powerlevel10k lines above and uncomment the line below.
# command -v starship >/dev/null && eval "$(starship init zsh)"
