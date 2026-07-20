return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  opts = {
    enable_afterquote = false,
    check_ts = true, -- treesitter-aware pairing
    ts_config = {
      lua = { "string" }, -- don't pair inside lua string nodes
    },
  },
}
