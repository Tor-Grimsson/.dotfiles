-- ours: theme = auto (rides gruvbox-material) instead of Sin-cy's hand-rolled palette.
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lazy_status = require("lazy.status") -- pending-updates count

    require("lualine").setup({
      options = {
        theme = "auto",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "|", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diff",
            colored = true,
            symbols = { added = " ", modified = " ", removed = " " },
          },
          { "filename", file_status = true, path = 0 },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "filetype" },
        },
      },
    })
  end,
}
