return {
  "nvim-telescope/telescope.nvim",
  branch = "master", -- master fixes deprecated to-definition warnings
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "andrew-george/telescope-themes",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
          },
        },
      },
      extensions = {
        themes = {
          enable_previewer = true,
          enable_live_preview = true,
          -- the switcher persists the pick here; init.lua requires it last
          persist = {
            enabled = true,
            path = vim.fn.stdpath("config") .. "/lua/current-theme.lua",
          },
        },
      },
    })
    telescope.load_extension("fzf")
    telescope.load_extension("themes")

    -- same binds as the daily config — muscle memory carries over
    local map = vim.keymap.set
    map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
    map("n", "<leader>ths", "<cmd>Telescope themes<cr>", { desc = "Theme switcher" })
  end,
}
