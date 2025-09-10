local M = {}

-- Catppuccin Mocha palette (simplified)
local colors = {
	base = "#1e1e2e",
	mantle = "#181825",
	crust = "#11111b",
	text = "#cdd6f4",
	subtext1 = "#bac2de",
	subtext0 = "#a6adc8",
	surface1 = "#313244",
	surface0 = "#292c3c",
	lavender = "#b4befe",
	blue = "#89b4fa",
	sapphire = "#74c7ec",
	sky = "#89dceb",
	teal = "#94e2d5",
	green = "#a6e3a1",
	yellow = "#f9e2af",
	peach = "#fab387",
	maroon = "#eba0ac",
	red = "#f38ba8",
	mauve = "#cba6f7",
	pink = "#f5c2e7",
	flame = "#f2cdcd",
	rosewater = "#f5e0dc",
}

function M.setup()
	-- set background
	vim.o.background = "dark"

	-- basic highlights
	vim.api.nvim_set_hl(0, "Normal", { fg = colors.text, bg = colors.base })
	vim.api.nvim_set_hl(0, "Comment", { fg = colors.subtext0, italic = true })
	vim.api.nvim_set_hl(0, "Constant", { fg = colors.peach })
	vim.api.nvim_set_hl(0, "Identifier", { fg = colors.lavender })
	vim.api.nvim_set_hl(0, "Function", { fg = colors.blue })
	vim.api.nvim_set_hl(0, "Statement", { fg = colors.mauve })
	vim.api.nvim_set_hl(0, "Type", { fg = colors.yellow })
	vim.api.nvim_set_hl(0, "Special", { fg = colors.peach })
	vim.api.nvim_set_hl(0, "Error", { fg = colors.red, bold = true })
	vim.api.nvim_set_hl(0, "Todo", { fg = colors.peach, bold = true })

	vim.api.nvim_set_hl(0, "StatusLine", { fg = colors.subtext0, bg = colors.surface0 })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = colors.subtext0, bg = colors.surface1 })
	vim.api.nvim_set_hl(0, "LineNr", { fg = colors.subtext0, bg = colors.base })

	vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.surface0 })

	vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.surface0, bg = none })
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.surface0, bg = none })

	-- floating windows
	vim.api.nvim_set_hl(0, "NormalFloat", { fg = colors.text, bg = none })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.surface1, bg = none })

	-- popup menus (completion, telescope, etc.)
	vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.text, bg = colors.surface0 })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = colors.base, bg = colors.lavender })
end

return M
