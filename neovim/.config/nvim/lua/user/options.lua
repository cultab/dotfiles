vim.o.cindent = true
vim.o.wrap = false
vim.o.breakindent = true
vim.o.expandtab = true  -- no tabs
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.shiftround = true -- round indent to shiftwidth

-- Search Settings
vim.o.inccommand = 'nosplit' -- show substitutions live, now without splitting!
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
vim.o.autochdir = true -- automatically change directory
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

function OpenConfig()
    vim.cmd [[:cd ~/.config/nvim]]
    vim.cmd[[:e $MYVIMRC]]
    -- vim.cmd[[:next $MYVIMRC ~/.config/nvim/lua/user/*.lua]]
end

vim.cmd [[
augroup termBinds
    autocmd!
    autocmd TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    autocmd TermOpen * nnoremap <buffer> <Esc> :ToggleTermToggleAll<CR>
    autocmd FileType fzf tunmap <buffer> <Esc>
augroup end
]]

vim.cmd [[
augroup TwoSpaces
    autocmd!
    autocmd FileType yaml,norg setlocal ts=2 sts=2 sw=2 expandtab
augroup end
]]

vim.cmd [[
augroup autoSpellcheck
    autocmd!
    autocmd FileType norg,rmd,text setlocal spell
augroup end
]]

vim.cmd [[
augroup autoFileTypes
    autocmd!
    autocmd BufEnter */srcpkgs/*/template :setfiletype sh
augroup end
]]

vim.cmd [[
augroup autoSauce
    autocmd!
    autocmd User         PackerCompileDone lua vim.notify("Packer Compiled Successfully!")
    autocmd BufWritePost */nvim/init.lua nested source $MYVIMRC
    autocmd BufWritePost */nvim/lua/user/*.lua nested source <afile> | lua vim.notify("Sourced!")
    autocmd BufWritePost */nvim/lua/user/plugins.lua nested PackerCompile
    " autocmd BufWritePost plugins.lua :PackerCompile
    " autocmd BufWritePost plugins.lua nested source %

    autocmd BufWritePost .tmux.conf silent !tmux display-message 'Sourced .tmux.conf\!' ';' source-file ~/.tmux.conf
    autocmd BufWritePost *.xdefaults silent !reload_xrdb
    autocmd BufWritePost bspwmrc silent !~/.config/bspwm/bspwmrc
    autocmd BufWritePost *.tex,*.latex silent !xelatex %
augroup end
]]


