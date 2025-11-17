-- Git related functions

local M = {}

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

  local line_nr = 0
  for _, line in ipairs(diff_output) do
    if line:match("^@@") then
      line_nr = tonumber(line:match("%+([0-9]+)")) - 1
    elseif line:match("^[^-+@]") then
      line_nr = line_nr + 1
    elseif line:match("^%+") then
      vim.fn.sign_place(0, "GitSigns", "GitSignsAdd", buffer_nr, { lnum = line_nr + 1 })
      line_nr = line_nr + 1
    elseif line:match("^%-") then
      vim.fn.sign_place(0, "GitSigns", "GitSignsDelete", buffer_nr, { lnum = line_nr + 1 })
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

return M
