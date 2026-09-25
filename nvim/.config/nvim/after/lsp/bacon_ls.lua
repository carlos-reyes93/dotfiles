--@type vim.lsp.Config
return {
  settings = {
    bacon_ls = {
      backend = "cargo",
      cargo = {
        command = "clippy",
        checkOnSave = true,
        extraArgs = { "--workspace", "--all-targets" }
      },
    },
  },
}
