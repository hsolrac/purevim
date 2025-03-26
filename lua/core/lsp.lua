-- :h lsp-config
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
		end
		if client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({bufnr = args.buf, id = client.id})
				end,
			})
		end
	end,
})

-- -- -- from lsp/*
vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analazer')
vim.lsp.enable('ts_ls')
