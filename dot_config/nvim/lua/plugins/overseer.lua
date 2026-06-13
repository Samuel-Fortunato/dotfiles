return {
	'stevearc/overseer.nvim',
	event = "VeryLazy",
	dependencies = {
		"akinsho/toggleterm.nvim",
		"nvim-lualine/lualine.nvim",
	},
	keys = {
		{ "<leader>bb", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle List" },
		{ "<leader>br", "<cmd>OverseerRun<cr>",    desc = "Overseer: Run Task" },
	},
	opts = {
		templates = { "builtin" },
		form = {
			border = "rounded",
			win_opts = {
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
			},
		},
		task_win = {
			border = "rounded",
			win_opts = {
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
			},
		}
	},
}
