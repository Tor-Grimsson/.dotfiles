# g-nav — location shortcuts, mirrors yazi's g-keybinds at the shell level.
# Shared flags on every command below (2nd arg, after any target flag):
#   (none)  cd there        -l  cd + ls
#   -e      open in nvim     -c  copy path to clipboard
#   -p      print path, no cd
# Sourced by shell/.zshrc. `<cmd> -h` shows a command's own target flags.

_gnav_act() {
  local target="$1" flag="$2"
  case "$flag" in
    -l) cd -- "$target" && ls ;;
    -e) nvim -- "$target" ;;
    -c) printf '%s' "$target" | pbcopy && echo "copied: $target" ;;
    -p) print -r -- "$target" ;;
    "") cd -- "$target" ;;
    *)  echo "unknown flag: $flag (try -h)"; return 1 ;;
  esac
}

_gnav_help() {
  # $1 = command name, $2 = target-flag help lines
  print -r -- "$1 [target-flag] [-l|-e|-c|-p|-h]"
  print -r -- "  (no flags)  cd there"
  print -r -- "  -l  cd + ls   -e  open in nvim   -c  copy path   -p  print path"
  if [[ -n "$2" ]]; then
    print -r -- ""
    print -r -- "target flags:"
    print -r -- "$2"
  fi
}

# ── ghome — ~ ─────────────────────────────────────────────────────────────────
ghome() {
  local target=~ help='  --desktop     ~/Desktop
  --downloads   ~/Downloads
  --documents   ~/Documents'
  case "$1" in
    --desktop)   target=~/Desktop;   shift ;;
    --downloads) target=~/Downloads; shift ;;
    --documents) target=~/Documents; shift ;;
    -h) _gnav_help ghome "$help"; return ;;
  esac
  _gnav_act "$target" "$1"
}

# ── gdot — ~/.dotfiles ────────────────────────────────────────────────────────
gdot() {
  local target=~/.dotfiles help='  --shell       shell/
  --nvim        nvim/
  --yazi        yazi/
  --tmux        tmux/
  --claude      claude/
  --aerospace   aerospace/
  --docs        docs/
  --bin         bin/'
  case "$1" in
    --shell)     target=~/.dotfiles/shell;     shift ;;
    --nvim)      target=~/.dotfiles/nvim;      shift ;;
    --yazi)      target=~/.dotfiles/yazi;      shift ;;
    --tmux)      target=~/.dotfiles/tmux;      shift ;;
    --claude)    target=~/.dotfiles/claude;    shift ;;
    --aerospace) target=~/.dotfiles/aerospace; shift ;;
    --docs)      target=~/.dotfiles/docs;      shift ;;
    --bin)       target=~/.dotfiles/bin;       shift ;;
    -h) _gnav_help gdot "$help"; return ;;
  esac
  _gnav_act "$target" "$1"
}

# ── zshrc — ~/.dotfiles/shell/.zshrc (a file, not a dir — own verb set) ───────
zshrc() {
  local target=~/.dotfiles/shell/.zshrc
  case "$1" in
    -e) nvim -- "$target" ;;
    -s) source ~/.zshrc && echo "sourced ~/.zshrc" ;;
    -c) printf '%s' "$target" | pbcopy && echo "copied: $target" ;;
    -p|"") print -r -- "$target" ;;
    -h) print -r -- "zshrc [-e|-s|-c|-p|-h]  -e edit in nvim  -s source ~/.zshrc  -c copy path  -p print path (default)" ;;
    *)  echo "unknown flag: $1 (try -h)"; return 1 ;;
  esac
}

# ── gdev — ~/dev ──────────────────────────────────────────────────────────────
gdev() {
  local target=~/dev help='  --monorepo    dev/projects/kol-monorepo
  --studio      dev/projects/kol-studio
  --typefaces   dev/projects/kol-typefaces
  --dashboard   dev/projects/_kol-dashboard
  --chords      dev/projects/chords
  --imweb       dev/projects/imweb
  --kclaude     dev/projects/kol-claude
  (kol-vault → gobs, kol-apparat → gapparat, kol-client → gclient)'
  case "$1" in
    --monorepo)  target=~/dev/projects/kol-monorepo;   shift ;;
    --studio)    target=~/dev/projects/kol-studio;     shift ;;
    --typefaces) target=~/dev/projects/kol-typefaces;  shift ;;
    --dashboard) target=~/dev/projects/_kol-dashboard;  shift ;;
    --chords)    target=~/dev/projects/chords;         shift ;;
    --imweb)     target=~/dev/projects/imweb;          shift ;;
    --kclaude)   target=~/dev/projects/kol-claude;     shift ;;
    -h) _gnav_help gdev "$help"; return ;;
  esac
  _gnav_act "$target" "$1"
}

# ── gobs — ~/dev/projects/kol-vault (main Obsidian vault) ────────────────────
gobs() {
  local target=~/dev/projects/kol-vault
  case "$1" in
    -a|--app) open "obsidian://open?path=$target"; return ;;
    -h) _gnav_help gobs '  -a, --app   open in Obsidian.app'; return ;;
  esac
  _gnav_act "$target" "$1"
}

# ── gapparat — ~/dev/projects/kol-apparat, numbered subfolders (alpha order) ──
gapparat() {
  local target=~/dev/projects/kol-apparat
  local help='   -1  _inits             -2  kol-create
   -3  kol-design-editor  -4  kol-design-system
   -5  kol-docs           -6  kol-editors
   -7  kol-labs-monorepo  -8  kol-labs-single
   -9  kol-lightroom     -10  kol-plugin
  -11  kol-video         -12  kol-video-editor'
  case "$1" in
    -1)  target=~/dev/projects/kol-apparat/_inits;             shift ;;
    -2)  target=~/dev/projects/kol-apparat/kol-create;         shift ;;
    -3)  target=~/dev/projects/kol-apparat/kol-design-editor;  shift ;;
    -4)  target=~/dev/projects/kol-apparat/kol-design-system;  shift ;;
    -5)  target=~/dev/projects/kol-apparat/kol-docs;           shift ;;
    -6)  target=~/dev/projects/kol-apparat/kol-editors;        shift ;;
    -7)  target=~/dev/projects/kol-apparat/kol-labs-monorepo;  shift ;;
    -8)  target=~/dev/projects/kol-apparat/kol-labs-single;    shift ;;
    -9)  target=~/dev/projects/kol-apparat/kol-lightroom;      shift ;;
    -10) target=~/dev/projects/kol-apparat/kol-plugin;         shift ;;
    -11) target=~/dev/projects/kol-apparat/kol-video;          shift ;;
    -12) target=~/dev/projects/kol-apparat/kol-video-editor;   shift ;;
    -h) _gnav_help gapparat "$help"; return ;;
  esac
  _gnav_act "$target" "$1"
}

# ── gclient — ~/dev/projects/kol-client, numbered subfolders (alpha order) ───
gclient() {
  local target=~/dev/projects/kol-client
  local help='  -1  kol-client              -2  kol-client-ac
  -3  kol-client-acyr-website  -4  kol-client-aftra
  -5  kol-client-canalix       -6  kol-client-canalix-contract
  -7  kol-client-hrafn         -8  kol-client-kolkrabbi'
  case "$1" in
    -1) target=~/dev/projects/kol-client/kol-client;              shift ;;
    -2) target=~/dev/projects/kol-client/kol-client-ac;           shift ;;
    -3) target=~/dev/projects/kol-client/kol-client-acyr-website; shift ;;
    -4) target=~/dev/projects/kol-client/kol-client-aftra;        shift ;;
    -5) target=~/dev/projects/kol-client/kol-client-canalix;      shift ;;
    -6) target=~/dev/projects/kol-client/kol-client-canalix-contract; shift ;;
    -7) target=~/dev/projects/kol-client/kol-client-hrafn;        shift ;;
    -8) target=~/dev/projects/kol-client/kol-client-kolkrabbi;    shift ;;
    -h) _gnav_help gclient "$help"; return ;;
  esac
  _gnav_act "$target" "$1"
}

# ── gicloud — iCloud Drive root ───────────────────────────────────────────────
gicloud() {
  local target="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
  local help='  --workbox   iCloud Workbox folder'
  case "$1" in
    --workbox) target="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Workbox"; shift ;;
    -h) _gnav_help gicloud "$help"; return ;;
  esac
  _gnav_act "$target" "$1"
}
