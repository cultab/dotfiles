local M = {}

local function map(mode, key, action, opts)
    if opts == nil then
        opts = {}
    end

    local default_opts = { noremap=true, silent=false }
    opts = vim.tbl_deep_extend("force", default_opts, opts)

    vim.api.nvim_set_keymap(mode, key, action, opts)
end

function M.set_lsp_mappings()
    map('n', 'gD',         '<Cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n', 'gd',         '<Cmd>lua vim.lsp.buf.definition()<CR>')
    map('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>')
    map('n', 'U',          '<Cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('n', '<leader>q',  '<cmd>lua vim.diagnostic.setloclist()<CR>') map("n", "<leader>=",  "<cmd>lua vim.lsp.buf.formatting()<CR>")
    map("v", "<leader>=",  "<cmd>lua vim.lsp.buf.range_formatting()<CR>")
    map('n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    map('n', '<leader>r',  '<cmd>lua vim.lsp.buf.rename()<CR>')
    map('n', '<leader>R',  '<cmd>lua vim.lsp.buf.references()<CR>')
    map('n', '<leader>e',  '<cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>')
    map('n', '<A-CR>',     '<Cmd>lua vim.lsp.buf.code_action()<CR>')
    map('n', '[d',         '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    map('n', ']d',         '<cmd>lua vim.diagnostic.goto_next()<CR>')
end


-- " vimux run last command
-- map <leader>cl :VimuxRunLastCommand<CR>
-- " Prompt for a command to run map
-- map <Leader>cc :VimuxPromptCommand<CR>


LastCommand = nil

function RunCommand(command)
    if command then
        LastCommand = command
        vim.cmd(":1TermExec cmd='" .. command .. "'")
    end
end

function RunLastCommand()
    vim.cmd(":1TermExec cmd='" .. LastCommand .. "'")
end

vim.cmd [[
    nnoremap <silent> <leader>cc :lua vim.ui.input({ prompt = "cmd: ", completion = 'shellcmd' }, RunCommand)<CR>
    nnoremap <silent> <leader>cl :lua RunLastCommand()<CR>
    nnoremap <silent> <leader>ct :ToggleTerm<CR>
    nnoremap <silent> <leader><space> :ToggleTermToggleAll<CR>
]]


vim.cmd [[
    nnoremap <M-h> <cmd>lua require("tmux").move_left()<cr>,
    nnoremap <M-j> <cmd>lua require("tmux").move_bottom()<cr>,
    nnoremap <M-k> <cmd>lua require("tmux").move_top()<cr>,
    nnoremap <M-l> <cmd>lua require("tmux").move_right()<cr>,
]]

vim.cmd [[
    " telescope
    " Find files using Telescope command-line sugar.
    nnoremap <leader>ff <cmd>Telescope find_files<cr>
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    " git
    "nnoremap <leader>gc <cmd>Telescope git_commits<cr>
    "nnoremap <leader>gb <cmd>Telescope git_branches<cr>
    "nnoremap <leader>gs <cmd>Telescope git_status<cr>
    "nnoremap <leader>gp <cmd>Telescope git_bcommits<cr>
    "nnoremap <leader>gd :DiffviewOpen<CR>
    "misc
    nnoremap <leader>fe <cmd>Telescope emoji<CR>
]]

-- from the good ol' init.vim
vim.cmd [[
" so much more convenient
map <space> <leader>

" barbar
" Move to previous/next
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-[> :BufferMovePrevious<CR>
nnoremap <silent>    <A-]> :BufferMoveNext<CR>
" Goto buffer in position...
" nnoremap <silent>    <A-1> :BufferGoto 1<CR>
" nnoremap <silent>    <A-2> :BufferGoto 2<CR>
" nnoremap <silent>    <A-3> :BufferGoto 3<CR>
" nnoremap <silent>    <A-4> :BufferGoto 4<CR>
" nnoremap <silent>    <A-5> :BufferGoto 5<CR>
" nnoremap <silent>    <A-6> :BufferGoto 6<CR>
" nnoremap <silent>    <A-7> :BufferGoto 7<CR>
" nnoremap <silent>    <A-8> :BufferGoto 8<CR>
" nnoremap <silent>    <A-9> :BufferLast<CR>
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

" edit configs
noremap <leader>cb :e ~/.config/bspwm/bspwmrc<CR>
noremap <leader>cp :e ~/.config/polybar/config<CR>
noremap <leader>cs :e ~/.config/sxhkd/sxhkdrc<CR>
noremap <leader>ct :e ~/.tmux.conf<CR>
noremap <leader>cd :e ~/repos/dwm/config.h<CR>
noremap <leader>cv :lua Open_config()<CR>
noremap <leader>cx :e ~/.config/xrdb/<CR>
noremap <leader>ct :n ~/.config/themr/*.yaml<CR>

" text tabulirize
noremap <leader>tt :Tabularize<space>/
" text align
noremap <leader>ta :EasyAlign<CR>

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
