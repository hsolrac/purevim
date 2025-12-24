local M = {}

local themes = {}

themes.gruvbox = {
	palette = {
		bg0 = "#1d2021",
		bg1 = "#3c3836",
		bg2 = "#504945",
		bg3 = "#665c54",
		bg4 = "#7c6f64",
		fg0 = "#fbf1c7",
		fg1 = "#ebdbb2",
		fg2 = "#d5c4a1",
		fg3 = "#bdae93",
		fg4 = "#a89984",
		gray = "#928374",
		red = "#fb4934",
		green = "#b8bb26",
		yellow = "#fabd2f",
		blue = "#83a598",
		purple = "#d3869b",
		aqua = "#8ec07c",
		orange = "#fe8019",
		none = "NONE",
	},
	setup = function(c)
		vim.g.colors_name = "purevim-gruvbox"
		local function hl(group, options)
			vim.api.nvim_set_hl(0, group, options)
		end

		hl("Normal", { fg = c.fg1, bg = c.bg0 })
		hl("CursorLine", { bg = c.bg1 })
		hl("LineNr", { fg = c.bg4, bg = c.none })
		hl("CursorLineNr", { fg = c.yellow, bg = c.bg1 })
		hl("StatusLine", { fg = c.bg2, bg = c.fg1, reverse = true })
		hl("StatusLineNC", { fg = c.bg1, bg = c.fg4, reverse = true })
		hl("VertSplit", { fg = c.bg3, bg = c.none })
		hl("WinSeparator", { fg = c.bg3, bg = c.none })
		hl("Pmenu", { fg = c.fg1, bg = c.bg2 })
		hl("PmenuSel", { fg = c.bg2, bg = c.blue, bold = true })
		hl("Search", { fg = c.yellow, bg = c.bg0, reverse = true })
		hl("Visual", { bg = c.bg3, reverse = false })
		hl("MatchParen", { bg = c.bg3, bold = true })
		hl("Comment", { fg = c.gray, italic = true })
		hl("Constant", { fg = c.purple })
		hl("String", { fg = c.green, italic = false })
		hl("Identifier", { fg = c.blue })
		hl("Function", { fg = c.green, bold = true })
		hl("Statement", { fg = c.red })
		hl("Conditional", { fg = c.red })
		hl("Repeat", { fg = c.red })
		hl("Operator", { fg = c.fg1 })
		hl("Type", { fg = c.yellow })
		hl("Keyword", { fg = c.red })
		hl("PreProc", { fg = c.aqua })
		hl("Special", { fg = c.orange })
		hl("Error", { fg = c.red, bold = true, reverse = true })
		hl("Todo", { fg = c.fg0, bg = c.bg0, bold = true, italic = true })
		hl("DiagnosticError", { fg = c.red })
		hl("DiagnosticWarn", { fg = c.yellow })
		hl("DiagnosticInfo", { fg = c.blue })
		hl("DiagnosticHint", { fg = c.aqua })

		local ts_links = {
			["@variable"] = "Normal",
			["@function"] = "Function",
			["@keyword"] = "Statement",
			["@string"] = "String",
			["@type"] = "Type",
			["@constant"] = "Constant",
			["@comment"] = "Comment",
			["@operator"] = "Operator",
		}
		for link, target in pairs(ts_links) do
			vim.api.nvim_set_hl(0, link, { link = target })
		end
	end,
}

themes.catppuccin = {
	palette = {
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
		none = "NONE",
	},
	setup = function(c)
		vim.g.colors_name = "purevim-catppuccin"
		vim.api.nvim_set_hl(0, "Normal", { fg = c.text, bg = c.base })
		vim.api.nvim_set_hl(0, "Comment", { fg = c.subtext0, italic = true })
		vim.api.nvim_set_hl(0, "Constant", { fg = c.peach })
		vim.api.nvim_set_hl(0, "Identifier", { fg = c.lavender })
		vim.api.nvim_set_hl(0, "Function", { fg = c.blue })
		vim.api.nvim_set_hl(0, "Statement", { fg = c.mauve })
		vim.api.nvim_set_hl(0, "Type", { fg = c.yellow })
		vim.api.nvim_set_hl(0, "Special", { fg = c.peach })
		vim.api.nvim_set_hl(0, "Error", { fg = c.red, bold = true })
		vim.api.nvim_set_hl(0, "Todo", { fg = c.peach, bold = true })
		vim.api.nvim_set_hl(0, "StatusLine", { fg = c.subtext0, bg = c.surface0 })
		vim.api.nvim_set_hl(0, "StatusLineNC", { fg = c.subtext0, bg = c.surface1 })
		vim.api.nvim_set_hl(0, "LineNr", { fg = c.subtext0, bg = c.base })
		vim.api.nvim_set_hl(0, "CursorLine", { bg = c.surface0 })
		vim.api.nvim_set_hl(0, "VertSplit", { fg = c.surface0, bg = c.none })
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = c.surface0, bg = c.none })
		vim.api.nvim_set_hl(0, "NormalFloat", { fg = c.text, bg = c.none })
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = c.surface1, bg = c.none })
		vim.api.nvim_set_hl(0, "Pmenu", { fg = c.text, bg = c.surface0 })
		vim.api.nvim_set_hl(0, "PmenuSel", { fg = c.base, bg = c.lavender })
	end,
}

function M.setup()
	local theme_name = vim.g.purevim_colorscheme or "catppuccin"
	local theme = themes[theme_name]

	if not theme then
		theme = themes.catppuccin
	end

	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	vim.o.background = "dark"

	theme.setup(theme.palette)
end

return M
