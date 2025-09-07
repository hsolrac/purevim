-- Main configuration Neovim
-- Autor: Carlos
package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua"

require("core.options")
require("core.keymaps")
require("core.lsp").setup()
require("core.autocmd")
require("core.treesitter")
require("core.search")
