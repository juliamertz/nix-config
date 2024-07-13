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
  boilerplate = s({ trig = "!", }, fmt([[
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <title>{}</title>
      <meta name="viewport" content="width=device-width,initial-scale=1" />
      <meta name="description" content="" />
      <link rel="icon" href="favicon.png">
    </head>
    <body>
      <div>{}</div>
    </body>
  </html>
  ]], { i(1), i(2) })),
}
