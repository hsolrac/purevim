return {
	name = "pyright",
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				typeCheckingMode = "basic",
				diagnosticSeverityOverrides = {
					reportUndefinedVariable = "error",
				},
			},
		},
	},
} 
