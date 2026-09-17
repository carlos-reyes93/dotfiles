--@type vim.lsp.Config
return {
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			checkOnSave = false,
			diagnostics = { enable = false },
			inlayHints = {
				chainingHints = { enable = true },
				closureReturnTypeHints = { enable = "always" },
				parameterHints = { enable = true },
				typeHints = { enable = true },
			},
		},
	},
}
