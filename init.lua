-- Main configuration Neovim
-- Author: Carlos

_G.start_time = vim.loop.hrtime()

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
require("core.integrations.git").setup()

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
	require("core.integrations.lazygit")
end)
run_if("fzf", function()
	require("core.integrations.fzf").setup({
		position = "bottom",
		width_ratio = 1,
		height_ratio = 0.3,
		border = "none"
	})
end)
run_if("statusline", function()
	require("core.statusline")
end)
run_if("colorscheme", function()
	require("core.colorscheme").setup()
end)
run_if("usql", function()
	require("core.integrations.usql")
end)
require('core.dashboard').setup()

-- Load optional post_init.lua file
pcall(require, "post_init")
