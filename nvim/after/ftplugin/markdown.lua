-- Markdown prose settings (overrides the global wrap = false in core/options.lua)
vim.opt_local.conceallevel = 2 -- Clearer view by hiding markup tokens
vim.opt_local.wrap = true      -- Enable line wrapping for prose
vim.opt_local.textwidth = 80   -- Set line wrap limits

-- Toggle the conceal view per buffer (raw markup ↔ concealed prose). On/off
-- loop: each press flips conceallevel 2 ↔ 0.
-- mm, not md: <leader>md turns markdown mode ON (core/keymaps.lua) and has to
-- work on a buffer that isn't markdown yet, so it can't live here. md=markdown ·
-- mm=conceal · mp=prettier.
vim.keymap.set("n", "<leader>mm", function()
  vim.opt_local.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
end, { buffer = true, desc = "Markdown: toggle conceal" })
