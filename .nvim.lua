-- Project config for this dots repo. Trust once: :trust
local project = require("config.project")

project.setup_conform({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
	},
})

vim.lsp.enable({ "lua_ls", "nixd" })
