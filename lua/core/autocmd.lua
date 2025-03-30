local ok, lsp = pcall(require, "core.lsp")
if not ok then
	vim.notify("Error load core.lsp: " .. lsp, vim.log.levels.ERROR)
	return
end

-- autoformat
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

vim.diagnostic.config({
	virtual_text = false,
	float = {
		border = border,
		header = '',
		prefix = function(diagnostic, i, total)
			local severity_names = {
				[vim.diagnostic.severity.ERROR] = "Error",
				[vim.diagnostic.severity.WARN] = "Warn",
				[vim.diagnostic.severity.INFO] = "Info",
				[vim.diagnostic.severity.HINT] = "Hint",
			}

			local icons = {
				Error = " ",
				Warn = " ",
				Info = " ",
				Hint = " ",
			}

			return icons[severity_names[diagnostic.severity]] or ""
		end,
	}
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	callback = function()
		vim.diagnostic.open_float(nil, {
			scope = "cursor",
			focusable = false,
			close_events = {
				"CursorMoved",
				"CursorMovedI",
				"BufLeave",
				"InsertCharPre",
				"WinLeave"
			}
		})
	end
})


vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
