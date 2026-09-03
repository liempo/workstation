local M = {}

local function load_plugin(name)
	local ok, lazy = pcall(require, "lazy")
	if ok then
		lazy.load({ plugins = { name } })
	end
end

--- Per-project formatter setup (call from trusted .nvim.lua).
---@param opts table? conform.setup options; formatters_by_ft is required for format-on-save
function M.setup_conform(opts)
	load_plugin("conform.nvim")
	local defaults = {
		format_on_save = function(_)
			return { timeout_ms = 200, lsp_fallback = true }
		end,
		log_level = vim.log.levels.ERROR,
	}
	require("conform").setup(vim.tbl_deep_extend("force", defaults, opts or {}))
end

--- Per-project context comments (needs treesitter in the project if you use TS/JS).
---@param opts table? ts_context_commentstring.setup options
function M.setup_context_comments(opts)
	load_plugin("nvim-ts-context-commentstring")
	require("ts_context_commentstring").setup(opts or {})
end

return M
