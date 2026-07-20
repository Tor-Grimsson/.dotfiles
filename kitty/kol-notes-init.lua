-- kol-notes-init.lua — minimal nvim for the kol-notes sticky.
-- Loaded with `nvim -u` by bin/notes-toggle so the notes window NEVER runs
-- the daily-driver nvim config (no dashboard, no file tree, no plugin UI) —
-- same trick as linkarzu's dedicated skitty nvim profile.

vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "no"
vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.swapfile = false
vim.opt.background = "dark"

-- kol-dark: let kitty's #121215 through, cream text, yellow accents
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", fg = "#F5EBD8" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", fg = "#F5EBD8" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", fg = "#242427" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1A1A1E" })
vim.api.nvim_set_hl(0, "Title", { fg = "#FFCF33", bold = true })
vim.api.nvim_set_hl(0, "Comment", { fg = "#A39A78" })
