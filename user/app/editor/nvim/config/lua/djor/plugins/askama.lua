return {
	{
		"jorismertz/askama.nvim",
		-- name = "askama.nvim",
		-- dir = "~/projects/2024/askama.nvim",
    build = "build.lua",
    event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"L3MON4D3/LuaSnip",
		},
		opts = {
			branch = "stable",
			-- parser_path = "/home/joris/projects/2024/askama_treesitter",
			file_extension = "html",
			enable_snippets = true,
			snippet_autopairs = true,
		},
	},
}
