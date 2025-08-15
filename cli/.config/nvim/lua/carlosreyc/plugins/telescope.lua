return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  tag = '0.1.8',
  dependecies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',

      cond = function()
        return vim.fn.executabl 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  module = 'telescope',

  config = function()
    require('telescope').setup {

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'

    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', ':Telescope find_files hidden=true <CR>', { desc = '[S]earch [H]idden' })
    vim.keymap.set('n', '<leader>sv', builtin.git_files, { desc = '[S]earch [V]ersion Control' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim Files' })

    vim.keymap.set('n', '<leader>swg', function()
      local word = vim.fn.expand '<cword>'
      builtin.grep_string { search = word }
    end, { desc = '[S]earch by [W]ord ([G]rep)' })
    vim.keymap.set('n', '<leader>sWg', function()
      local word = vim.fn.expand '<cWORD>'
      builtin.grep_string { search = word }
    end, { desc = '[S]earch by [W]ord ([G]rep)' })
  end,
}
