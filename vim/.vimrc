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
set inccommand=split " show substitutions live
set incsearch
set gdefault  " assume the 'g' in s/../../g
set ignorecase
set smartcase " all lower search is case insensitive

set spelllang=el,en

set shortmess+=c

" Backup and swap
set backup
set backupdir=~/.config/nvim/backup " don't leave a mess
set backupskip=/tmp/*
set undodir=~/.config/nvim/undo
set undofile
set noswapfile

" Misc Settings
set clipboard+=unnamedplus
set splitbelow
set splitright
set autochdir  " automatically change directory
set hidden  " Required for operations modifying multiple buffers like rename. with langclient
set mouse=a  " enable mouse for a(ll) modes
set autoread " auto-update if changes are detected, that's a big IF btw
set lazyredraw
set modeline
"set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,ΣW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz
set keymap=greek_utf-8
set iminsert=0  " default to english

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
