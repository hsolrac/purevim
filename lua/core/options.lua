local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

opt.winborder = "single"

opt.fillchars = { eob = " " }

opt.updatetime = 1000
opt.cursorline = true
opt.number = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showcmd = true
opt.conceallevel = 0
opt.wrap = false

opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true

opt.splitright = true
opt.splitbelow = true

opt.completeopt = "menu,menuone,noselect"

opt.lazyredraw = true
opt.hidden = true
-- see `:h completeopt`
opt.completeopt = "menuone,noselect,popup,fuzzy"

vim.opt.shortmess:append("I")

vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE
]])


local ok, extui = pcall(require, "vim._extui")
if ok then
  extui.enable({
    enable = true,
  })
end
