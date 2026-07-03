return {
	"folke/which-key.nvim",
	name = "which-key",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	opts = {
		preset = "modern",
		spec = {
			{ "<leader>f", group = "Find", icon = " " },
			{ "<leader>e", group = "File Explorer", icon = "󰙅 " },
			{ "<leader>n", group = "Notifications" },
		},
	},
	keys = {
		{
		  "<leader>?",
		  function()
			require("which-key").show({ global = false })
		  end,
		  desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
