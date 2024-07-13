local utils = require("djor.utils")

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = "master",
    cmd = "Telescope",
    event = "BufWinEnter",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          layout_config = {
            vertical = { width = 0.5 }
          },
        },
      })

      local builtin = require('telescope.builtin')
      local picker_opts = {
        hidden = true,
        no_ignore = true,
      }

      local find_files = utils.wrap_fn(builtin.find_files, picker_opts)
      local live_grep = utils.wrap_fn(builtin.live_grep, picker_opts)
      local git_files = utils.wrap_fn(builtin.git_files, { show_untracked = true })

      local keymap = vim.keymap.set
      local opts = {
        noremap = true,
        silent = true
      }

      keymap('n', '<leader>pf', git_files, opts)
      keymap('n', '<leader>af', find_files, opts)
      keymap('n', '<leader>gs', live_grep, opts)
      keymap('n', '<leader>rf', builtin.lsp_references, opts)
      keymap('n', '<leader>gc', builtin.git_commits, opts)
      keymap('n', '<leader>ts', builtin.treesitter, opts)
      keymap('n', '<leader>ht', builtin.help_tags, opts)
    end
  },
}
