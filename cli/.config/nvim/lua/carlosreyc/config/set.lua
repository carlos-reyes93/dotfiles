-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrw = 1

vim.g.have_nerd_font = true

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
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes:1'
vim.opt.scrolloff = 8
vim.opt.showcmd = true

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
-- vim.opt.undofile = true
vim.opt.clipboard = 'unnamed'

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

-- Don't show the mode
vim.opt.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.undofile = true

vim.o.updatetime = 250
vim.o.timeoutlen = 500

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.confirm = true

vim.inccommand = 'split'

-- Don't show the mode
-- No automatic comment insertion
vim.cmd [[autocmd FileType * set formatoptions-=ro]]
