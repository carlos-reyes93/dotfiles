-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrw = 1

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.o.mouse = 'a'
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes:1'
vim.opt.scrolloff = 6
vim.opt.showcmd = true

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
-- vim.opt.undofile = true
vim.opt.clipboard = 'unnamedplus'

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

-- Don't show the mode
vim.opt.showmode = false

vim.o.undofile = true

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.confirm = true

vim.inccommand = 'split'

-- Don't show the mode
-- No automatic comment insertion
vim.cmd [[autocmd FileType * set formatoptions-=ro]]
-- [[ Fold ]]
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = 'indent'

-- Auto scroll at EOF
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('ScrollOffEOF', {}),
  callback = function()
    local win_h = vim.api.nvim_win_get_height(0)
    local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
    local dist = vim.fn.line '$' - vim.fn.line '.'
    local rem = vim.fn.line 'w$' - vim.fn.line 'w0' + 1
    if dist < off and win_h - rem + dist < off then
      vim.cmd 'normal! zz'
    end
  end,
})
