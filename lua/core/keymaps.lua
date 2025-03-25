local map = vim.keymap.set
local search = require('core.search')

map('n', '<leader>ev', ':vsplit ~/.config/purevim<cr>')


map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

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
map('n', '<Esc>', ':noh<CR>') -- clean search

map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- LSP
map('n', 'gd', vim.lsp.buf.definition)
map('n', 'K', vim.lsp.buf.hover)
map('n', '<leader>rn', vim.lsp.buf.rename)
map('n', '<leader>ca', vim.lsp.buf.code_action)
