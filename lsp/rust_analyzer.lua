---@type vim.lsp.Config
return {
    cmd = { "rust_analyzer" },
    root_markers = { "Cargo.toml", ".git" },
    filetypes = { "rs" },
}
