local o = vim.o
local g = vim.g
local cmd = vim.cmd

require('plugins')

require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,              -- false will disable the whole extension
        -- disable = { "c", "rust" },  -- list of language that will be disabled
  },
}

require('nvim-autopairs').setup()
require('surround').setup{}
require('gitsigns').setup()
require('todo-comments').setup()
require('which-key').setup({
    plugins = {
        spelling = { enabled = true }
    }
})

require('lsp')
require('mappings')
require('visual')

o.cindent = true
o.wrap = false
o.breakindent = true
o.expandtab = true  -- no ta🅱️ s
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.shiftround = true -- round indent to shiftwidth

-- Search Settings
o.inccommand = 'split' -- show substitutions live
o.incsearch = true
o.gdefault = true -- assume the 'g' in s/../../g
o.ignorecase = true
o.smartcase = true -- all lower search is case insensitive

o.spelllang= 'el,en'

o.shortmess = o.shortmess .. 'c'

-- Backup and swap
o.backup = true
vim.opt.backupdir:remove('.')
vim.opt.undodir:remove('.')
o.undofile = true
o.swapfile = false

-- Misc Settings
vim.opt.clipboard:prepend {"unnamedplus"}

o.splitbelow = true
o.splitright = true
o.autochdir = true  -- automatically change directory
o.hidden = true  -- Required for operations modifying multiple buffers like rename. with langclient
o.mouse='a'  -- enable mouse for a(ll) modes
o.lazyredraw = true
o.modeline = true
o.keymap = 'greek_utf-8'
o.iminsert = 0  -- default to english

 -- Assume .h files are c headers instead of cpp
g.c_syntax_for_h = true

o.complete = '.,w,b,i,u,t,'
o.completeopt = "menu,longest,noinsert,noselect"

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
    autocmd BufWritePost plugins.lua nested source plugins.lua
    autocmd BufWritePost lsp.lua nested source lsp.lua
    autocmd BufWritePost mappings.lua nested source mappings.lua
    autocmd BufWritePost visual.lua nested source visual.lua
    autocmd BufWritePost *.tmux,*.tmux.conf silent !tmux source-file ~/.tmux.conf
    autocmd BufWritePost *.xdefaults silent !reload_xrdb
    autocmd BufWritePost ~/.bashrc silent !source ~/.bashrc "seems like it does nothing lol
    autocmd BufWritePost *.tex,*.latex silent !xelatex %
augroup end
]]

