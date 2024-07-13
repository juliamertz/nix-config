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

return {
  if_err = s({ trig = "if_err", snippetType = "autosnippet" }, fmt([[
      if err != nil {{
        return {}
      }}
    ]],
    { i(1) }
  )),
}
