return {
	"nat-418/boole.nvim",
	event = "VeryLazy",
	config = {
		mappings = {
			increment = "<C-s>",
			decrement = "<C-x>",
		},
		additions = {
			{ "foo", "bar", "baz" },
			{ "tic", "tac", "toe" },
			{ "hex", "rgb", "hsl" },
			{ "dev", "prod", "test" },
			{ "development", "production", "testing" },
		},
		allow_caps_additions = {
			{ "enable", "disable" },
		},
	},
}
