return {

	{ -- NeoGotham
		"https://gitlab.com/shmerl/neogotham",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("neogotham")
		end,
	},

	{ -- Dashboard
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					week_header = {
						enable = true,
					},
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},

	{ -- File Explorer
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 30,
				},
				update_focused_file = {
					enable = true,
				},
				renderer = {
					group_empty = true,
				},
			})
			vim.api.nvim_set_keymap("n", "<Leader>s", ":NvimTreeToggle<CR>", {
				noremap = true,
				silent = true,
			})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{ -- Status line (flat NeoGotham; no powerline separators — those stay on tmux)
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		config = function()
			-- NeoGotham — https://gitlab.com/shmerl/neogotham
			local g = {
				bg0 = "#0c1014",
				bg1 = "#11151c",
				bg2 = "#091f2e",
				bg3 = "#0a3749",
				fg = "#99d1ce",
				dim = "#599cab",
				blue = "#195466",
				cyan = "#33859e",
				green = "#2aa889",
				yellow = "#edb443",
				red = "#c23127",
				violet = "#4d618e",
			}

			local theme = {
				normal = {
					a = { fg = g.bg0, bg = g.dim, gui = "bold" },
					b = { fg = g.fg, bg = g.bg2 },
					c = { fg = g.dim, bg = g.bg1 },
				},
				insert = {
					a = { fg = g.bg0, bg = g.green, gui = "bold" },
					b = { fg = g.fg, bg = g.bg2 },
					c = { fg = g.dim, bg = g.bg1 },
				},
				visual = {
					a = { fg = g.bg0, bg = g.violet, gui = "bold" },
					b = { fg = g.fg, bg = g.bg2 },
					c = { fg = g.dim, bg = g.bg1 },
				},
				replace = {
					a = { fg = g.bg0, bg = g.red, gui = "bold" },
					b = { fg = g.fg, bg = g.bg2 },
					c = { fg = g.dim, bg = g.bg1 },
				},
				command = {
					a = { fg = g.bg0, bg = g.yellow, gui = "bold" },
					b = { fg = g.fg, bg = g.bg2 },
					c = { fg = g.dim, bg = g.bg1 },
				},
				inactive = {
					a = { fg = g.dim, bg = g.bg2 },
					b = { fg = g.dim, bg = g.bg1 },
					c = { fg = g.blue, bg = g.bg1 },
				},
			}

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = theme,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	{ -- Bufferline
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		config = function()
			require("barbar").setup({
				auto_hide = true,
			})
			vim.api.nvim_set_keymap("n", "<leader>hh", ":BufferPrevious<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<leader>ll", ":BufferNext<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<leader>HH", ":BufferMovePrevious<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<leader>LL", ":BufferMoveNext<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<leader>q", ":BufferClose<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<leader>Q", ":BufferClose!<CR>", {
				noremap = true,
				silent = true,
			})
		end,
	},

	{ -- Fuzzy search
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		end,
	},
}
