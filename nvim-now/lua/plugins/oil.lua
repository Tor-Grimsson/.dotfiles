-- The video's explorer pick — edit the filesystem like a buffer. The daily
-- config's nvim-tree/yazi stay over there; this is the from-scratch experiment.
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      columns = {},
      keymaps = {
        ["<C-h>"] = false, -- keep for tmux-navigator
        ["<C-l>"] = false,
        ["<C-c>"] = false, -- <C-c> stays escape, not close
        ["<C-r>"] = "actions.refresh",
        ["<M-h>"] = "actions.select_split",
        ["q"] = "actions.close",
      },
      delete_to_trash = true,
      view_options = { show_hidden = true },
      skip_confirm_for_simple_edits = true,
    })

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Open parent directory (float)" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.opt_local.cursorline = true
      end,
    })
  end,
}
