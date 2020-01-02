"Basic Neovim Settings {{{

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
filetype plugin indent on
set autochdir

" Assume .h files are c headers instead of cpp
let g:c_syntax_for_h = 1

" Required for operations modifying multiple buffers like rename. with langclient
set hidden

" Use 'normal' clipboard by default
set clipboard+=unnamedplus

" enable mouse for a(ll) modes
set mouse=a

" push more characters through to the terminal per cycle
set ttyfast

" auto-update if changes are detected
set autoread

" assume the 'g' in s/../../g
set gdefault

" don't leave a mess
set backup
set backupdir=~/.config/nvim/backup
set noswapfile
set backupskip=/tmp/*
"}}}

" Installed Plugins {{{
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
Plug 'sheerun/vim-polyglot'

" Visual
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'lilydjwg/colorizer'

" Colorschemes
Plug 'cultab/plastic.vim'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'

" Misc
Plug 'christoomey/vim-tmux-navigator'
Plug 'https://github.com/vim-scripts/CycleColor'

" Disabled
"Plug 'neomake/neomake'
"Plug 'captbaritone/better-indent-support-for-php-with-html'

call plug#end()
"}}}

" Autocomplete & LanguageClient {{{
" complete from highlight files
set omnifunc=syntaxcomplete#Complete
" autocomplete don't insert
set completeopt=longest,menuone,noinsert
",preview

" SuperTab
let g:SuperTabDefaultCompletionType = "<c-n>"

" Start deoplete,echodoc automatically
let g:deoplete#enable_at_startup = 1
let g:echodoc_enable_at_startup = 1
" floating window
let g:echodoc#type = 'floating'

" Change the truncate width of completions.
call deoplete#custom#source('_', 'max_abbr_width', 0)

let g:LanguageClient_serverCommands = {
    \ 'python': ['~/.local/bin/pyls'],
    \ 'c'     : ['/bin/clangd'],
    \ 'cpp'   : ['/bin/clangd']
    \}

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> U :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" enter inserts seletion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"}}}

" Folds {{{

set foldmethod=marker
autocmd FileType c,h,java,cpp,hpp setlocal nofoldenable foldmethod=syntax foldnestmax=1 foldminlines=10

"}}}

" Visual Settings + Lightline settings and function {{{

" more colors ?
set termguicolors

" Always draw the signcolumn.
set signcolumn=yes

syntax on
set noshowmode
set showcmd
set breakindent
set wrap

" highlight current line
set cursorline


" Colorscheme Options
colorscheme onedark

" Lightline options

let g:lightline#bufferline#min_buffer_count = 1
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#unicode_symbols = 1

" TODO fix this json? thing
let g:lightline = { 'colorscheme' : 'one' }
let g:lightline.active = {
    \   'left': [ [ 'mode', 'paste' ],
    \           [ 'filename', 'modified', 'readonly' ] ],
    \   'right': [ [ 'wrn_cnt', 'err_cnt', 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'fileformat', 'fileencoding', 'filetype' ] ] }
let g:lightline.inactive = {
    \   'left': [ [ 'filename' ] ],
    \   'right': [ [ 'lineinfo' ],
    \            [ 'percent' ] ] }
let g:lightline.tabline = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component = { 'lineinfo': ' %3l:%-2v', 'asd' : 'asd'}
let g:lightline.component_type = {
    \   'buffers'  : 'tabsel',
    \   'readonly' : 'error',
    \   'err_cnt'  : 'error',
    \   'wrn_cnt'  : 'warning' }
let g:lightline.component_function = {
    \   'err_cnt'  : 'LightlineLspErrorCount',
    \   'wrn_cnt'  : 'LightlineLspWarningCount'}
let g:lightline.component_expand  = {
    \   'buffers'  : 'lightline#bufferline#buffers',
    \   'readonly' : 'LightlineReadonly',
    \   'err_cnt'  : 'LightlineLspErrorCount',
    \   'wrn_cnt'  : 'LightlineLspWarningCount'}
let g:lightline.separator    = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }

function! LightlineReadonly()
        return &readonly ? '' : ''
endfunction

" Lightline Functions {{{

" The following is practicaly stolen right out of
" airline's interface with LanguageClient

augroup LanguageClient_config
    autocmd!
    autocmd User LanguageClientDiagnosticsChanged call s:get_diagnostics()
augroup END

" Severity codes from the LSP spec
let s:severity_error = 1
let s:severity_warning = 2
let s:severity_info = 3
let s:severity_hint = 4

" gets filled on autocmd
let s:diagnostics = {  }

" calls LightlineLspGetTypeCount with type = error
function! LightlineLspErrorCount()
    let cnt = LightlineLspGetTypeCount(s:severity_error)
    return cnt == 0 ? '' : printf('✗:%d', cnt)
endfunction

" calls LightlineLspGetTypeCount with type = warning
function! LightlineLspWarningCount()
    let cnt = LightlineLspGetTypeCount(s:severity_warning)
    return cnt == 0 ? '' : printf('◆:%d', cnt)
endfunction

" counts keys with severity == type
function! LightlineLspGetTypeCount(type)
    let cnt = 0
    for d in get(s:diagnostics, expand('%:p'), [])
        if has_key(d, 'severity') && (d.severity == a:type)
            let cnt += 1
        endif
    endfor
    return cnt
endfunction

function! s:get_diagnostics()
    call LanguageClient#getState(function("s:record_diagnostics"))
endfunction

function! s:record_diagnostics(state)
    " The returned message might not have the 'result' key
    if has_key(a:state, 'result')
        let result = json_decode(a:state.result)
        let s:diagnostics = result.diagnostics
    endif

    call lightline#update()
endfunction

"}}}

"}}}

" Leader Mappings{{{

" so much more convenient
map <space> <leader>

" toggle folds does not work
" nnoremap <leader> <space> za

" show buffer list and wait for input to choose to which to switch to
nnoremap <leader>l :ls<CR>:b<space>

" edit vimrc
noremap <leader>er :e $MYVIMRC<CR>

" reload config
noremap <leader>rc :so $MYVIMRC<CR>

"}}}

" Miscellaneous Mappings{{{

" Easy window navigation
"map <C-h> <C-w>h
"map <C-j> <C-w>j
"map <C-k> <C-w>k
"map <C-l> <C-w>l

" This unsets the last search pattern register by hitting ESC
nnoremap <ESC> :nohlsearch<CR>

" Move text
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" tabs
"nnoremap <A-h> :tabprevious<CR>
"nnoremap <A-l> :tabnext<CR>

" CycleColors, it's bound in the plugin but incase I forget
nnoremap <f4> :CycleColorNext<cr>
nnoremap <f3> :CycleColorPrev<cr>

" Go into normal mode with Esc from terminal mode
tnoremap <Esc> <C-\><C-n>

" editing important files w/o running vim as root
cnoremap w!! w !doas tee % > /dev/null

" I never use Ex mode, so re-run macros instead
nnoremap Q @@

" sane movement through wrapping lines
noremap j gj
noremap k gk

" sometimes I get off the shift key too slowly
cnoremap W w
cnoremap Q q
cnoremap Wq wq
cnoremap WQ wq

" Output the current syntax group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"}}}
