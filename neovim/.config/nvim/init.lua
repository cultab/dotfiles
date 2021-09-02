O = vim.o
G = vim.g
cmd = vim.cmd

require('plugins')
require('lsp')
require('mappings')
require('visual')

O.cindent = true
O.wrap = false
O.breakindent = true
O.expandtab = true  -- no ta🅱️ s
O.tabstop = 4
O.softtabstop = 4
O.shiftwidth = 4
O.shiftround = true -- round indent to shiftwidth

-- Search Settings
O.inccommand = 'split' -- show substitutions live
O.incsearch = true
O.gdefault = true -- assume the 'g' in s/../../g
O.ignorecase = true
O.smartcase = true -- all lower search is case insensitive

O.spelllang= 'el,en'

O.shortmess = O.shortmess .. 'c'

-- Backup and swap
O.backup = true
vim.opt.backupdir:remove('.')
vim.opt.undodir:remove('.')
O.undofile = true
O.swapfile = false

-- Misc Settings
vim.opt.clipboard:prepend {"unnamedplus"}

O.splitbelow = true
O.splitright = true
O.autochdir = false  -- automatically change directory
O.hidden = true  -- Required for operations modifying multiple buffers like rename. with langclient
O.mouse='a'  -- enable mouse for a(ll) modes
O.lazyredraw = true
O.modeline = true
O.keymap = 'greek_utf-8'
O.iminsert = 0  -- default to english

 -- Assume .h files are c headers instead of cpp
G.c_syntax_for_h = true

O.complete = '.,w,b,i,u,t,'
O.completeopt = "menuone,noselect" -- ,noinsert,longest"

cmd [[
augroup termBinds
    autocmd!
    autocmd TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    autocmd FileType fzf tunmap <buffer> <Esc>
augroup end

augroup auto_formating
    autocmd!
    autocmd BufWritePre *.go,*.dart :call LanguageClient#textDocument_formatting_sync()
  " autocmd BufWritePre *.py :call LanguageClient#textDocument_formatting_sync()
augroup end

augroup auto_sauce
    autocmd!
    autocmd BufWritePost init.lua nested source $MYVIMRC
    autocmd BufWritePost plugins.lua :PackerCompile
    autocmd BufWritePost plugins.lua nested source %
    autocmd BufWritePost lsp.lua nested source %
    autocmd BufWritePost mappings.lua nested source %
    autocmd BufWritePost visual.lua nested source %
    autocmd BufWritePost *.tmux,*.tmux.conf silent !tmux source-file ~/.tmux.conf
    autocmd BufWritePost *.xdefaults silent !reload_xrdb
    autocmd BufWritePost ~/.bashrc silent !source ~/.bashrc "seems like it does nothing lol
    autocmd BufWritePost *.tex,*.latex silent !xelatex %
augroup end
]]


