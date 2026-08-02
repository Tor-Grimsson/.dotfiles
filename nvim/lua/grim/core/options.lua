vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for truecolor colorschemes to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- Crash safety. Both were off, and on 2026-07-31 a tmux crash took unsaved
-- notes with it — nothing to recover from, because nothing was being written.
--
-- swapfile  = the ONLY thing that survives a crash with UNSAVED text in it.
--             nvim writes it every 200 chars / 4s (updatetime below tightens
--             the idle half). After a crash, reopening the file offers RECOVER;
--             `nvim -r` lists orphan swaps.
-- undofile  = persistent undo. Reopen a file days later and `u` still walks
--             back past the last save. Does NOT help a never-saved buffer —
--             that is swapfile's job, which is why both are on.
opt.swapfile = true
opt.undofile = true
opt.updatetime = 250 -- also drives CursorHold (gitsigns/LSP hover timing)
