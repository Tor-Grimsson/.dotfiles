-- Oil — merged from the nmix overlay 2026-07-20. Deviations from nnow kept:
-- default_file_explorer=false (nvim-tree keeps owning `nvim <dir>`) and no
-- <leader>- float bind (that's "decrement number" here — use :Oil --float).
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = false,
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

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.opt_local.cursorline = true
      end,
    })
  end,
}
