" Visual
set number
colo desert
" colo koehler

" Indent Settings
filetype plugin indent on
set smarttab
set autoindent
set cindent
set nowrap
set breakindent
set expandtab  " no ta🅱️ s
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround " round indent to shiftwidth

" Search Settings
set incsearch
set gdefault  " assume the 'g' in s/../../g
set ignorecase
set smartcase " all lower search is case insensitive

set spelllang=el,en

set shortmess+=c

" Misc Settings
set splitbelow
set splitright
set autochdir  " automatically change directory
set hidden  " Required for operations modifying multiple buffers like rename. with langclient
set mouse=a  " enable mouse for a(ll) modes
set autoread " auto-update if changes are detected, that's a big IF btw
set lazyredraw
set modeline

let g:c_syntax_for_h = 1   " Assume .h files are c headers instead of cpp

" so much more convenient
map <space> <leader>

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz

" cut line
nnoremap S i<CR><ESC>k$

" This unsets the last search pattern register by hitting <space>
nnoremap <silent><leader> :nohlsearch<CR>

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
