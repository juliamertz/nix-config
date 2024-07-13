return {
	{
		"eandrju/cellular-automaton.nvim",
		event = "BufRead",
	},

	-- Nvim-Colorizer
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufRead",
		config = function()
			require("colorizer").setup({})
		end,
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		opts = {},
		lazy = false,
		config = function()
			require("Comment").setup()
		end,
	},

	-- Moveline
	{
		"willothy/moveline.nvim",
		event = "VeryLazy",
		build = "make",
		config = function()
			local moveline = require("moveline")

			vim.keymap.set("n", "<M-k>", moveline.up)
			vim.keymap.set("n", "<M-j>", moveline.down)
			vim.keymap.set("v", "<M-k>", moveline.block_up)
			vim.keymap.set("v", "<M-j>", moveline.block_down)
		end,
	},

	-- Indent blankline
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		main = "ibl",
		opts = {},
	},

	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
}
