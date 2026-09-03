local M = {}

local function on_attach(client, bufnr)
	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
	map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
	map("n", "gt", vim.lsp.buf.type_definition, "LSP: Go to type definition")
	map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
	map("n", "gr", function()
		require("telescope.builtin").lsp_references()
	end, "LSP: References")
	map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to implementation")
	map("i", "<C-h>", vim.lsp.buf.signature_help, "LSP: Signature help")

	if client:supports_method("textDocument/codeAction") then
		map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
	end

	if client:supports_method("textDocument/rename") then
		map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
	end

	if client:supports_method("textDocument/formatting") then
		map("n", "<leader>f", function()
			vim.lsp.buf.format({ bufnr = bufnr, async = true })
		end, "LSP: Format")
	end
end

function M.setup()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok then
		capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	end

	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"ts_ls",
			"svelte",
			"tailwindcss",
		},
		-- nixd is not in Mason; provide via direnv or system PATH.
		-- Projects enable servers via trusted .nvim.lua (vim.o.exrc).
		automatic_enable = false,
	})

	vim.lsp.config("*", {
		capabilities = capabilities,
		on_attach = on_attach,
	})

	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				diagnostics = {
					globals = { "vim" },
					disable = { "missing-fields" },
				},
			},
		},
	})

	vim.lsp.config("nixd", {})

	-- Uses system `deno` from home/packages.nix
	vim.lsp.config("denols", {
		root_markers = { "deno.json", "deno.jsonc" },
	})

	vim.lsp.config("ts_ls", {
		root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
		single_file_support = false,
	})

	vim.lsp.config("svelte", {})

	vim.lsp.config("tailwindcss", {
		filetypes = {
			"html",
			"css",
			"scss",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"svelte",
		},
	})

	-- Xcode provides sourcekit-lsp; not installed via Mason
	vim.lsp.config("sourcekit", {
		cmd = { "sourcekit-lsp" },
	})

	-- No global vim.lsp.enable — each project .nvim.lua enables what it needs.
end

return M
