-- Bootstrap lazy.nvim (The plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Define and Setup Plugins
require("lazy").setup({
  { 
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
})

-- Nvim-Tree Configuration
require("nvim-tree").setup({
  view = { width = 30, side = "left" },
})

-- Keybindings
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
