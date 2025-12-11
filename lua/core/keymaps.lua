local map = vim.keymap.set
local search = require("core.search")
local bufopts = { noremap = true, silent = true }
local git = require("core.integrations.git")

-- Quality of life maps

map("n", "<C-s>", ":w<CR>")
map("n", "<Esc>", ":noh<CR>", { silent = true })

map("n", "<leader>ee", ":Explore <CR>")

map("n", "<leader>ev", function()
	vim.cmd("vsplit " .. vim.env.MYVIMRC)
end, { desc = "Open init.lua in vertical split" })

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<C-q>", ":bd<CR>")

map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

map({ "n", "v" }, "<C-d>", "<C-d>zz", { silent = true })
map({ "n", "v" }, "<C-u>", "<C-u>zz", { silent = true })

map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

map("n", "<leader>q", ":copen <CR>")
map("n", "]q", ":cnext<CR>", { silent = true })
map("n", "[q", ":cprev<CR>", { silent = true })

map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)

map("n", "<leader>bx", ":bd<CR>", { desc = "Close buffer", silent = true })
map("n", "<leader>bX", ":bufdo bd<CR>", { desc = "Close all buffers", silent = true })

map("n", "<leader>tn", ":tabnew<CR>", { desc = "Toggle [t]abs" })
map("n", "<leader>tt", function()
	if vim.o.showtabline == 2 then
		vim.o.showtabline = 0
	else
		vim.o.showtabline = 2
	end
end, { desc = "Toggle [t]abs" })
map("n", "]t", ":tabnext<CR>", { desc = "Next tab", silent = true })
map("n", "[t", ":tabprevious<CR>", { desc = "Previous tab", silent = true })

map("n", "<leader>ti", function()
	local virtual_text = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not virtual_text })
end, { desc = "Toggle [i]nline diagnostics" })

map("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle [d]iagnostics" })

map("n", "<leader>tl", ":set number! norelativenumber<CR>", { desc = "Toggle [l]ine number" })
map("n", "<leader>tr", ":set relativenumber!<CR>", { desc = "Toggle [r]elative line number" })

-- git 
map("n", "<leader>gb", git.toggle_blame, { desc = "Toggle inline git blame" })
map("n", "]c", git.next_hunk, { desc = "Go to next git hunk" })
map("n", "[c", git.prev_hunk, { desc = "Go to previous git hunk" })
map("n", "<leader>gL", ":PureLazyGit<CR>")
map("n", "<leader>gs", ":PureGitStatus<CR>")

map("n", "<leader>gd", function()
  local file = vim.fn.expand("%")
  if file == "" then
    vim.notify("No file name for current buffer", vim.log.levels.WARN)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)

  local diff = vim.fn.systemlist({ "git", "diff", file })
  if vim.v.shell_error ~= 0 then
    vim.notify("git diff failed or repo not found", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, diff)

  vim.bo[buf].filetype = "diff"
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
end, { desc = "Git diff current file in disposable buffer" })

map("n", "<leader>gD", function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)

  local diff = vim.fn.systemlist({ "git", "diff" })
  if vim.v.shell_error ~= 0 then
    vim.notify("git diff failed or repo not found", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, diff)

  vim.bo[buf].filetype = "diff"
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
end, { desc = "Git diff entire repo in disposable buffer" })

map("n", "<leader>ga", function()
  local file = vim.fn.expand("%")
  if file == "" then
    vim.notify("No file name for current buffer", vim.log.levels.WARN)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)

  local annotate = vim.fn.systemlist({ "git", "annotate", file })
  if vim.v.shell_error ~= 0 then
    vim.notify("git annotate failed or repo not found", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, annotate)
  vim.bo[buf].filetype = "git"
  vim.bo[buf].modifiable = true
  vim.bo[buf].buflisted = false

  vim.cmd("topleft vsplit")
  vim.api.nvim_win_set_buf(0, buf)
end, { desc = "Git annotate current file" })

-- Search (find and grep)
map("n", "<leader>ff", ":PureFzfProject<CR>")
map("n", "<leader>fi", ":find ")
map("n", "<leader>vv", ":vert sf ")
map("n", "<leader>b", ":b ")
map("n", "<leader>fq", ":Findqf ")
-- map("n", "<leader>fg", ":silent! grep ''<Left>", { desc = "Grep manually" })
-- map("n", "<leader>fG", ":silent! grep <C-R><C-W><CR>", { desc = "Grep word under cursor" })
map("n", "<leader>fg", ":PureRgProject<CR>", { desc = "Grep manually" })
map("n", "<leader>fG", ":PureRgProject <C-R><C-W><CR>", { desc = "Grep word under cursor" })
map("n", "<leader>z", ":Zgrep ")
map("n", "<leader>Z", ":Fzfgrep ")
map("n", "<leader>cf", ":Cfilter ")
map("n", "<leader>cz", ":Cfuzzy ")
map("c", "<C-Space>", ".*", { noremap = true })
map("c", "<A-9>", "\\(", { noremap = true })
map("c", "<A-0>", "\\)", { noremap = true })
map("c", "<A-Space>", "\\<space>", { noremap = true })

-- Automatically open quickfixlist after grep
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "[^l]*",
	callback = function()
		vim.cmd("copen")
	end,
})

-- LSP
map("n", "gd", vim.lsp.buf.definition, bufopts)
map("n", "K", vim.lsp.buf.hover, bufopts)
map("n", "gi", vim.lsp.buf.implementation, bufopts)
map("n", "gr", vim.lsp.buf.references, bufopts)
map("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
map("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
map("n", "<leader>mp", vim.lsp.buf.format, bufopts)
map("n", "<leader>d", vim.diagnostic.open_float, bufopts)
map("n", "<leader>co", function()
	vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
end, bufopts)

-- map <c-space> to activate completion
map("i", "<c-space>", function()
	vim.lsp.completion.get()
end)
-- select with Enter
map("i", "<cr>", "pumvisible() ? '<c-y>' : '<cr>'", { expr = true })
-- navigation sugestions with Tab(next) and Shift + Tab(prev)
map("i", "<Tab>", "pumvisible() ? '<C-n>' : '<Tab>'", { expr = true, noremap = true, silent = true })
map("i", "<S-Tab>", "pumvisible() ? '<C-p>' : '<S-Tab>'", { expr = true, noremap = true, silent = true })
