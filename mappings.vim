"Something to do with autocomplete window
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone

"SuperTab 
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCompletionContexts = ['MySQLCompleteSuperTabContext']

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"This unsets the last search pattern register by hitting ESC 
nnoremap <ESC> :noh<CR><CR>

"Move text
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

"Space as leader, still no idea what leader is
"map <Space> <Leader>

"tabs
nnoremap <A-h> :tabprevious<CR>
nnoremap <A-l> :tabnext<CR>

"CycleColors, it's bound in the plugin but incase I forget
nnoremap <f4> :CycleColorNext<cr>
nnoremap <f3> :CycleColorPrev<cr>

"Go into normal mode with Esc from terminal mode
tnoremap <Esc> <C-\><C-n>

" Output the current syntax group
nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
