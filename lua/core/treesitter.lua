vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevelstart = 99

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end
})
--    zc (fold)
--    zo (unfold)
--    zM (fold all)
--    zR (unfold all)
--    za – Toggles between folding and unfolding the code block at the current line.
