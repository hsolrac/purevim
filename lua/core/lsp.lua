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

local servers = {
	lua_ls = require("lsp.lua_ls"),
	tsserver = require("lsp.typescript"),
	rust_analyzer = require("lsp.rust")
}

local function start_server(name)
	local server = servers[name]
	if not server then return end

	if not is_executable(server.cmd) then
		vim.notify(string.format("Server LSP '%s' not found", name),
			vim.log.levels.WARN)
		return
	end

	vim.lsp.start({
		name = server.name,
		cmd = server.cmd,
		root_dir = server.root_dir,
		capabilities = server.capabilities,
		settings = server.settings,
	})
end

function M.setup()
	setup_diagnostics()

	for name, _ in pairs(servers) do
		start_server(name)
	end
end

return M
