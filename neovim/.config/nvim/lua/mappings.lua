local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-n>"
    elseif check_back_space() then
        return t "<Tab>"
    else
        return vim.fn['compe#complete']()
    end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    else
        return t "<S-Tab>"
    end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})


vim.cmd [[
" telescope
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" git
nnoremap <leader>gc <cmd>Telescope git_commits<cr>
nnoremap <leader>gb <cmd>Telescope git_branches<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>
nnoremap <leader>gp <cmd>Telescope git_bcommits<cr>
]]

-- vim.api.nvim_set_keymap('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>l', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>t', [[<cmd>lua require('telescope.builtin').tags()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>o', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>gc', [[<cmd>lua require('telescope.builtin').git_commits()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>gb', [[<cmd>lua require('telescope.builtin').git_branches()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>gs', [[<cmd>lua require('telescope.builtin').git_status()<cr>]], { noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>gp', [[<cmd>lua require('telescope.builtin').git_bcommits()<cr>]], { noremap = true, silent = true})


vim.cmd [[
" so much more convenient
map <space> <leader>

" nvim-compe
"inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))
"inoremap <silent><expr> <C-e>     compe#close('<C-e>')
"inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
"inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })


" barbar
" Move to previous/next
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
nnoremap <silent>    <A->> :BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <A-1> :BufferGoto 1<CR>
nnoremap <silent>    <A-2> :BufferGoto 2<CR>
nnoremap <silent>    <A-3> :BufferGoto 3<CR>
nnoremap <silent>    <A-4> :BufferGoto 4<CR>
nnoremap <silent>    <A-5> :BufferGoto 5<CR>
nnoremap <silent>    <A-6> :BufferGoto 6<CR>
nnoremap <silent>    <A-7> :BufferGoto 7<CR>
nnoremap <silent>    <A-8> :BufferGoto 8<CR>
nnoremap <silent>    <A-9> :BufferLast<CR>
" Close buffer
nnoremap <silent>    <A-c> :BufferClose<CR>
" Wipeout buffer
"                          :BufferWipeout<CR>
" Close commands
"                          :BufferCloseAllButCurrent<CR>
"                          :BufferCloseBuffersLeft<CR>
"                          :BufferCloseBuffersRight<CR>
" Magic buffer-picking mode
nnoremap <silent> <leader>bb :BufferPick<CR>
" nnoremap <silent> <leader>bd :BufferClose<CR>

" mess with my window layout :^)
" list
"nnoremap <leader>bl :ls:<CR>
" edit
"nnoremap <leader>be :b<space>
" command
"nnoremap <leader>bb :ls<CR>:b
" last used buffer
"nnoremap <leader>bt :b#<CR>
"nnoremap <leader>bt :echoerr('⟨leader⟩bt is concidered harmful. Use <Ctrl-^> or <Ctrl-6> instead!')<CR>
" delete current buffer
nnoremap <leader>bd :bdelete<CR>

" fzf
" nnoremap <leader>ff :Files<CR>
" nnoremap <leader>fb :Buffers<CR>
" nnoremap <leader>fl :Lines<CR>
" nnoremap <leader>fa :Ag<CR>
" nnoremap <leader>fh :Helptags<CR>
" nnoremap <leader>fc :Colors<CR>
" nnoremap <leader>ft :Tags<CR>

" langclient
" nnoremap <leader>sa   :call LanguageClient#textDocument_codeAction()<CR>
" nnoremap <leader>sm	:call LanguageClient_contextMenu()<CR>
" nnoremap <F5>         :call LanguageClient_contextMenu()<CR>
" nnoremap <silent>Y    :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent>gd   :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent><F2> :call LanguageClient#textDocument_rename()<CR>


" vimux run last command
map <leader>cl :VimuxRunLastCommand<CR>
" Prompt for a command to run map
map <Leader>cc :VimuxPromptCommand<CR>

" edit configs
noremap <leader>cb :e ~/.bashrc<CR>
noremap <leader>ct :e ~/.tmux.conf<CR>
noremap <leader>cs :e ~/repos/st/config.h<CR>
noremap <leader>cd :e ~/repos/dwm/config.h<CR>
noremap <leader>cv :next $MYVIMRC ~/.config/nvim/lua/*.lua<CR>
noremap <leader>cx :e ~/.config/xrdb/<CR>
" reload vim config
noremap <leader>cr :so $MYVIMRC<CR>

" packer
nnoremap <leader>cpi :PackerInstall<CR>
nnoremap <leader>cpc :PackerClean<CR>
nnoremap <leader>cpu :PackerUpdate<CR>

" text tabulirize
noremap <leader>tt :Tabularize<space>/
" text align
noremap <leader>ta :EasyAlign<CR>

" enter inserts seletion, C-CR otherwise text is literaly inserted
"inoremap <expr> <C-CR>  pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" select with tab
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-g>u\<S-Tab>"

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

" nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
" nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
" nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
" nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
" nnoremap <silent> <C-w>o :TmuxNavigatePrevious<cr>

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
