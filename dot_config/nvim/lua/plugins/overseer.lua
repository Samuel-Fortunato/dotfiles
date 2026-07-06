return {
	'stevearc/overseer.nvim',
	event = "VeryLazy",
	dependencies = {
		"akinsho/toggleterm.nvim",
		"nvim-lualine/lualine.nvim",
	},
	keys = {
		{ "<leader>cb", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle List" },
		{ "<leader>cr", "<cmd>OverseerRun<cr>",    desc = "Overseer: Run Task" },
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
