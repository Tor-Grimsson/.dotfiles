-- Triage (2026-07-14, agent call — the map export was skipped): now = the video's
-- core arc ∩ what the daily grim config actually uses, plus harpoon/oil/blink as
-- the video's experiments worth living with. Deferred list: 12-nvim-from-scratch.md.
return {
  "nvim-lua/plenary.nvim", -- multiple plugins need
  "christoomey/vim-tmux-navigator", -- tmux & split window nav
  -- fixes undefined vim globals in lua_ls while editing this config
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/plenary.nvim/lua", words = { "plenary" } },
      },
    },
  },
}
