#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════════════════
# bootstrap-cli.sh — CLI toolchain + dotfile symlinks ONLY. Safe to run on any
# machine, including a foreign box you're only SSH'd into: it installs no GUI
# apps, runs no `defaults` writes, loads no launchd agents, and stamps no Quick
# Actions. Everything here lands in $HOME dotfiles, ~/.config, or ~/.local.
#
# Installs the COMPLETE CLI tool set across every package manager the dotfiles
# depend on — brew (brewfile-cli), pipx, and uv — because scripts depend on the
# TOOL existing, not on which manager installed it. Do NOT omit tools by manager.
#
# RESILIENT: a step that fails (a formula with no source, a dead tap, a network
# blip) is skipped and recorded, NOT fatal — the run continues and prints a
# summary of everything that didn't install at the end. No `set -e`.
#
#   Standalone (foreign / SSH box):  ~/.dotfiles/bootstrap-cli.sh
#   Full daily-driver Mac setup:     ~/.dotfiles/bootstrap.sh   (sources this first)
#
# GUI apps, macOS defaults, iTerm/VS Code/Terminal prefs, launchd agents, and
# Finder Quick Actions all live in bootstrap.sh. Rationale + the CLI-vs-GUI
# split reasoning: docs/21-dotfiles/ and TOOLING.md.
# ════════════════════════════════════════════════════════════════════════════

DOT="$HOME/.dotfiles"

# ── Failure tracking ──────────────────────────────────────────────────────────
# FAILED collects a label per step that didn't complete. note_fail records one;
# summarize() prints the list at the end. Shared with bootstrap.sh when sourced.
FAILED=()
note_fail() { FAILED+=("$1"); printf '  \342\232\240 skipped: %s\n' "$1" >&2; }
summarize() {
  echo
  if [ "${#FAILED[@]}" -eq 0 ]; then
    printf '\342\234\223 bootstrap: complete — everything installed.\n'
  else
    printf '\342\232\240 bootstrap: complete, but %d item(s) did NOT install:\n' "${#FAILED[@]}"
    printf '    - %s\n' "${FAILED[@]}"
    echo "  Re-run after fixing, or install these by hand."
  fi
}

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    || note_fail "homebrew install"
fi

# ── CLI packages — brew formulas, then the pipx/uv-managed Python CLIs ─────────
# brew bundle already tries every line and continues past individual failures;
# we capture its output so the summary can name the exact formulae that failed.
if command -v brew >/dev/null 2>&1; then
  brew_log="$(mktemp)"
  brew bundle --file="$DOT/brewfile-cli" 2>&1 | tee "$brew_log"
  if [ "${PIPESTATUS[0]}" -ne 0 ]; then
    _n=0
    while IFS= read -r f; do
      [ -n "$f" ] && { note_fail "brew formula: $f"; _n=$((_n + 1)); }
    done < <(grep -oE 'Installing [^ ]+ has failed' "$brew_log" | awk '{print $2}')
    [ "$_n" -eq 0 ] && note_fail "brew bundle (brewfile-cli — see output above)"
  fi
  rm -f "$brew_log"
else
  note_fail "brew (not installed — skipped brewfile-cli)"
fi

# workmux is the ONE third-party-tap formula the CLI set needs, kept OUT of
# brewfile-cli's bundle on purpose: a box with $HOMEBREW_REQUIRE_TAP_TRUST set
# refuses an untrusted tap, and that failure aborts brew bundle's whole run —
# not just that formula — silently taking tmux/fzf/everything below it down
# too. Isolated here so a workmux/trust failure can only ever cost workmux.
if command -v brew >/dev/null 2>&1; then
  brew tap raine/workmux
  brew install raine/workmux/workmux \
    || note_fail "brew: raine/workmux/workmux (third-party tap — run 'brew trust --formula raine/workmux/workmux' if refused)"
fi

# pipx- and uv-managed CLIs are NOT brew formulas (isolated Python venvs) but
# sit in the same tier — scripts call them by name (au-transcribe → llm, etc.),
# so a CLI box needs them too. Idempotent; each failure is recorded, not fatal.
if command -v pipx >/dev/null 2>&1; then
  pipx install edge-tts || note_fail "pipx: edge-tts"          # clipboard TTS — docs/06-media-av/06-edge-tts.md
fi
if command -v uv >/dev/null 2>&1; then
  uv tool install llm --with llm-anthropic || note_fail "uv: llm"        # terminal LLM client + Claude plugin — docs/04-dev-languages/09-llm.md
  uv tool install pdf2image || note_fail "uv: pdf2image"                 # PDF→raster; avoids the poppler-symlink clash of the brew formula
fi

# ── Shell + git symlinks ──────────────────────────────────────────────────────
ln -sf  "$DOT/shell/.zshrc"     "$HOME/.zshrc"
ln -sf  "$DOT/shell/.zprofile"  "$HOME/.zprofile"
ln -sf  "$DOT/shell/.p10k.zsh"  "$HOME/.p10k.zsh"
ln -sf  "$DOT/shell/.nanorc"    "$HOME/.nanorc"
ln -sf  "$DOT/git/.gitconfig"   "$HOME/.gitconfig"
ln -sfn "$DOT/bin"              "$HOME/bin"

# ── tmux + plugin manager (TPM) ───────────────────────────────────────────────
[ -f "$DOT/tmux/.tmux.conf" ] && ln -sf "$DOT/tmux/.tmux.conf" "$HOME/.tmux.conf"
# Clone TPM if missing, then install its plugins non-interactively (the same
# script TPM's own `prefix I` runs — no live tmux session needed).
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" || note_fail "git clone tpm"
fi
if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || note_fail "tpm install_plugins"
fi

# ── Claude Code (CLI tool) + repo-backed config ───────────────────────────────
if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash || note_fail "claude code install"
fi
if [ -d "$DOT/claude" ]; then
  mkdir -p "$HOME/.claude"
  ln -sf  "$DOT/claude/CLAUDE.md"      "$HOME/.claude/CLAUDE.md"
  ln -sf  "$DOT/claude/settings.json"  "$HOME/.claude/settings.json"
  ln -sfn "$DOT/claude/skills"         "$HOME/.claude/skills"
  ln -sfn "$DOT/claude/hooks"          "$HOME/.claude/hooks"
  ln -sfn "$DOT/claude/commands"       "$HOME/.claude/commands"
  ln -sfn "$DOT/claude/agents"         "$HOME/.claude/agents"
  ln -sfn "$DOT/claude/output-styles"  "$HOME/.claude/output-styles"
fi
# Claude skill dependencies (bucket CLIs etc.) → ~/.local/bin
if [ -d "$DOT/claude/packages" ]; then
  mkdir -p "$HOME/.local/bin"
  for f in "$DOT/claude/packages"/*; do
    [ -f "$f" ] && [ -x "$f" ] && ln -sf "$f" "$HOME/.local/bin/$(basename "$f")"
  done
fi

# ── Editor / file-tool configs (~/.config + single-file configs) ──────────────
# nvim (whole dir — plugins self-install on first launch from the pinned lock)
[ -d "$DOT/nvim" ] && ln -sfn "$DOT/nvim" "$HOME/.config/nvim"
# yazi (whole dir — config + plugins + flavors are all tracked)
[ -d "$DOT/yazi" ] && ln -sfn "$DOT/yazi" "$HOME/.config/yazi"
# broot
if [ -d "$DOT/broot" ]; then
  mkdir -p "$HOME/.config/broot"
  ln -sf  "$DOT/broot/conf.hjson"  "$HOME/.config/broot/conf.hjson"
  ln -sf  "$DOT/broot/verbs.hjson" "$HOME/.config/broot/verbs.hjson"
  ln -sfn "$DOT/broot/skins"       "$HOME/.config/broot/skins"
fi
# glow (renderer config only — the Finder "Open in glow" Quick Action is GUI, bootstrap.sh)
if [ -f "$DOT/glow/glow.yml" ]; then
  mkdir -p "$HOME/Library/Preferences/glow"
  ln -sf "$DOT/glow/glow.yml" "$HOME/Library/Preferences/glow/glow.yml"
fi
# mpv
if [ -d "$DOT/mpv" ]; then
  mkdir -p "$HOME/.config/mpv"
  ln -sf "$DOT/mpv/mpv.conf"   "$HOME/.config/mpv/mpv.conf"
  ln -sf "$DOT/mpv/input.conf" "$HOME/.config/mpv/input.conf"
fi

# Print the summary only when run directly. When bootstrap.sh sources this file,
# it prints the combined summary itself after its own GUI/macOS steps.
[ "${BASH_SOURCE[0]}" = "${0}" ] && summarize
