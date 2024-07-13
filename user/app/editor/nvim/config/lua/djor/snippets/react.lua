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

local utils = require('djor.snippets')

-- will replicate a given node index but capitalize the first letter
local function same_capitalized(index)
  return ls.function_node(function(args)
    vim.notify(vim.inspect(args))
    local val = args[1][1]
    args[1][1] = val:sub(1, 1):upper() .. val:sub(2)

    return args[1]
  end, { index })
end


return {
  useeffect = s({ trig = "useeffect", }, fmt([[
    useEffect(() => {{
      {}
    }}, [{}])
  ]], { i(1), i(2) })),

  usetranslation = s({ trig = "usetrans" }, fmt([[
  const {{ t }} = useTranslation(["{}"])
  ]], { i(1) })),

  usestate = s({ trig = "usestate" }, fmt([[
    const [{}, set{}] = useState({})
  ]], { i(1), same_capitalized(1), i(2) })),

  export_default_function = s({
    trig = "export default function",
    snippetType = "autosnippet"
  }, fmt([[
  export default function {}() {{
    return (
      <{}>{}</{}>
    )
  }}
  ]],
    { i(1), i(2), i(3), utils.same(2) })),
}
