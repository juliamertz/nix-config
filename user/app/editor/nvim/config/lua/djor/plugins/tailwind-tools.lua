return {
  "luckasRanarison/tailwind-tools.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    document_color = {
      enabled = true,
      kind = "inline",
      inline_symbol = "󰝤 ",
      debounce = 200,
    },
    conceal = {
      enabled = false,
      min_length = nil,
      symbol = "󱏿",
      highlight = {
        fg = "#38BDF8",
      },
    },
    custom_filetypes = { "htmlaskama" },
  }
}
