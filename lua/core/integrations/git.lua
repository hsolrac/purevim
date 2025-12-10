-- Git related functions

local M = {}
local hunks = {}

M.blame_enabled = false

local function is_git_repo()
  local path = vim.fn.expand("%:p:h")
  local git_dir = vim.fn.finddir(".git", path .. ";")
  return git_dir ~= ""
end

-- Signs
local function setup_signs()
  vim.fn.sign_define("GitSignsAdd", { text = "│", texthl = "GitSignsAdd" })
  vim.fn.sign_define("GitSignsChange", { text = "│", texthl = "GitSignsChange" })
  vim.fn.sign_define("GitSignsDelete", { text = "│", texthl = "GitSignsDelete" })
end

local function update_signs()
  if not is_git_repo() then
    return
  end

  hunks = {} -- Clear hunks on each update

  local buffer_nr = vim.api.nvim_get_current_buf()
  local filepath = vim.fn.expand("%:p")

  if filepath == "" then
    return
  end

  vim.fn.sign_unplace("GitSigns", { buffer = buffer_nr })

  local diff_output = vim.fn.systemlist({
    "git", "diff", "--unified=0", "HEAD", "--", filepath
  })

  if vim.v.shell_error ~= 0 then
    return
  end


	local i = 1
	local line_nr = nil

	while i <= #diff_output do
		local raw = diff_output[i]
		local line = raw:gsub("\r?$", "")

		local hunk_start = line:match("^@@.*%+([0-9]+)")
		if hunk_start then
			line_nr = tonumber(hunk_start) - 1
			table.insert(hunks, tonumber(hunk_start))
			i = i + 1
		elseif not line_nr then
			i = i + 1
		else
			local first = line:sub(1,1)
			if first == " " then
				line_nr = line_nr + 1
				i = i + 1

			elseif first == "+" then
				line_nr = line_nr + 1
				vim.fn.sign_place(0, "GitSigns", "GitSignsAdd", buffer_nr, { lnum = line_nr })
				i = i + 1

			elseif first == "-" then
				local next_raw = diff_output[i + 1] or ""
				if next_raw:sub(1,1) == "+" then
					line_nr = line_nr + 1
					vim.fn.sign_place(0, "GitSigns", "GitSignsChange", buffer_nr, { lnum = line_nr })
					i = i + 2 
				else
					local del_lnum = math.max(1, line_nr + 1)
					vim.fn.sign_place(0, "GitSigns", "GitSignsDelete", buffer_nr, { lnum = del_lnum })
					i = i + 1
				end

			else
				i = i + 1
			end
		end
	end

end

-- Blame helpers
local function clear_blame(buf)
  local ns = vim.api.nvim_create_namespace('pure_blame_ns')
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

local function show_blame_for_cursor()
  if not M.blame_enabled then return end
  if not is_git_repo() then return end

  local buf = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local file_path = vim.fn.expand("%:p")

  if file_path == "" then return end

  clear_blame(buf)

  local output = vim.fn.systemlist({
    "git", "blame", "--porcelain",
    "-L", (row + 1) .. "," .. (row + 1),
    file_path
  })

  if #output == 0 then return end

  local info = {}
  for _, line in ipairs(output) do
    local key, value = line:match("^([^%s]+)%s(.*)")
    if key and value then info[key] = value end
  end


	local uncommitted = false

	if info["author"] == "Not Committed Yet" or info["author"] == nil then
		uncommitted = true
	end

	local formatted_date = ""
	if info["author-time"] then
		local ts = tonumber(info["author-time"])
		if ts then
			formatted_date = os.date("%Y-%m-%d %H:%M:%S", ts)
		end
	end

	local text
	if uncommitted then
		text = "Uncommitted changes"
	else
		text = string.format(
			"%s | %s | %s",
			info["summary"] or "",
			info["author"] or "",
			formatted_date
		)
	end


  local ns = vim.api.nvim_create_namespace('pure_blame_ns')

  vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
    virt_text = { { text, "Comment" } },
    virt_text_pos = "eol",
  })
end

function M.toggle_blame()
  M.blame_enabled = not M.blame_enabled

  local buf = vim.api.nvim_get_current_buf()
  clear_blame(buf)

  if M.blame_enabled then
    show_blame_for_cursor()
    vim.notify("Blame enabled")
  else
    vim.notify("Blame disabled")
  end
end

function M.setup()
  setup_signs()

  local git_augroup = vim.api.nvim_create_augroup("GitSigns", { clear = true })

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    group = git_augroup,
    pattern = "*",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()

      if vim.bo[buf].buftype ~= "" then return end
      if vim.fn.expand("%:p") == "" then return end

      local ft = vim.bo[buf].filetype
      if ft == "alpha" or ft == "dashboard" or ft == "neo-tree"
        or ft == "oil" or ft == "netrw" or ft == "NvimTree"
        or ft == "TelescopePrompt" then
        return
      end

      vim.defer_fn(update_signs, 200)
    end,
  })

  -- Cursor blame update
  local blame_au = vim.api.nvim_create_augroup("PureBlameGroup", { clear = true })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = blame_au,
    callback = show_blame_for_cursor
  })
 end


function M.next_hunk()
  if #hunks == 0 then return end
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local next_hunk_line = nil

  for _, hunk_line in ipairs(hunks) do
    if hunk_line > current_line then
      next_hunk_line = hunk_line
      break
    end
  end

  if not next_hunk_line then
    next_hunk_line = hunks[1]
  end

  vim.api.nvim_win_set_cursor(0, { next_hunk_line, 0 })
  vim.cmd("normal! zz")
end

function M.prev_hunk()
  if #hunks == 0 then return end
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local prev_hunk_line = nil

  for i = #hunks, 1, -1 do
    local hunk_line = hunks[i]
    if hunk_line < current_line then
      prev_hunk_line = hunk_line
      break
    end
  end

  if not prev_hunk_line then
    prev_hunk_line = hunks[#hunks]
  end

  vim.api.nvim_win_set_cursor(0, { prev_hunk_line, 0 })
  vim.cmd("normal! zz")
end

return M
