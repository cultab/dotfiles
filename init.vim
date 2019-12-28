"Basic vim settings 
set nocompatible
set relativenumber
set number
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set cindent
set smarttab
set autoindent
set modeline
set splitbelow
set splitright
set nowrap
filetype plugin indent on
set autochdir
syntax on
set showcmd
set noshowmode
" Assume .h files are c headers instead of cpp
let g:c_syntax_for_h = 1
" Required for operations modifying multiple buffers like rename. with langclient
set hidden
" Always draw the signcolumn.
set signcolumn=yes
" Use 'normal' clipboard by default
set clipboard+=unnamedplus
" enable mouse for a(ll) modes
set mouse=a
set termguicolors

call plug#begin("~/.config/nvim/plugged")

"Autocomplete
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/echodoc.vim'
Plug 'ervandew/supertab'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'jiangmiao/auto-pairs'

" (Optional from langclient) Multi-entry selection UI.
Plug 'junegunn/fzf'

" Syntax highlighting
Plug 'vmchale/ion-vim'
Plug 'sheerun/vim-polyglot'

" Visual
 Plug 'vim-airline/vim-airline'
"Plug 'itchyny/lightline.vim'
"Plug 'mengelbrecht/lightline-bufferline'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'lilydjwg/colorizer'
" Colorschemes
Plug 'vim-airline/vim-airline-themes'
Plug 'elitetester29/plastic.vim'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'

" Misc
Plug 'christoomey/vim-tmux-navigator'
Plug 'https://github.com/vim-scripts/CycleColor'

" Disabled 
"Plug 'captbaritone/better-indent-support-for-php-with-html'
"Plug 'dag/vim-fish'
"Plug 'https://github.com/vim-scripts/dbext.vim'
"Plug 'borissov/vim-mysql-suggestions'
"Plug 'https://github.com/Shougo/neco-syntax'
"Plug 'zxqfl/tabnine-vim'
"Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

call plug#end()

" Start deoplete,echodoc automatically
let g:deoplete#enable_at_startup = 1
let g:echodoc_enable_at_startup = 1
" floating window
let g:echodoc#type = 'floating'
" underneath lightline
" let g:echodoc#type = 'signature'

" Change the truncate width of completions.
call deoplete#custom#source('_', 'max_abbr_width', 0)

let g:LanguageClient_serverCommands = {
    \ 'python': ['~/.local/bin/pyls'],
    \ 'c'     : ['/bin/clangd'],
    \ 'cpp'  : ['/bin/clangd']}

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> U :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>

" Colorscheme Options
colorscheme onedark

" Lightline options
let g:lightline = {
      \ 'colorscheme': 'one',}
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline#bufferline#min_buffer_count = 1
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#unicode_symbols = 1

" Airline options
let g:airline_theme='deus'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" airline status line
"let g:airline_section_z = '%p% %% %#__accent_bold#%{g:airline_symbols.linenr}%#__restore__#'

" mySQL completion
let g:database_host = "localhost"
let g:database_password = "rootP"
let g:database_database = "warehouse"
let g:database_user = "root"

" SuperTab 
" Scroll downwards with tab
let g:SuperTabDefaultCompletionType = "<c-n>"
"let g:SuperTabDefaultCompletionType = "context"

" enter inserts seletion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" complete from highlight files
set omnifunc=syntaxcomplete#Complete
" autocomplete don't insert
set completeopt=longest,menuone,noinsert
",preview

" Easy window navigation
"map <C-h> <C-w>h
"map <C-j> <C-w>j
"map <C-k> <C-w>k
"map <C-l> <C-w>l

" reset cursor shape, does not work
autocmd VimLeave * set guicursor=i-ci-ve:ver25

" This unsets the last search pattern register by hitting ESC 
nnoremap <ESC> :nohlsearch<CR>

" Move text
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Space as leader, still no idea what leader is
map <Space> <Leader>

" tabs
nnoremap <A-h> :tabprevious<CR>
nnoremap <A-l> :tabnext<CR>

" CycleColors, it's bound in the plugin but incase I forget
nnoremap <f4> :CycleColorNext<cr>
nnoremap <f3> :CycleColorPrev<cr>

" Go into normal mode with Esc from terminal mode
tnoremap <Esc> <C-\><C-n>

" Output the current syntax group
nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>
