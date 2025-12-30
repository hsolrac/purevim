-- Main configuration Neovim
-- Author: Carlos

_G.start_time = vim.loop.hrtime()

package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua"

-- Load optional early_init.lua file
pcall(require, "early_init")

-- Feature toggles (users can set these in early_init.lua)
local features = vim.g.purevim_features or {}

-- Helper to conditionally run modules
local function run_if_feat_enabled(feature, fn)
	local conf = features[feature]
	if conf == false then
		return
	end
	fn(conf) -- pass feature configuration if available
end

-- Core modules
require("core.options")
require("core.keymaps")
require("core.integrations.git").setup()

-- Optional modules
run_if_feat_enabled("lsp", function()
	require("core.lsp").setup()
end)

run_if_feat_enabled("autocmd", function()
	require("core.autocmd")
end)

run_if_feat_enabled("treesitter", function()
	require("core.treesitter")
end)

run_if_feat_enabled("search", function()
	require("core.search")
end)

run_if_feat_enabled("lazygit", function()
	require("core.integrations.lazygit")
end)

run_if_feat_enabled("fzf", function(opts)
	opts = opts or {}
	require("core.integrations.fzf").setup(opts)
end)

run_if_feat_enabled("statusline", function()
	require("core.statusline")
end)

run_if_feat_enabled("colorscheme", function()
	require("core.colorscheme").setup()
end)

run_if_feat_enabled("usql", function()
	require("core.integrations.usql")
end)

run_if_feat_enabled("dashboard", function()
	require("core.dashboard").setup()
end)

-- Load optional post_init.lua file
pcall(require, "post_init")
