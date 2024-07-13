return {
	"folke/trouble.nvim",
	keys = {
		{
			"<leader>pr",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>vrr",
			"<cmd>Trouble lsp_references toggle<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle<cr>",
			desc = "Symbols (Trouble)",
		},
	},
	opts = {
		focus = true,
		warn_no_results = false,
		open_no_results = true,
		modes = {
			symbols = {
				desc = "document symbols",
				mode = "lsp_document_symbols",
				focus = true,
				win = {
					position = "right",
					size = 0.4,
				},
			},
		},
	},
}
