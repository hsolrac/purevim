-- Open lazygit in a floating terminal that auto-closes
function LazyGitFloating()
	-- Calculate floating window size
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Create a scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Open floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
	})

	-- Start lazygit in terminal
	vim.fn.termopen("lazygit", {
		on_exit = function()
			-- Close buffer and window when process exits
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end,
	})

	-- Enter insert mode automatically
	vim.cmd("startinsert")
end

-- Create a user command to call it
vim.api.nvim_create_user_command("PureLazyGit", LazyGitFloating, {})
