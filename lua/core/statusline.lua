-- Cache git branch per buffer
local git_cache = {}

local function git_branch()
  local buf = vim.api.nvim_get_current_buf()
  -- use cached value if available
  if git_cache[buf] then
    return git_cache[buf]
  end

  local file_dir = vim.fn.expand("%:p:h")
  local branch = vim.fn.systemlist("git -C " .. file_dir .. " rev-parse --abbrev-ref HEAD")[1]
  if branch and branch ~= "" and branch ~= "HEAD" then
    if #branch > 25 then
      branch = branch:sub(1, 25) .. "…"
    end
    git_cache[buf] = " " .. branch
    return git_cache[buf]
  end
  git_cache[buf] = nil
  return nil
end

local function short_filename()
  local fullpath = vim.fn.expand("%:p")
  if fullpath == "" then return "" end

  local filename = vim.fn.fnamemodify(fullpath, ":t")
  local dirname  = vim.fn.fnamemodify(fullpath, ":h:t")

  return dirname .. "/" .. filename
end


-- Clear cache when buffer is left or git branch might change
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  callback = function()
    git_cache = {}
  end,
})

local function statusline()
  local parts = { " ", short_filename() , "%y", "%m" }
  local right = {}
  local branch = git_branch()
  if branch then
    table.insert(right, branch)
  end
  table.insert(right, "Ln %l, Col %c")
  table.insert(right, "[%p%%] ")
  return table.concat(parts, " ") .. " %= " .. table.concat(right, " | ")
end

vim.opt.laststatus = 3
vim.opt.statusline = "%!v:lua.statusline()"
_G.statusline = statusline

