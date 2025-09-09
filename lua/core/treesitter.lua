-- Folding setup
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99

-- Start Tree-sitter parsing for every file type
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Highlight Tree-sitter captures using standard Vim groups
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.cmd([[
      highlight link @function Function
      highlight link @method Function
      highlight link @variable Variable
      highlight link @parameter Identifier
      highlight link @keyword Keyword
      highlight link @string String
      highlight link @type Type
      highlight link @comment Comment
      highlight link @constant Constant
      highlight link @number Number
      highlight link @boolean Boolean
      highlight link @operator Operator
      highlight link @property Identifier
      highlight link @field Identifier
      highlight link @punctuation Delimiter
    ]])
	end,
})

function PureCheckTreesitter()
	local parser = vim.treesitter.get_parser(0) -- current buffer
	if parser then
		print("Tree-sitter is running on parser: " .. parser:lang())
	else
		print("No Tree-sitter parser attached to this buffer")
	end
end

vim.api.nvim_create_user_command("PureCheckTreesitter", PureCheckTreesitter, {})
