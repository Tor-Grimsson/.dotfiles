return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- pin to the stable API (main is a rewrite that drops nvim-treesitter.configs)
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })

    -- use bash parser for zsh files
    vim.treesitter.language.register("bash", "zsh")

    -- ponytail: nvim-treesitter (master) is broken on Neovim 0.12 — 0.12 dropped the
    -- `all=false` single-node match API, so injection directives now receive a *list*
    -- of nodes and pass it to get_node_text(), crashing on every markdown/html code
    -- fence ("attempt to call method 'range' (a nil value)" via the conceal_line
    -- highlighter). Fix once at the shared chokepoint: unwrap list -> last node in
    -- get_node_text, instead of reimplementing set-lang-from-info-string!/-mimetype!/
    -- downcase!. No-op on real (userdata) nodes. Remove when migrating to the
    -- nvim-treesitter `main` branch, or if pinning back to Neovim 0.11.
    if vim.fn.has("nvim-0.12") == 1 then
      local orig_get_node_text = vim.treesitter.get_node_text
      vim.treesitter.get_node_text = function(node, source, opts)
        if type(node) == "table" then
          node = node[#node] -- 0.12 hands a list of nodes; take the matched one
        end
        return orig_get_node_text(node, source, opts)
      end
    end
  end,
}
