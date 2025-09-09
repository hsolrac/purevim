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

local function file_exists(pattern)
  return vim.fn.glob(pattern) ~= ""
end

local function is_lua_project()
  return file_exists("lua_ls.json")
      or file_exists(".luarc.json")
      or vim.fn.isdirectory("lua") == 1
end

local function is_ts_project()
  return file_exists("package.json")
      or file_exists("tsconfig.json")
      or file_exists("jsconfig.json")
end

local function is_rust_project()
  return file_exists("Cargo.toml")
end

local servers = {
  lua_ls = {
    config = require("lsp.lua_ls"),
    filetype = "lua",
    check_root = is_lua_project,
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
    },
    check_root = is_ts_project,
  },
  rust_analyzer = {
    config = require("lsp.rust"),
    filetype = "rust",
    check_root = is_rust_project,
  },
}

local function start_server(name, server)
  if not server or not server.config then return end
  -- Only attach if project check passes
  if server.check_root and not server.check_root() then return end

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
