return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	keys = {
		{ "<leader><space>", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Find Files" }
	},
	opts = {
		interactions = {
			chat = {
				adapter = "gemini1",
				slash_commands = {
					["image"] = {
						opts = {
							dirs = { "/home/samff/Pictures/Screenshots/" }
						}
					}
				},
			},
			inline = {
				adapter = "gemini1",
			},
			cmd = {
				adapter = "gemini1",
			},
		},
		adapters = {
			http = {
				gemini1 = function()
					return require("codecompanion.adapters").extend("gemini", {
						schema = {
							model = {
								default = "gemini-3.1-flash-lite",
							},
						}
					})
				end,
			}
		}
	},
}
