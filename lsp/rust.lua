return {
	name = "rust_analyzer",
	cmd = { "rust-analyzer" },
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importPrefix = "self",
			},
			cargo = {
				loadOutDirsFromCheck = true,
			},
			procMacro = {
				enable = true,
			},
			diagnostics = {
				enable = true,
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
} 
