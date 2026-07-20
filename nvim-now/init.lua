-- nvim-now — the from-scratch build (docs/kol-terminality/12-nvim-from-scratch.md).
-- Runs PARALLEL to the daily nvim/ via NVIM_APPNAME=nvim-now (alias: nnow) —
-- graduates to ~/.config/nvim only when it's the editor actually reached for.
require("config.options")
require("config.keymaps")
require("config.lazy")
require("current-theme") -- the colorscheme switch point — written by <leader>ths, loads last so it wins
