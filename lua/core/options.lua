local opt = vim.opt
local g = vim.g

g.mapleader = ' '
g.maplocalleader = ' '

opt.number = true
opt.signcolumn = 'yes'
opt.termguicolors = true
opt.showcmd = true
opt.conceallevel = 0

opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.undofile = true

opt.splitright = true
opt.splitbelow = true

opt.completeopt = 'menu,menuone,noselect'

opt.lazyredraw = true
opt.hidden = true
