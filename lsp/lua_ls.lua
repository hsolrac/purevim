return {
	name = "lua_ls",
	filesType = { "lua" },
	cmd = { "lua-language-server" },
	root_dir = vim.fs.dirname(vim.fs.find({ "lua_ls.json", ".git" }, { upward = true })[1]),
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	settings = {
		Lua = {
			runtime = {
				version = "Lua5.4",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				enable = true,
				disable = { "undefined-field" },
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand "$VIMRUNTIME/lua"] = true,
					[vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
