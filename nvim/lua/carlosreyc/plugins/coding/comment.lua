return {
  -- {
  --
  --   'numToStr/Comment.nvim',
  --
  --   config = function()
  --     require('Comment').setup {
  --       pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  --     }
  --   end,
  -- },
  -- {
  --   'JoosepAlviste/nvim-ts-context-commentstring',
  --
  --   config = function()
  --     require('ts_context_commentstring').setup {
  --       enable_autocmd = false,
  --     }
  --   end,
  -- },
  {
    'numToStr/Comment.nvim',
    dependencies = {
      { 'JoosepAlviste/nvim-ts-context-commentstring', opts = {} },
    },
    config = function()
      local comment = require 'Comment'
      -- local api = require 'Comment.api'
      comment.setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        mappings = {
          basic = true,
          extra = false,
        },
      }
      -- vim.keymap.del('n', 'gcc')
      -- vim.keymap.set('n', 'gc', require('Comment.api').toggle.linewise.current)

      -- Remap <C-/> in normal, visual, and insert modes

      -- vim.keymap.set('n', '<C-_>', api.toggle.linewise.current)
      -- vim.keymap.set('n', '<C-/>', api.toggle.linewise.current, {})
      -- vim.keymap.set('v', '<C-/>', 'gc', {})
      -- vim.keymap.set('i', '<C-/>', api.toggle.linewise.current, { noremap = true, silent = true })
    end,
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  'NMAC427/guess-indent.nvim',
}
