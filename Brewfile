# ════════════════════════════════════════════════════════════════════════════
# Brewfile — unified across both Macs (Intel iMac + Apple-Silicon MBP)
# Single source of truth. Install/sync with:  brew bundle --file="$HOME/.dotfiles/brewfile"
# Rationale, drift audit, and portability notes live in TOOLING.md.
# ════════════════════════════════════════════════════════════════════════════

# ── Taps ──────────────────────────────────────────────────────────────────────
tap "siddharthvaddem/openscreen"   # provides the openscreen cask

# ── Shell & prompt ──────────────────────────────────────────────────────────
brew "tmux"                    # Terminal multiplexer
brew "powerlevel10k"           # Zsh prompt theme — sourced from Homebrew in .zshrc
brew "zsh-completions"         # Extra zsh completion definitions
brew "zsh-syntax-highlighting" # Fish-like zsh syntax highlighting (sourced last in .zshrc)
brew "zsh-autosuggestions"     # Fish-like history autosuggestions (grey ghost-text)
brew "fzf-tab"                 # Replace the zsh completion menu with an fzf picker

# ── File & navigation ───────────────────────────────────────────────────────
brew "tree"        # Print directory trees
brew "yazi"        # TUI file manager (Rust, async I/O)
brew "broot"       # Tree navigation + fuzzy jump
brew "glow"        # Render markdown in the terminal
brew "watch"       # Run a command on an interval, fullscreen output (procps-ng)
brew "chawan"      # TUI web browser (text-mode, renders in terminal)
brew "w3m"         # Classic text-mode browser — instant, no JS; -dump renders HTML to stdout

# ── Modern CLI core ───────────────────────────────────────────────────────────
brew "fzf"         # Fuzzy finder — interactive filter for files, history, any list
brew "fd"          # Friendly, fast `find` replacement (respects .gitignore)
brew "bat"         # `cat` with syntax highlighting + line numbers (also the fzf preview)
brew "eza"         # Modern `ls` — colors, tree view, git status (maintained exa fork)
brew "ripgrep"     # Fast recursive content search (`rg`) — pairs with fzf
brew "zoxide"      # Smarter cd — `z` jumps to frecency-ranked visited dirs (init wired in .zshrc)
brew "dust"        # Modern `du` — tree view of what's eating disk, biggest-first (du-dust, Rust)

# ── Deduplication ─────────────────────────────────────────────────────────────
brew "jdupes"      # Fast exact-dupe finder (fork of fdupes) — quick CLI sweeps
brew "rmlint"      # Dupes + empty dirs/broken links; emits a reviewable delete script (reflink-aware)
brew "czkawka"     # czkawka_cli — exact AND fuzzy (similar images / video / music)

# ── Dev & languages ─────────────────────────────────────────────────────────
brew "neovim"      # Vim fork, extensible
brew "node"        # JavaScript runtime
brew "pnpm"        # Fast, disk-efficient JS package manager (can self-manage node)
brew "pipx"        # Install Python CLI apps in isolated venvs (one app per env)
                   #   pipx-managed (run per machine): edge-tts — clipboard TTS, docs/06-media-av/06-edge-tts.md
brew "uv"          # Fast Python project/dep/version manager (+ uvx tool runner)
                   #   uv-tool-managed (run per machine): llm — terminal LLM client, docs/04-dev-languages/09-llm.md
brew "jq"          # Command-line JSON processor
brew "yq"          # Command-line YAML/JSON processor (jq for YAML; reads .md frontmatter — au-tag.sh)

# ── Network & security ──────────────────────────────────────────────────────
brew "nmap"          # Port scanner
brew "arp-scan"      # ARP scanning + fingerprinting
brew "iperf3"        # Network throughput measurement (TCP/UDP/SCTP)
brew "bitwarden-cli" # Bitwarden password manager CLI
brew "clamav"        # Antivirus — driven by scripts/transmission_scan.sh quarantine

# ── Media & torrents ────────────────────────────────────────────────────────
brew "mpv"               # Terminal-friendly media player
brew "ffmpeg"            # Audio/video convert, record, stream
brew "handbrake"         # Video transcoder (HandBrakeCLI)
brew "yt-dlp"            # Download video/audio from YouTube, TikTok + ~1800 sites; `-x` rips audio (whisper feed)
brew "transmission-cli"  # Lightweight BitTorrent client
brew "whisper-cpp"       # Speech-to-text (OpenAI Whisper in C++)

# ── PDF & images ────────────────────────────────────────────────────────────
brew "imagemagick" # Image manipulation toolkit
brew "ghostscript" # PDF/PS rasterizer — gs; ImageMagick's PDF/EPS delegate (img-convert.sh, pdf-to-png.sh)
brew "img2pdf"     # Images → PDF (lossless JPEG embedding)
brew "pdf2svg"     # PDF → SVG (vector)
brew "pngpaste"    # Paste clipboard PNG to a file
# NOTE: pdf2image formula dropped — it ships poppler-duplicate binaries (pdffonts/
#       pdftoppm) that clash with poppler's symlinks. Use poppler's CLI directly, or
#       the Python pdf2image lib via `uv tool install pdf2image` / pipx.

# ── System & cloud ──────────────────────────────────────────────────────────
brew "fastfetch"   # System info banner (neofetch successor — neofetch was pulled from Homebrew)
brew "rclone"      # Rsync for cloud storage

# NOTE: pkgconf + poppler + python@3.x are intentionally omitted — they arrive as
#       dependencies (python is pulled by many formulae; poppler ← pdf2image / yazi).

# ── Casks (GUI apps) ──────────────────────────────────────────────────────────

# Browser / terminal / editor
cask "firefox@developer-edition"   # Web browser
cask "iterm2"                      # Terminal emulator
cask "visual-studio-code"          # Code editor

# Window / launcher / menu bar
cask "raycast"                     # Launcher / command palette
cask "hiddenbar"                   # Hide menu-bar items
cask "stats"                       # Menu-bar system monitor

# File managers / file utils
cask "marta"                       # Two-pane file manager
cask "namechanger"                 # Batch file renaming
cask "keka"                        # Archiver
cask "disk-drill"                  # File recovery
# NOTE: macfuse intentionally NOT bundled — its kext triggers a sudo/perms dance on
#       every (re)install. Install manually when needed: brew install --cask macfuse

# Cleanup
cask "appcleaner"                  # App uninstaller
cask "pearcleaner"                 # App uninstaller (open source)

# Screen capture / recording
cask "kap"                         # Screen recorder
cask "keycastr"                    # Keystroke visualizer (for screencasts)
cask "openscreen"                  # Screen recorder + video editor (siddharthvaddem tap)

# Notes / dev / remote
cask "obsidian"                    # Markdown knowledge base
cask "orbstack"                    # Docker / Linux VMs
cask "termius"                     # SSH client

# Password manager
cask "bitwarden"                   # Password manager (desktop)

# Fonts
cask "font-meslo-lg-nerd-font"     # Nerd Font (terminal/powerline glyphs)
cask "font-meslo-for-powerlevel10k" # MesloLGS NF — the exact font iTerm profile + p10k reference
cask "fontgoggles"                 # Font viewer for many font formats

# ── VS Code extensions ────────────────────────────────────────────────────────
vscode "ahmadawais.shades-of-purple"
vscode "bradlc.vscode-tailwindcss"
vscode "esbenp.prettier-vscode"
vscode "oderwat.indent-rainbow"
