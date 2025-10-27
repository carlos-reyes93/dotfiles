local set = vim.keymap.set

set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })
set('n', '<leader>swc', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[S]earch [Word] under [C]ursor' })

set('n', '<Esc>', '<cmd>nohlsearch<CR>')

set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

set('n', '<leader>w', '<cmd>w<CR>', { desc = '[W]rite file' })
set('x', 'p', '"_dP')

set('n', '<leader>-', '<cmd>split<cr>', { desc = '[-] Split Horizontal' })
set('n', '<leader>|', '<cmd>vsplit<cr>', { desc = '[|] Split Vertical' })
set('n', '<leader>\\', '<cmd>:call delete(swapname("."))<cr>', { desc = 'Delete current swapfile' })

set('n', '-', '<cmd>Oil<cr>', { desc = 'Open Parent Directory' })

set('n', '<leader>bd', '<cmd>bd<cr>', { desc = '[B]uffer [D]elete' })

-- " Navigate quickfix list
-- nnoremap <a-j> <cmd>cnext<cr>
-- nnoremap <a-k> <cmd>cprev<cr>
-- nnoremap <a-J> <cmd>cnfile<cr>
-- nnoremap <a-K> <cmd>cNfile<cr>

set('n', '<a-j>', '<cmd>cnext<cr>', { desc = 'Next Quickfix list item' })
set('n', '<a-k>', '<cmd>cprev<cr>', { desc = 'Next Quickfix list item' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlights text when yanking',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
