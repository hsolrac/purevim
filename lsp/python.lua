return {
  name = "pyright",
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_dir = function(fname)
    local util = require("lspconfig.util")
    
    local root_files = {
      "pyproject.toml",    
      "setup.py",         
      "requirements.txt", 
      "Pipfile",           
      "setup.cfg",        
      "manage.py",        
    }
    
    local root = util.root_pattern(unpack(root_files))(fname)
    
    if not root then
      local path = util.path.dirname(fname)
      if path:match("venv") or path:match("env") then
        return nil 
      end
      
      if util.path.extname(fname) == ".py" then
        return util.path.dirname(fname)
      end
      
      return nil
    end
    
    return root
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic", -- "off", "basic", "strict"
        diagnosticSeverityOverrides = {
          reportUndefinedVariable = "error",
          reportMissingImports = "error",
          reportMissingTypeStubs = "warning",
        },
        venvPath = ".",            
        venv = "venv",             
      },
    },
  },
  single_file_support = true,
}
