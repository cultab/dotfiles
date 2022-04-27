local M = {}

LastCommand = nil

function InputCommand()
    vim.ui.input({ prompt = "cmd: ", completion = 'shellcmd' }, function (command)
        if command then
            LastCommand = command
            vim.cmd(":1TermExec cmd='" .. command .. "'")
        end
    end)
end

function RunLastCommand()
    if LastCommand then
        vim.cmd(":1TermExec cmd='" .. LastCommand .. "'")
    else
        vim.notify("No command to repeat", nil, { title = "mappings.lua" })
    end
end

-- load my mapping DSL
require "user.map"

map "<leader><space>" { "<cmd>ToggleTerm 2<CR>", "Toggle terminal" }

map "<leader>c" { nil, "Run command / Open config" }
    map "<leader>cl" { RunLastCommand, "Re-run last command" }
    map "<leader>cc" { InputCommand, "Run command" }
    map "<leader>cb" { "<cmd>e ~/.config/bspwm/bspwmrc<CR>", "bspwm" }
    map "<leader>cp" { "<cmd>e ~/.config/polybar/config<CR>", "polybar" }
    map "<leader>cs" { "<cmd>e ~/.config/sxhkd/sxhkdrc<CR>", "simple x keybind daemon" }
    map "<leader>cd" { "<cmd>e ~/repos/dwm/config.h<CR>", "dwm" }
    map "<leader>cv" { "<cmd>lua Open_config()<CR>", "neovim" }
    map "<leader>cx" { "<cmd>e ~/.config/xrdb/<CR>", "xresources" }
    map "<leader>ct" { "<cmd>n ~/.config/themr/*.yaml<CR>", "themr" }
    map "<leader>cz" { "<cmd>n ~/.zshrc<CR>", "zshrc" }

map "<leader>t" { nil, "Text operations" }
    map "<leader>tt" { "<cmd>Tabularize<space>/", "Tabularize" }
    map "<leader>ta" { "<cmd>EasyAlign<CR>", "Agign"      }
    map "<leader>te" { "<cmd>Telescope emoji<CR>",  "Search for emoji" }

map "<leader>b"  { "<cmd>BufferPick<CR>",         "Pick buffer" }
map "<leader>f"  { require"telescope.builtin".find_files, "Find files"  }
map "<leader>g"  { require"telescope.builtin".live_grep,  "Live grep"   }
map "<leader>h" { require"telescope.builtin".help_tags,  "Search help tags" }

map "<leader>G" { nil, "Git" }
    map "<leader>Gc" { require"telescope.builtin.git".git_branches,  "Commits"  }
    map "<leader>Gb" { require"telescope.builtin.git".git_branches, "Branches" }
    map "<leader>Gs" { require"telescope.builtin.git".git_status,   "Status"   }
    map "<leader>Gp" { require"telescope.builtin.git".git_bcommits, "Commits in buffer" }
    map "<leader>GS" { require"gitsigns".stage_hunk, "Stage hunk" }
    map "<leader>Gr" { require"gitsigns".reset_hunk , "Reset hunk" }
    map "<leader>GR" { require"gitsigns".reset_buffer , "Reset buffer" }
    map "<leader>Gp" { require"gitsigns".preview_hunk , "Preview hunk" }
    map "<leader>GB" { require"gitsigns".blame_line , "Blame line" }

map:register()

function M.set_lsp_mappings()
    map 'gD'        { vim.lsp.buf.declaration, "Goto declaration [LSP]" }
    map 'gd'        { vim.lsp.buf.definition, "Goto definition [LSP]" }
    map 'gi'        { vim.lsp.buf.implementation, "Goto implementation [LSP]" }
    map 'U'         { vim.lsp.buf.hover, "Hover documentation [LSP]" }
    map '<C-k>'     { vim.lsp.buf.signature_help, "Open signature help [LSP]" }
    map '<leader>q' { "<cmd>vim.diagnostic.setloclist<CR>", "Open loclist [LSP]" }
    map '<leader>=' { vim.lsp.buf.formatting, "Format buffer [LSP]" }
    map '<leader>=' { vim.lsp.buf.range_formatting, "Format range", 'v' }
    map '<leader>D' { vim.lsp.buf.type_definition, "Show type definition [LSP]" }
    map '<leader>r' { vim.lsp.buf.rename, "Rename symbol [LSP]" }
    map '<leader>R' { vim.lsp.buf.references, "Show references [LSP]" }
    map '<leader>e' { function() vim.diagnostic.open_float(nil, { focusable = false }) end, "Show line diagnostics [LSP]" }
    map '<A-CR>'    { vim.lsp.buf.code_action, "Code Action [LSP]" }
    map '['         { vim.diagnostic.goto_prev, "Previous diagnostic [LSP]" }
    map ']'         { vim.diagnostic.goto_next, "Next diagnostic [LSP]" }
    map:register()
end

vim.cmd [[
    nnoremap <M-h> <cmd>lua require("tmux").move_left()<cr>,
    nnoremap <M-j> <cmd>lua require("tmux").move_bottom()<cr>,
    nnoremap <M-k> <cmd>lua require("tmux").move_top()<cr>,
    nnoremap <M-l> <cmd>lua require("tmux").move_right()<cr>,
]]


vim.cmd[[
" barbar
" Move to previous/next
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-[> :BufferMovePrevious<CR>
nnoremap <silent>    <A-]> :BufferMoveNext<CR>
" Close buffer
nnoremap <silent>    <A-c> :BufferClose<CR>
" Wipeout buffer
"                          :BufferWipeout<CR>
" Close commands
"                          :BufferCloseAllButCurrent<CR>
"                          :BufferCloseBuffersLeft<CR>
"                          :BufferCloseBuffersRight<CR>
]]

-- from the good ol' init.vim
-- it's mostly vim-compatible
-- so it stays here for now
vim.cmd [[
" so much more convenient
map <space> <leader>

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz

" cut line
nnoremap S i<CR><ESC>k$

" split prefix, C-w is taken by tmux
" nnoremap <C-a> <C-w>

" This unsets the last search pattern register by hitting ESC
nnoremap <silent><ESC> :nohlsearch<CR>

" easier navigation in normal / visual / operator pending mode
noremap H ^
noremap L $

" Change text without putting the text into register
noremap c "_c
noremap C "_C
vnoremap p "_dP
" capital P does use the register
vnoremap P p
noremap cc "_cc
noremap x "_x

" I never use Ex mode, so re-run macros instead
nnoremap Q @@

" sane movement through wrapping lines
noremap j gj
noremap k gk

" sometimes I get off the shift key too slowly, ~~maybe don't do it then?~~,
" HA abbr to the rescue
cabbr Q q
cabbr W w
cabbr Wq wq
cabbr WQ wq
cabbr Wa wa
cabbr WA wa
]]

return M
