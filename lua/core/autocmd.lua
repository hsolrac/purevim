local ok, lsp = pcall(require, "core.lsp")
if not ok then
	vim.notify("Error load core.lsp: " .. lsp, vim.log.levels.ERROR)
	return
end

-- TODO: this needs to be redesigned, while nice for go or rust,
--       lsp formatting for JS/TS projects breaks everything
--
-- autoformat
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.lsp.buf.format({ async = false })
-- 	end,
-- })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
