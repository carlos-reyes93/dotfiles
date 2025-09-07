local extension_path = vim.fn.stdpath 'data' .. '/mason/packages/sonarlint-language-server/extension'
return {
  'iamkarasik/sonarqube.nvim',
  config = function()
    require('sonarqube').setup {
      lsp = {
        cmd = {
          vim.fn.exepath 'java',
          '-jar',
          extension_path .. '/server/sonarlint-ls.jar',
          '-stdio',
          '-analyzers',
          extension_path .. '/analyzers/sonarhtml.jar',
          extension_path .. '/analyzers/sonarjs.jar',
        },
      },
    }
  end,
}
