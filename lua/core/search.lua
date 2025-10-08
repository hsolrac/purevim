-- lua/core/search.lua
--
-- File finding and grepping helpers (fd, rg, fzf, quickfix)
--
-- SOURCE: https://jkrl.me/vim/2025/09/03/nvim-fuzzy-grep.html

-- Load cfilter (shipped with Neovim)
vim.cmd.packadd("cfilter")

-- Settings
vim.opt.wildmenu = true
vim.opt.wildmode = { "noselect:longest:lastused", "full" }
vim.opt.wildoptions = "pum"
vim.opt.path:append("**")
vim.opt.grepprg = "rg --vimgrep --hidden -g '!.git/*'"

vim.opt.wildignorecase = true
vim.opt.wildignore:append({ "*/node_modules/*", "*/.git/*" })

-- Functions
local M = {}

function M.fuzzy_filter_qf(...)
	local args = { ... }
	local query = table.concat(args, " ")
	vim.fn.setqflist(vim.fn.matchfuzzy(vim.fn.getqflist(), query, { key = "text" }))
end

function M.fuzzy_filter_grep(query, path)
	path = path or "."
	vim.cmd("grep! '" .. query .. "' " .. path)
	local sort_query = query:gsub("%.%*", ""):gsub("\\%(.)", "%1")
	M.fuzzy_filter_qf(sort_query)
	vim.cmd("cfirst")
	vim.cmd("copen")
end



function M.fd_set_quickfix(...)
	local args = { ... }
	local fdresults = vim.fn.systemlist("fd -t f --hidden " .. table.concat(args, " "))
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("Fd error: " .. fdresults[1])
		return
	end
	local qf = {}
	for _, val in ipairs(fdresults) do
		table.insert(qf, { filename = val, lnum = 1, text = val })
	end
	vim.fn.setqflist(qf)
	vim.cmd("copen")
end

-- Commands
vim.api.nvim_create_user_command("Findqf", function(opts)
	M.fd_set_quickfix(unpack(opts.fargs))
end, { nargs = "+", complete = "file_in_path" })

vim.api.nvim_create_user_command("Cfuzzy", function(opts)
	M.fuzzy_filter_qf(unpack(opts.fargs))
end, { nargs = 1 })

vim.api.nvim_create_user_command("Zgrep", function(opts)
	M.fuzzy_filter_grep(unpack(opts.fargs))
end, { nargs = "+", complete = "file_in_path" })





return M
