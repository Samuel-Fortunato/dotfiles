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
				adapter = "ollama",
				slash_commands = {
					["image"] = {
						opts = {
							dirs = { "/home/samff/Pictures/Screenshots/" }
						}
					}
				},
			},
			inline = {
				adapter = "ollama",
			},
			cmd = {
				adapter = "ollama",
			},
		},
		adapters = {
			http = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = {
								default = "qwen3.5:9b",
							},
							num_ctx = {
								default = 16384,
							},
						},
					})
				end,
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
