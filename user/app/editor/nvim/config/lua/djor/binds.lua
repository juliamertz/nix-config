local utils = require('djor.utils')
local undotree = require('undotree')

local keymap = vim.keymap.set
local opts = {
  noremap = true,
  silent = true
}

-- Pane navigation movements
keymap('n', "<C-h>", "<C-w>h", opts)
keymap('n', "<C-j>", "<C-w>j", opts)
keymap('n', "<C-k>", "<C-w>k", opts)
keymap('n', "<C-l>", "<C-w>l", opts)

-- Yank to system clipboard
keymap('n', "<leader>y", '"+y', opts)

-- Miscelanious
keymap('n', "<leader>kk", "<cmd>CellularAutomaton make_it_rain<CR>", opts)
keymap('n', "<leader>cb", utils.buf_kill, opts)
keymap('n', '<leader>ut', undotree.toggle, opts)

local function yank_history()
  require('telescope').extensions.yank_history.yank_history({})
end
keymap('n', '<leader>pp', yank_history)

-- Yanky
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

local binds = {
  lsp = {
    definition = 'gd',
    hover = 'K',
    workspace_symbol = '<leader>vws',
    open_float = '<leader>vd',
    goto_next = '[d',
    goto_prev = ']d',
    code_action = '<leader>vca',
    rename = '<leader>vrn',
    signature_help = '<C-h>'
  },
  cmp = {
    select_prev_item = '<C-p>',
    select_next_item = '<C-n>',
    confirm = '<C-y>',
    complete = '<C-Space>'
  },
}

return binds
