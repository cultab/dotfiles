vim.cmd[[let g:python3_host_prog="~/.pyenv/versions/nvim/bin/python"]]

require('plugins')
require('visual')
require("statusline")
require('lsp')
require('mappings')

vim.o.cindent = true
vim.o.wrap = false
vim.o.breakindent = true
vim.o.expandtab = true  -- no tabs
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.shiftround = true -- round indent to shiftwidth

-- Search Settings
vim.o.inccommand = 'split' -- show substitutions live
vim.o.incsearch = true
vim.o.gdefault = true -- assume the 'g' in s/../../g
vim.o.ignorecase = true
vim.o.smartcase = true -- all lower search is case insensitive

-- don't give |ins-completion-menu| messages. For example,
-- "-- XXX completion (YYY)", "match 1 of 2", "The only match",
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Backup and swap
vim.o.backup = true
vim.opt.backupdir:remove('.')
vim.opt.undodir:remove('.')
vim.o.undofile = true
vim.o.swapfile = false

-- Misc Settings
vim.opt.clipboard:prepend {"unnamedplus"}
vim.opt.updatetime = 50 -- ms

vim.o.splitbelow = true
vim.o.splitright = true
vim.o.autochdir = true  -- automatically change directory
vim.o.hidden = true  -- Required for operations modifying multiple buffers like rename. with langclient
vim.o.mouse='a'  -- enable mouse for a(ll) modes
vim.o.lazyredraw = true
vim.o.modeline = true
vim.o.spelllang= 'el,en'
vim.o.keymap = 'greek_utf-8'
vim.o.iminsert = 0  -- default to english

 -- Assume .h files are c headers instead of cpp
vim.g.c_syntax_for_h = true

vim.o.complete = '.,w,b,i,u,t,'
vim.o.completeopt = "menu,menuone,noselect" -- ,noinsert,longest"

function Open_config()
    vim.cmd[[:next $MYVIMRC ~/.config/nvim/lua/*.lua]]
    vim.cmd[[:cd ~/.config/nvim]]
end

vim.cmd [[
augroup termBinds
    autocmd!
    autocmd TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    autocmd FileType fzf tunmap <buffer> <Esc>
augroup end
]]

vim.cmd [[
augroup auto_sauce
    autocmd!
    autocmd BufWritePost init.lua nested source $MYVIMRC
    " autocmd BufWritePost plugins.lua :PackerCompile
    " autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    " autocmd BufWritePost plugins.lua nested source %
    autocmd BufWritePost lsp.lua nested source %
    autocmd BufWritePost mappings.lua nested source %
    autocmd BufWritePost visual.lua nested source %
    autocmd BufWritePost *.tmux,*.tmux.conf silent !tmux source-file ~/.tmux.conf
    autocmd BufWritePost *.xdefaults silent !reload_xrdb
    autocmd BufWritePost ~/.bashrc silent !source ~/.bashrc "seems like it does nothing lol
    autocmd BufWritePost *.tex,*.latex silent !xelatex %
augroup end
]]


