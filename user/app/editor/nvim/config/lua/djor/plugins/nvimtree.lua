return {
  'nvim-tree/nvim-tree.lua',
  cmd = "NvimTreeToggle",
  event = "VeryLazy",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local nvimtree = require('nvim-tree.api')
    require("nvim-tree").setup({
      sort_by = "extension",
      view = {
        side = "right",
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false
      },
    })
    vim.keymap.set('n', "<C-b>", nvimtree.tree.toggle)
  end
}
