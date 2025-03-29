local ok, lsp = pcall(require, "core.lsp")
if not ok then
  vim.notify("Error load core.lsp: " .. lsp, vim.log.levels.ERROR)
  return
end

-- autoformart
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

local border = {
  {"🭽", "FloatBorder"},
  {"▔", "FloatBorder"},
  {"🭾", "FloatBorder"},
  {"▕", "FloatBorder"},
  {"🭿", "FloatBorder"},
  {"▁", "FloatBorder"},
  {"🭼", "FloatBorder"},
  {"▏", "FloatBorder"},
}

vim.diagnostic.config({
  virtual_text = false,
  float = {
    border = border,
    header = '',
    prefix = function(diagnostic, i, total)
      local icons = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
      }
      return icons[diagnostic.severity.name]
    end,
  }
})

vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
  callback = function()
    vim.diagnostic.open_float(nil, {
      scope = "cursor",
      focusable = false,
      close_events = {
        "CursorMoved",
        "CursorMovedI",
        "BufLeave",
        "InsertCharPre",
        "WinLeave"
      }
    })
  end
})

vim.api.nvim_create_autocmd({"BufEnter"}, {
  pattern = {"*"},
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "" then  -- Só executa para buffers válidos
      lsp.setup()
    end
  end
})
