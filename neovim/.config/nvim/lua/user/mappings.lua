local M = {}
-- load my mapping DSL
require "user.map"


map "<leader><space>" { "<cmd>ToggleTerm 1<CR>", "Toggle terminal" }

map "<leader>c" { nil, "Run command" }
    map "<leader>cc" { require"user.command".run_command,   "Run command" }
    map "<leader>cl" { require"user.command".run_last_command, "Repeat last command" }
    map "<leader>cr" { require"user.command".run_current_file, "Run current file" }

map "<leader>o" { require'user.configs'.config_picker, "Open config picker" }

map "<leader>t" { nil, "Text operations" , 'nv'}
    map "<leader>tt" { ":Tabularize<space>/",       "Tabularize", 'v' }
    map "<leader>ta" { "<cmd>EasyAlign<CR>",        "Easy Align", 'v' }
    map "<leader>te" { "<cmld>Telescope emoji<CR>",  "Emoji Picker" }


-- HACK: figure out why this breaks with `map`
vim.cmd [[
vnoremap <leader>c :Norm<space>
]]
map "<leader>l" { require"lsp_lines".toggle,             "Toggle diagnostics"}
map "<leader>b" { "<cmd>BufferPick<CR>",                 "Pick buffer" }
map "<leader>f" { require"telescope.builtin".find_files, "Find files"  }
map "<leader>/" { require"telescope.builtin".live_grep,  "Live grep"   }
map "<leader>h" { require"telescope.builtin".help_tags,  "Search help tags" }

map "<leader>g" { nil, "Git" }
    map "<leader>gc" { require"telescope.builtin".git_branches, "Commits"  }
    map "<leader>gb" { require"telescope.builtin".git_branches, "Branches" }
    map "<leader>gs" { require"telescope.builtin".git_status,   "Status"   }
    map "<leader>gp" { require"telescope.builtin".git_bcommits, "Commits in buffer" }
    map "<leader>gS" { require"gitsigns".stage_hunk,            "Stage hunk" }
    map "<leader>gr" { require"gitsigns".reset_hunk ,           "Reset hunk" }
    map "<leader>gR" { require"gitsigns".reset_buffer ,         "Reset buffer" }
    map "<leader>gp" { require"gitsigns".preview_hunk ,         "Preview hunk" }
    map "<leader>gB" { require"gitsigns".blame_line ,           "Blame line" }
    map "<leader>gg" { require"neogit".open,                    "Open Neogit" }

map "<leader>n" { require'dashboard'.new_file, "New file" }

map "<M-h>" { require"tmux".move_left   }
map "<M-j>" { require"tmux".move_bottom }
map "<M-k>" { require"tmux".move_top    }
map "<M-l>" { require"tmux".move_right  }

map:register()

function M.set_lsp_mappings()
    map 'gD'        { vim.lsp.buf.declaration,      "Goto declaration [LSP]"     }
    map 'gd'        { vim.lsp.buf.definition,       "Goto definition [LSP]"      }
    map 'gi'        { vim.lsp.buf.implementation,   "Goto implementation [LSP]"  }
    map 'K'         { vim.lsp.buf.hover,            "Hover documentation [LSP]"  }
    map '<C-k>'     { vim.lsp.buf.signature_help,   "Open signature help [LSP]"  }
    map '<leader>D' { vim.lsp.buf.type_definition,  "Show type definition [LSP]" }
    map '<leader>R' { vim.lsp.buf.references,       "Show references [LSP]"      }
    map '<leader>r' { vim.lsp.buf.rename,           "Rename symbol [LSP]"        }
    map '<A-CR>'    { vim.lsp.buf.code_action,      "Code Action [LSP]"          }
    map '['         { vim.diagnostic.goto_prev,     "Previous diagnostic [LSP]"  }
    map ']'         { vim.diagnostic.goto_next,     "Next diagnostic [LSP]"      }
    map '<leader>=' { function() vim.lsp.buf.format {async = true} end,                     "Format buffer [LSP]"         }
    map '<leader>=' { function() vim.lsp.buf.range_format {async = true} end,               "Format range [LSP]" ,    'v' }
    map '<leader>e' { function() vim.diagnostic.open_float(nil, { focusable = false }) end, "Show line diagnostics [LSP]" }
    map '<leader>q' { require"telescope.builtin".loclist, " Open loclist [LSP] " }
    map:register()
end

function M.set_welcome_mappings() vim.cmd[[
        nnoremap <buffer> q :q<CR>
]] end



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
