---@type vim.lsp.Config
return {
	cmd = { "crates-lsp" },
	filetypes = { "toml" },
	root_markers = { "Cargo.toml", ".git" },
}
