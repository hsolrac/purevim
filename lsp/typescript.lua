return {
	name = "tsserver",
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	settings = {
		javascript = {
			validate = { enable = true },
		},
		typescript = {
			validate = { enable = true },
		},
	},
} 
