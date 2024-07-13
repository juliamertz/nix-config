return {
  'MunifTanjim/prettier.nvim',
  event = "BufRead",
  config = function()
    local prettier = require("prettier")

    prettier.setup({
      bin = 'prettier',
      filetypes = {
        "css",
        "svelte",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
    })
  end
}
