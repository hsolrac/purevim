local map = vim.keymap.set
local search = require('core.search')
local bufopts = { noremap = true, silent = true }

map('n', '<leader>ev', ':vsplit ~/.config/purevim<cr>')

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')

map('n', '<C-l>', ':Exp<CR>')

map('n', '<C-Up>', ':resize +2<CR>')
map('n', '<C-Down>', ':resize -2<CR>')
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')

map('n', '<S-l>', ':bnext<CR>')
map('n', '<S-h>', ':bprevious<CR>')
map('n', '<C-q>', ':bd<CR>')

-- map('n', '<C-p>', search.find_files)
-- map('n', '<leader>fg', search.grep)

map('n', '<C-s>', ':w<CR>')
map('n', '<Esc>', ':noh<CR>')

map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- LSP
map("n", "gd", vim.lsp.buf.definition, bufopts)
map("n", "K", vim.lsp.buf.hover, bufopts)
map("n", "gi", vim.lsp.buf.implementation, bufopts)
map("n", "gr", vim.lsp.buf.references, bufopts)
map("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
map("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
map("n", "<leader>f", vim.lsp.buf.format, bufopts)
map("n", "[d", vim.diagnostic.goto_prev, bufopts)
map("n", "]d", vim.diagnostic.goto_next, bufopts)
map("n", "<leader>d", vim.diagnostic.open_float, bufopts)

-- map <c-space> to activate completion
map("i", "<c-space>", function() vim.lsp.completion.get() end)
-- select with Enter
map("i", "<cr>", "pumvisible() ? '<c-y>' : '<cr>'", { expr = true })
-- navigation sugestions with Tab(next) and Shift + Tab(prev)
map("i", "<Tab>", "pumvisible() ? '<C-n>' : '<Tab>'", { expr = true, noremap = true, silent = true })
map("i", "<S-Tab>", "pumvisible() ? '<C-p>' : '<S-Tab>'", { expr = true, noremap = true, silent = true })
