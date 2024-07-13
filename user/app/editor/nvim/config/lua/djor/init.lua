vim.g.mapleader = " "

require("djor.lazy")
require("djor.set")
require("djor.binds")

vim.filetype.add({
	pattern = {
		[".*/hypr/.*%.conf"] = "hyprlang",
	},
})
