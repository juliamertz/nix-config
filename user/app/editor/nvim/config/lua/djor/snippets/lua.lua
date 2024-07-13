local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local s = ls.snippet

local require_var = function(args, _)
  local text = args[1][1] or ""
  text = text:gsub("-", "_")
  local split = vim.split(text, ".", { plain = true })

  local options = {}
  for len = 0, #split - 1 do
    table.insert(options, t(table.concat(vim.list_slice(split, #split - len, #split), "_")))
  end

  return ls.sn(nil, {
    c(1, options),
  })
end

return {
  req = s({ trig = "req" }, fmt([[local {} = require("{}")]], {
    d(2, require_var, { 1 }),
    i(1),
  })),
  func = s({ trig = "func" }, fmt([[function({})\n\t{}\nend]], {
    i(1, "args"),
    i(0),
  })),
}
