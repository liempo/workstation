return {
	{ -- Commentary
		"tpope/vim-commentary",
		config = function()
			vim.cmd([[autocmd FileType swift setlocal commentstring=//\ %s]])
		end,
	},

	{ -- Context based comments (configured per project via config.project)
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
	},

	{ -- Surround
		"tpope/vim-surround",
	},

	{ -- Formatter (configured per project via config.project)
		"stevearc/conform.nvim",
		lazy = true,
	},
}
