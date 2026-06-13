return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"L3MON4DE/LuaSnip",
		"windwp/nvim-autopairs",
	},
	event = "InsertEnter",
	opts = {
		keymap = {
			preset = 'enter',

			-- Navigating the completion menu with Ctrl+j and Ctrl+k
			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-k>'] = { 'select_prev', 'fallback' },
		},

		appearance = { nerd_font_variant = "normal" },
		snippets = { preset = "luasnip" },

		sources = {
			default = { 'lsp', 'snippets', 'path', 'buffer' },
			providers = {
				snippets = {
					min_keyword_length = 2,
					score_offset = 4,
				},
				lsp = {
					min_keyword_length = 3,
					score_offset = 3,
				},
				path = {
					min_keyword_length = 3,
					score_offset = 2,
				},
				buffer = {
					min_keyword_length = 5,
					score_offset = 1,
				},
			},
		},

		completion = {
			trigger = {
				-- prefetch_n_chars = 2,
				show_on_trigger_character = false,
			},
			list = { selection = { preselect = true, auto_insert = true } },
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 }, { "kind" } }
				},
				border = "rounded"
			},
			documentation = { window = { border = "rounded" }, auto_show = true },
		},
	},
}
