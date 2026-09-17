---@type vim.lsp.Config
return {
  cmd = { "tsc", "--lsp", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  single_file_support = true,
}
