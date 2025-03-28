local M = {}

local function setup_lsp()
    vim.diagnostic.config({
        virtual_text = true,
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

    local servers = {
        lua_ls = require("lsp.lua_ls"),
        pyright = require("lsp.python"),
        tsserver = require("lsp.typescript"), 
				rust_analyzer = require("lsp.rust")
    }

    local function start_server(name)
        local server = servers[name]
        if not server then return end

        if vim.fn.executable(server.cmd[1]) ~= 1 then
            vim.notify(string.format("Server LSP '%s' not found", name),
                vim.log.levels.WARN)
            return
        end

        local client = vim.lsp.start({
            name = server.name,
            cmd = server.cmd,
            root_dir = server.root_dir,
            capabilities = server.capabilities,
            settings = server.settings,
        })
    end

    for name, _ in pairs(servers) do
        start_server(name)
    end
end

function M.setup()
    setup_lsp()
end

return M
