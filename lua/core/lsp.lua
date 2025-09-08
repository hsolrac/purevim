local M = {}

local function setup_diagnostics()
	vim.diagnostic.config({
		virtual_text = false,
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = "●",
		},
	})
end

local function is_executable(cmd)
	return vim.fn.executable(cmd[1]) == 1
end

local function file_exists(pattern)
	return vim.fn.glob(pattern) ~= ""
end

local servers = {
	lua_ls = {
		config = require("lsp.lua_ls"),
		filetype = "lua"
	},
	tsserver = {
		config = require("lsp.typescript"),
		filetype = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		}
	},
	rust_analyzer = {
		config = require("lsp.rust"),
		filetype = "rust"
	}
}

local function start_server(name, server)
	if not server or not server.config then return end

	if not is_executable(server.config.cmd) then
		vim.notify(string.format("Server LSP '%s' not found", name),
			vim.log.levels.DEBUG)
		return
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = server.filetype,
		callback = function()
			vim.lsp.start({
				name = server.config.name,
				cmd = server.config.cmd,
				root_dir = server.config.root_dir,
				capabilities = server.config.capabilities,
				settings = server.config.settings,
			})
		end,
	})
end

function M.setup()
	setup_diagnostics()

	for name, server in pairs(servers) do
		start_server(name, server)
	end
end

return M
