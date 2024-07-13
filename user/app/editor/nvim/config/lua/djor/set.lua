vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wrap = false
vim.opt.selection = "exclusive"
vim.opt.swapfile = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 12

vim.opt.updatetime = 50
vim.wo.fillchars = "eob: " -- remove tilde from empty lines

vim.o.cmdheight = 0

-- Disable semantic lsp highlighting (which breaks treesitter highlights)
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
	vim.api.nvim_set_hl(0, group, {})
end
