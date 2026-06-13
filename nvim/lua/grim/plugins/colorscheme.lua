-- Gruvbox Material (sainnhe/gruvbox-material).
-- Previous theme (TokyoNight, custom navy palette) archived at:
--   nvim/_archive/colorscheme-tokyonight.lua
return {
  "sainnhe/gruvbox-material",
  priority = 1000,
  config = function()
    -- gruvbox-material is configured via vim.g globals, set BEFORE :colorscheme.
    vim.g.gruvbox_material_background = "medium" -- "hard" | "medium" | "soft"
    vim.g.gruvbox_material_foreground = "material" -- "material" | "mix" | "original"
    vim.g.gruvbox_material_enable_bold = 1
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1

    vim.cmd("colorscheme gruvbox-material")
  end,
}
