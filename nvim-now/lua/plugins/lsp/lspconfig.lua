-- LSP via the new core API: vim.lsp.config() + vim.lsp.enable() per server
-- (Sin-cy's updated layout — the video's mason-handlers version broke).
-- ours: server set trimmed to the actual stack; <leader>D uses Telescope (no snacks).
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    -- buffer-local keymaps once a server attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        opts.desc = "Show LSP references"
        vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See available code actions"
        vim.keymap.set({ "n", "v" }, "<leader>vca", vim.lsp.buf.code_action, opts)

        opts.desc = "Smart rename"
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show line diagnostics"
        vim.keymap.set("n", "df", vim.diagnostic.open_float, opts)

        opts.desc = "Show documentation for what is under cursor"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Show signature help"
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
      end,
    })

    -- diagnostics: sign icons + float style
    local signs = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = " ",
    }
    vim.diagnostic.config({
      signs = { text = signs },
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
      },
    })

    vim.keymap.set("n", "<leader>lx", function()
      local current = vim.diagnostic.config().virtual_text
      vim.diagnostic.config({ virtual_text = not current })
    end, { desc = "Toggle LSP virtual text" })

    -- completion capabilities from blink into every server
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    vim.lsp.config("*", { capabilities = capabilities })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    vim.lsp.config("ts_ls", {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      single_file_support = true,
      init_options = {
        preferences = {
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
        },
      },
    })

    vim.lsp.config("cssls", {
      filetypes = { "css", "scss", "less" },
      init_options = { provideFormatter = true },
      single_file_support = true,
      settings = {
        css = { lint = { unknownAtRules = "ignore" }, validate = true },
        scss = { lint = { unknownAtRules = "ignore" }, validate = true },
        less = { lint = { unknownAtRules = "ignore" }, validate = true },
      },
    })

    vim.lsp.config("tailwindcss", {
      filetypes = {
        "html", "css", "javascript", "typescript",
        "javascriptreact", "typescriptreact", "svelte",
      },
    })

    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.enable({
      "lua_ls",
      "ts_ls",
      "html",
      "cssls",
      "tailwindcss",
      "svelte",
      "graphql",
      "emmet_ls",
      "eslint",
      "marksman",
    })
  end,
}
