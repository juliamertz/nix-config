local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local branch = "stable"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=" .. branch,
    lazypath,
  })
end

---@diagnostic disable: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = "djor.plugins",
  change_detection = { notify = false }
})
