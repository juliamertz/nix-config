local luasnip = require("luasnip")
local M = {}

M.clean_snippet_name = function(name)
  return name:gsub("_", " ")
end

---@param snippets table
---@param lang string|string[]
M.add_snippets = function(snippets, lang)
  local stack = {}
  for _, snippet in pairs(snippets) do
    table.insert(stack, snippet)
  end

  if type(lang) == "table" then
    for _, l in pairs(lang) do
      luasnip.add_snippets(l, stack)
    end
    return
  else
    luasnip.add_snippets(lang, stack)
  end
end

M.insert_snippet = function(snippet)
  luasnip.snip_expand(snippet)
end


M.same = function(index)
  return luasnip.function_node(function(args)
    return args[1]
  end, { index })
end

local opts = {
  noremap = true,
  silent = true
}

M.init = function()
  luasnip.cleanup()
  luasnip.setup({
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    history = true,
  })

  local lua = require("djor.snippets.lua")
  local react = require("djor.snippets.react")
  local go = require("djor.snippets.go")
  local html = require("djor.snippets.html")
  local common = require("djor.snippets.common")

  M.add_snippets(lua, 'lua')
  M.add_snippets(react, 'typescriptreact')
  M.add_snippets(go, 'go')
  M.add_snippets(common, 'all')
  M.add_snippets(html, { 'html', 'htmldjango' })

  vim.keymap.set("n", "<leader>ee", function()
    M.insert_snippet(go.if_err)
  end, opts)

  vim.keymap.set("n", "<leader>us", function()
    if vim.bo.filetype == "typescriptreact" then
      M.insert_snippet(react.usestate)
    end
  end, opts)

  vim.keymap.set("n", "<leader>ue", function()
    if vim.bo.filetype == "typescriptreact" then
      M.insert_snippet(react.useeffect)
    end
  end, opts)

  vim.keymap.set({ "i" }, "<C-K>", function() luasnip.expand() end, opts)
  vim.keymap.set({ "i", "s" }, "<C-L>", function() luasnip.jump(1) end, opts)
  vim.keymap.set({ "i", "s" }, "<C-J>", function() luasnip.jump(-1) end, opts)
  vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    end
  end, opts)
end

return M
