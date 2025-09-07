return {
  'A7lavinraj/assistant.nvim',
  lazy = false,
  keys = {
    { '<leader>a', '<cmd>Assistant<cr>', desc = 'Assistant.nvim' },
  },
  opts = {
    mappings = {},
    commands = {
      python = {
        extension = 'py',
        template = nil,
        compile = nil,
        execute = {
          main = 'python3',
          args = { '$FILENAME_WITH_EXTENSION' },
        },
      },
      c = {
        extension = 'c',
        template = nil,
        compile = {
          main = 'gcc',
          args = { '$FILENAME_WITH_EXTENSION', '-o', '$FILENAME_WITHOUT_EXTENSION' },
        },
        execute = {
          main = './$FILENAME_WITHOUT_EXTENSION',
          args = nil,
        },
      },
    },
    ui = {
      border = 'single',
      diff_mode = false,
      title_components_separator = '',
    },
    core = {
      process_budget = 5000,
      port = 10043,
      filename_generator = nil,
    },
  },
}
