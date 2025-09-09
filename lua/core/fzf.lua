local M = {}

local function project_root()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if git_root and git_root ~= "" then
		return git_root
	else
		return vim.fn.getcwd()
	end
end

M.fzf_open = function()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
	})

	local root = project_root()

	local cmd = [[
    bash -c 'fzf --reverse --preview "bat --style=numbers --color=always --line-range=:50 {}" \
    --preview-window=right:60%:wrap --expect=enter'
  ]]

	-- remember previous window
	local prev_win = vim.api.nvim_get_current_win()

	vim.fn.termopen(cmd, {
		cwd = root,
		on_exit = function(_, exit_code, _)
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			local file = lines[2] -- fzf --expect=enter puts selection here

			-- close floating terminal first
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end

			if file and file ~= "" then
				-- switch back to previous window
				if vim.api.nvim_win_is_valid(prev_win) then
					vim.api.nvim_set_current_win(prev_win)
				end

				-- open the selected file
				vim.cmd("edit " .. vim.fn.fnameescape(root .. "/" .. file))
			end
		end,
	})

	vim.cmd("startinsert")
end

-- RG + FZF floating search, optional default query
-- Usage: require('core.fzf').rg_search("default term")
M.rg_search = function(default_query)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
	})

	local root = project_root()
	local prev_win = vim.api.nvim_get_current_win()

	-- escape default query for bash
	local query = default_query and default_query:gsub('"', '\\"') or ""

	local cmd = string.format(
		[[
    bash -c 'rg --column --line-number --no-heading --color=always "%s" | \
    fzf --ansi --reverse --preview "bat --style=numbers --color=always --highlight-line {2} {1}" \
    --delimiter : --preview-window=right:60%%:wrap --expect=enter'
  ]],
		query
	)

	vim.fn.termopen(cmd, {
		cwd = root,
		on_exit = function(_, exit_code, _)
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			local selection = lines[2] -- fzf --expect=enter

			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end

			if selection and selection ~= "" then
				-- expected format: file:line:col:match
				local file, line = selection:match("^(.-):(%d+):%d+:")
				if file and line then
					if vim.api.nvim_win_is_valid(prev_win) then
						vim.api.nvim_set_current_win(prev_win)
					end
					vim.cmd("edit " .. vim.fn.fnameescape(root .. "/" .. file))
					vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
				end
			end
		end,
	})

	vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("PureRgProject", function(opts)
	require("core.fzf").rg_search(opts.args)
end, { nargs = "?" })
vim.api.nvim_create_user_command("PureFzfProject", M.fzf_open, {})

return M
