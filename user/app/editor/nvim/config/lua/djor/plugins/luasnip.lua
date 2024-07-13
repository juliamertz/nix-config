local snippets = require("djor.snippets.init")

return {
  "L3MON4D3/LuaSnip",
  event = "VeryLazy",
  version = "v2.*",
  build = "make install_jsregexp",
  config = snippets.init,
}
