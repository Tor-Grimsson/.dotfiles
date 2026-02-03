-- ===============================
-- Basic Neovim + lazy.nvim setup
-- ===============================

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key (for custom shortcuts)
vim.g.mapleader = " "

-- ===============================
-- Plugins
-- ===============================
require("lazy").setup({
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- icons in the tree
    },
    config = function()
      require("nvim-tree").setup({})
    end,
  },
})

-- ===============================
-- Keymaps
-- ===============================

-- Toggle file explorer with Ctrl+n
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")

-- Or Space + e (leader e)
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
