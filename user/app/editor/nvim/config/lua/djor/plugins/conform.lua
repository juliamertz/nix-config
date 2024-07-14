local opts = {
  format_on_save = false,
  -- format_on_save = {
  -- 	timeout_ms = 500,
  -- 	lsp_fallback = true,
  -- },
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    typescriptreact = { "rustywind", { "prettierd", "prettier" } },
    go = { "gofumpt" },
    markdown = { "markdownlint" },
    python = { "ruff_format" },
    rust = { "rustfmt" },
    handlebars = { "prettier" },
    sql = { "sql-formatter" },
    nix = { "nixpkgs-fmt" },
    -- toml = { "taplo" },
  },
  formatters = {
    taplo = {
      command = "taplo",
      args = { "fmt", "--option", "align_entries=true", "$FILENAME" },
      stdin = false,
    },
    ["sql-formatter"] = {
      command = "sql-formatter",
      args = { "$FILENAME" },
      stdin = true,
    },
  },
}

return {
  "stevearc/conform.nvim",
  event = "BufRead",
  config = function()
    require("conform").setup(opts)

    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })

    vim.keymap.set("n", "<leader>ff", ":Format<CR>")
  end,
}
