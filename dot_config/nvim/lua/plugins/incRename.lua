return {
	"smjonas/inc-rename.nvim",
	cmd = "IncRename",
	keys = {
		{
			"grn",
			function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end,
			desc = "Lsp Rename",
			expr = true,
		},
	},
	opts = {}
}
