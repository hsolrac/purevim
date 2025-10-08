-- Main configuration Neovim
-- Author: Carlos

local start_time = vim.loop.hrtime()

package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua"

-- Load optional early_init.lua file
pcall(require, "early_init")

-- Try to load private feature toggles
local ok, private = pcall(require, "private")
if not ok then
	private = {} -- default: everything enabled
end

-- Helper to conditionally run modules
local function run_if(feature, fn)
	if private[feature] == false then
		return
	end
	fn()
end

-- Core modules
require("core.options")
require("core.keymaps")

-- Optional modules
run_if("lsp", function()
	require("core.lsp").setup()
end)
run_if("autocmd", function()
	require("core.autocmd")
end)
run_if("treesitter", function()
	require("core.treesitter")
end)
run_if("search", function()
	require("core.search")
end)
run_if("lazygit", function()
	require("core.lazygit")
end)
run_if("fzf", function()
	require("core.fzf")
end)
run_if("statusline", function()
	require("core.statusline")
end)
run_if("colorscheme", function()
	require("core.colorscheme").setup()
end)
run_if("usql", function()
	require("core.usql")
end)

-- Load optional post_init.lua file
pcall(require, "post_init")

-- Neovim is booted! How long did it take?
vim.schedule(function()
	local elapsed = (vim.loop.hrtime() - start_time) / 1e6 -- convert nanoseconds to milliseconds
	print(string.format(">>> [PureVim] loaded in %.2f ms", elapsed))
end)
