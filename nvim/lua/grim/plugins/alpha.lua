return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("<Leader> ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("<Leader> ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("<Leader> fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("<Leader> wr", "󰁯  > Restore Session For Current Directory", "<cmd>AutoSession restore<CR>"),
      dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Buttons are 50 cells stock — too narrow since the SPC → <Leader> relabel,
    -- so the right-aligned hint overprints the longest label. 60 clears it.
    for _, b in ipairs(dashboard.section.buttons.val) do
      b.opts.width = 60
      b.opts.hl_shortcut = "YellowItalic" -- gruvbox-material yellow, tracks the theme
    end

    -- Only shown when something is actually recoverable — a permanent button
    -- would be a permanent lie, and unsaved text from a crash is the one thing
    -- nvim never surfaces on its own (grim.core.recovery explains why).
    -- Inserted above Quit, which stays last.
    local recoverable = #require("grim.core.recovery").list()
    if recoverable > 0 then
      local btn = dashboard.button("r", "  > Recover unsaved text (" .. recoverable .. ")", "<cmd>Recovery<CR>")
      btn.opts.width = 60
      btn.opts.hl_shortcut = "YellowItalic"
      table.insert(dashboard.section.buttons.val, #dashboard.section.buttons.val, btn)
    end

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
