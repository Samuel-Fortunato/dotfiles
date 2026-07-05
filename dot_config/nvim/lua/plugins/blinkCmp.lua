return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"L3MON4DE/LuaSnip",
		"windwp/nvim-autopairs",
		'saghen/blink.compat',
		"lervag/vimtex",
	},
	event = "InsertEnter",
	opts = {
		keymap = {
			preset = 'enter',

			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-k>'] = { 'select_prev', 'fallback' },
		},

		appearance = { nerd_font_variant = "normal" },
		snippets = { preset = "luasnip" },

		sources = {
			default = { 'lsp', 'vimtex', 'snippets', 'path', 'buffer' },
			per_filetype = { "codecompanion" },
			providers = {
				snippets = {
					min_keyword_length = 2,
					-- score_offset = 5,
				},
				vimtex = {
					name = "vimtex",
					-- min_keyword_length = 2,
					module = "blink.compat.source",
					-- score_offset = 4,
				},
				lsp = {
					-- min_keyword_length = 3,
					-- score_offset = 3,
				},
				path = {
					-- min_keyword_length = 3,
					-- score_offset = 2,
				},
				buffer = {
					min_keyword_length = 5,
					-- score_offset = 1,
				},
			},
		},

		completion = {
			trigger = {
				show_on_trigger_character = false,
			},
			list = { selection = { preselect = true, auto_insert = false } },
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 }, { "kind" } }
				},
				border = "rounded"
			},
			documentation = {
				window = { border = "rounded" },
				auto_show = true,
				auto_show_delay_ms = 500
			},
		},
	},
}
