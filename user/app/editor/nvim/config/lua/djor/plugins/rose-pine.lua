return {
	"rose-pine/neovim",
	as = "rose-pine",
	config = function()
		require("rose-pine").setup({
			variant = "moon",
			dim_inactive_windows = false,
			styles = {
				transparency = true,
			},
		})

		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.cmd("hi Normal guibg=none ctermbg=none")
		vim.cmd("colorscheme rose-pine-moon")
	end,
}
