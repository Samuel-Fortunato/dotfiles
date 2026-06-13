function load_snippets()
	require("luasnip.loaders.from_lua").lazy_load({
		paths = vim.fn.stdpath("config") .. "/lua/snippets",
	})
	require("luasnip.loaders.from_vscode").lazy_load({
		exclude = { "latex" },
	})
end

return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	dependencies = { "rafamadriz/friendly-snippets" },
	keys = { {
		"<leader>S",
		function()
			load_snippets()
			vim.notify("LuaSnip snippets reloaded!", vim.log.levels.INFO)
		end,
		desc = "Reload LuaSnip snippets",
	}, },
	opts = {
		enable_autosnippets = true,
		store_selection_keys = "<Tab>",
		update_events = "TextChanged,TextChangedI",
	},
	config = function(_, opts)
		local ls = require("luasnip")
		ls.config.set_config(opts)

		load_snippets()
	end,
}
