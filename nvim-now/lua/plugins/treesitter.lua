-- Treesitter, main branch (the rewrite): install() + a FileType autocmd replace
-- the old ensure_installed/highlight tables. Needs the tree-sitter CLI on PATH.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      -- ours: trimmed to the languages actually written here
      treesitter.install({
        "bash", "css", "dockerfile", "gitignore", "graphql", "html",
        "javascript", "json", "lua", "markdown", "markdown_inline",
        "query", "regex", "svelte", "tsx", "typescript", "vim", "vimdoc", "yaml",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end
          pcall(vim.treesitter.start, buf, lang)
          -- treesitter indentation (skip yaml/markdown — theirs is worse than builtin)
          if ft ~= "yaml" and ft ~= "markdown" then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.bo[buf].smartindent = false
            vim.bo[buf].cindent = false
          end
        end,
      })
    end,
  },
  -- auto close/rename tags in jsx/tsx/html/svelte
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },
}
