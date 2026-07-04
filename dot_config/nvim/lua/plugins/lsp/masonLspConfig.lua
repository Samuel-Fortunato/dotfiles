return {
	"mason-org/mason-lspconfig.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Mason",
	opts = {
		ensure_installed = {
			"lua_ls@3.16.4",
			"pyright",
			"clangd",
			"texlab"
		},
		-- handlers = {
		-- 	function(server_name)
		-- 		local capabilities = require("blink.cmp").get_lsp_capabilities()
		-- 		require("lspconfig")[server_name].setup({
		-- 			capabilities = capabilities,
		-- 		})
		-- 	end,
		-- },
	},
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
		"saghen/blink.cmp",
	},
}
