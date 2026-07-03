return {
	"skywind3000/vim-keysound",
	event = "VeryLazy",
	keys = {
		{ "<leader>k", "<cmd>KeysoundToggle<cr>", desc = "Find Files" },
	},
	init = function()
		-- vim.g.keysound_enable = 1
		vim.g.keysound_theme = "typewriter"
		-- vim.g.keysound_volume = 500
	end,
}
