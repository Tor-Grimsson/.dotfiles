-- Options (video 00:08:08) — Sin-cy baseline; lines marked `ours` keep the
-- habits from the old grim config where the two deliberately differ.
vim.g.netrw_banner = 0

local opt = vim.opt

opt.termguicolors = true
opt.number = true
opt.relativenumber = true

-- indentation: 2 spaces (ours — prettier default; Sin-cy runs 4)
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = false
opt.wrap = false

-- backup and undo: no swap, persistent undo instead
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.undofile = true

-- search: live :s preview + case-smart matching (ours)
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.cursorline = true -- ours

-- folding
vim.o.foldenable = true
vim.o.foldmethod = "manual"
vim.o.foldlevel = 99
vim.o.foldcolumn = "0"

-- window splits
opt.splitright = true
opt.splitbelow = true

-- misc
opt.isfname:append("@-@")
opt.updatetime = 50
opt.clipboard:append("unnamedplus")
opt.mouse = "a"

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})
