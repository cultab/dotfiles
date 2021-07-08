local o = vim.o
local g = vim.g
local cmd = vim.cmd

require('plugins')
require('lsp')
require('mappings')
require('visual')

require('nvim_comment').setup()
require('nvim-autopairs').setup()
require('surround').setup{}

require('nvim-treesitter.configs').setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages{{{
    highlight = { enable = true  },
    incremental_selection = { enable = true },
    textobjects = {
        enable = true,
        lsp_interop = {
            enable = true,
            peek_definition_code = {
                ["df"] = "@function.outer",
                ["dF"] = "@class.outer",
            },
        },
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
            }
        }
    },
    indent = { enable = true } --}}}
}

require('gitsigns').setup{
    keymaps = {--{{{
        -- Default keymap options
        noremap = true,
        buffer = true,

        ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
        ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

        ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
        ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>'
    }--}}}
}

require('which-key').setup{
    plugins = {--{{{
        spelling = { enabled = true }
    }--}}}
}

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
o.completeopt = "menuone,noselect,noinsert,longest"

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


