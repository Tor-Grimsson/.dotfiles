-- Harpoon — per-project file bookmarks, merged from the nmix overlay 2026-07-20.
-- Caveat inherited from the reference: <C-i> select-2 shadows jumplist-forward.
return {
  "thePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      global_settings = {
        save_on_toggle = true,
        save_on_change = true,
      },
    })

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })
    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon quick menu" })

    vim.keymap.set("n", "<C-y>", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon file 1" })
    vim.keymap.set("n", "<C-i>", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon file 2" })
    vim.keymap.set("n", "<C-n>", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon file 3" })
    vim.keymap.set("n", "<C-s>", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon file 4" })

    vim.keymap.set("n", "<C-S-P>", function()
      harpoon:list():prev()
    end, { desc = "Harpoon prev" })
    vim.keymap.set("n", "<C-S-N>", function()
      harpoon:list():next()
    end, { desc = "Harpoon next" })
  end,
}
