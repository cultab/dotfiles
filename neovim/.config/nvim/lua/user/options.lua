-- tabsize
vim.opt.expandtab = true  -- no tabs
vim.opt.tabstop = 4      -- tab size is 4
vim.opt.softtabstop = 4  -- expanded size is 4
vim.opt.shiftwidth = 4   -- indent size is 4
vim.opt.shiftround = true -- round indent to shiftwidth

vim.opt.smartindent = true

-- wrap
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3) -- make it so that long lines wrap smartly, ~TJDevries
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Search Settings
vim.opt.inccommand = 'nosplit' -- show substitutions live, now without splitting!
vim.opt.gdefault = true -- assume the 'g' in s/../../g
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true -- all lower search is case insensitive

-- don't give |ins-completion-menu| messages. For example,
-- "-- XXX completion (YYY)", "match 1 of 2", "The only match",
vim.opt.shortmess:append('c')

-- Backup and swap
vim.opt.backup = true
vim.opt.backupdir:remove('.')
vim.opt.undodir:remove('.')
vim.opt.undofile = true
vim.opt.swapfile = false

-- Misc Settings
-- vim.opt.clipboard:prepend {"unnamedplus"}
-- vim.opt.updatetime = 50 -- ms

vim.opt.splitbelow = true
vim.opt.splitright = true
-- vim.opt.splitkeep = "screen" --  NOTE: wait for 0.9.0

vim.opt.autochdir = false -- automatically change directory
vim.opt.mouse='a'  -- enable mouse for a(ll) modes
vim.opt.lazyredraw = false
vim.opt.modeline = true

-- language
vim.opt.spelllang= 'el,en'
vim.opt.keymap = 'greek_utf-8'
vim.opt.iminsert = 0  -- default to english

vim.opt.virtualedit = 'block'

 -- Assume .h files are c headers instead of cpp
vim.g.c_syntax_for_h = true

vim.opt.complete = '.,w,b,i,u,t,'
vim.opt.completeopt = "menu,menuone,noselect" -- ,noinsert,longest"
vim.opt.formatoptions = vim.opt.formatoptions
    - "a"
    - "t"
    + "q"
    - "o"
    + "r"
    + "n"
    + "j"
    - "2"

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
    autocmd FileType norg,rmd,quarto,text setlocal spell wrap
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
    " autocmd BufWritePost *.tex,*.latex silent !xelatex %
augroup end
]]

--
