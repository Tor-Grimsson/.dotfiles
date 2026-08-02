-- xplr — repo-tracked config. Live via ~/.config/xplr -> ~/.dotfiles/xplr.
-- The version line is REQUIRED: xplr refuses to start if it doesn't match
-- the running binary. Bump it when the brew formula moves.
version = "1.1.0"

xplr.config.general.enable_mouse = true
xplr.config.general.show_hidden = true

-- Styling is left alone on purpose: xplr's defaults draw in ANSI colour names,
-- so the terminal palette (swapped by kol-theme) is what tints it.
