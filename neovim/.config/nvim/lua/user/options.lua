local opt = vim.opt
local o   = vim.o

-- tabsize
opt.expandtab = true  -- no tabs
opt.tabstop = 4      -- tab size is 4
opt.softtabstop = 4  -- expanded size is 4
opt.shiftwidth = 4   -- indent size is 4
opt.shiftround = true -- round indent to shiftwidth

-- wrap
opt.wrap = true
opt.breakindent = true
opt.showbreak = string.rep(" ", 3) -- make it so that long lines wrap smartly, ~TJDevries
opt.linebreak = true
opt.breakindent = true

-- indent
opt.cindent = true
opt.autoindent = true

-- Search Settings
opt.inccommand = 'nosplit' -- show substitutions live, now without splitting!
opt.incsearch = true
opt.gdefault = true -- assume the 'g' in s/../../g
opt.ignorecase = true
opt.smartcase = true -- all lower search is case insensitive

-- don't give |ins-completion-menu| messages. For example,
-- "-- XXX completion (YYY)", "match 1 of 2", "The only match",
o.shortmess = o.shortmess .. 'c'

-- Backup and swap
opt.backup = true
opt.backupdir:remove('.')
opt.undodir:remove('.')
opt.undofile = true
opt.swapfile = false

-- Misc Settings
opt.clipboard:prepend {"unnamedplus"}
opt.updatetime = 50 -- ms

opt.splitbelow = true
opt.splitright = true

opt.autochdir = true -- automatically change directory
opt.hidden = true  -- Required for operations modifying multiple buffers like rename. with langclient
opt.mouse='a'  -- enable mouse for a(ll) modes
opt.lazyredraw = true
opt.modeline = true

opt.spelllang= 'el,en'
opt.keymap = 'greek_utf-8'
opt.iminsert = 0  -- default to english

 -- Assume .h files are c headers instead of cpp
vim.g.c_syntax_for_h = true

opt.complete = '.,w,b,i,u,t,'
opt.completeopt = "menu,menuone,noselect" -- ,noinsert,longest"
opt.formatoptions = opt.formatoptions
    - "a"
    - "t"
    + "q"
    - "o"
    + "r"
    + "n"
    + "j"
    - "2"

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


