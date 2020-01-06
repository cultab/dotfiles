"Basic Neovim Settings {{{

set nocompatible
set relativenumber
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab					 " use ta🅱️ s
set smarttab
set autoindent
set cindent
set splitbelow
set splitright
filetype plugin indent on
set autochdir
let g:c_syntax_for_h = 1   " Assume .h files are c headers instead of cpp
set hidden                 " Required for operations modifying multiple buffers like rename. with langclient
set mouse=a                " enable mouse for a(ll) modes
set ttyfast                " push more characters through to the terminal per cycle
set autoread               " auto-update if changes are detected
set gdefault               " assume the 'g' in s/../../g
set backup
set backupdir=~/.config/nvim/backup " don't leave a mess
set noswapfile
set backupskip=/tmp/*
set modeline
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

" Text manipulation
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'

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
Plug 'neomake/neomake'
Plug 'christoomey/vim-tmux-navigator'
Plug 'https://github.com/vim-scripts/CycleColor'

" Disabled
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

" Per FileType Settings {{{

set foldmethod=marker
augroup my_autocmds
autocmd FileType c,h,java,cpp,hpp setlocal nofoldenable foldmethod=syntax foldnestmax=1 foldminlines=10
autocmd FileType sh,bash call NeomakeConfig()
augroup end

function! NeomakeConfig()
	:Neomake
	call neomake#configure#automake('nw', 750)
	call neomake#configure#automake('rw', 1000)
	call neomake#configure#automake('w')
endfunction

"}}}

" Visual Settings + Lightline settings and functions {{{

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
let g:onedark_hide_endofbuffer = 1
let g:onedark_terminal_italics = 1

colorscheme onedark "after onedark settings


"Lightline options

let g:lightline#bufferline#min_buffer_count = 1
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#unicode_symbols = 1

let g:lightline = {
	\   'colorscheme' : 'one',
	\   'active' : {
	\	   'left' : [ [ 'mode', 'paste' ],
	\				[ 'filename', 'modified', 'readonly' ] ],
	\	   'right': [ [ 'wrn_cnt', 'err_cnt', 'lineinfo' ],
	\				[ 'percent' ],
	\				[ 'fileformat', 'fileencoding', 'filetype' ] ]
	\   },
	\   'inactive' : {
	\	   'left' : [ [ 'filename' ] ],
	\	   'right': [ [ 'lineinfo' ],
	\				[ 'percent' ] ]
	\   },
	\   'tabline' : {'left': [['buffers']], 'right': [['close']]},
	\   'component' : { 'lineinfo': ' %3l:%-2v'},
	\   'component_type' : {
	\	   'buffers'  : 'tabsel',
	\	   'readonly' : 'error',
	\	   'err_cnt'  : 'error',
	\	   'wrn_cnt'  : 'warning'
	\   },
	\   'component_function' : {
	\	   'err_cnt'  : 'LightlineErrorCount',
	\	   'wrn_cnt'  : 'LightlineWarningCount'
	\   },
	\   'component_expand' : {
	\	   'buffers'  : 'lightline#bufferline#buffers',
	\	   'readonly' : 'LightlineReadonly',
	\	   'err_cnt'  : 'LightlineErrorCount',
	\	   'wrn_cnt'  : 'LightlineWarningCount'
	\   },
	\   'separator'	: { 'left': '', 'right': '' },
	\   'subseparator' : { 'left': '', 'right': '' },
	\}

" Lightline Functions {{{

function! LightlineReadonly()
	return &readonly ? '' : ''
endfunction

" The following is practicaly stolen right out of
" airline's interface with LanguageClient
augroup lint_config
	autocmd!
	autocmd User LanguageClientStarted setlocal signcolumn=yes
	autocmd User LanguageClientStopped setlocal signcolumn=auto
	autocmd User LanguageClientDiagnosticsChanged call s:get_diagnostics()
	autocmd User NeomakeCountsChanged call s:get_Nmdiagnostics()
augroup END

" Severity codes from the LSP spec
let s:severity_error = 1
let s:severity_warning = 2
let s:severity_info = 3
let s:severity_hint = 4

" gets filled on autocmd
let s:diagnostics = {  }
let s:NmStatuslineCounts = {  }

" ✖✗
" calls LightlineLcGetTypeCount with type = error
function! LightlineErrorCount()
	let cnt = LightlineLcGetTypeCount(s:severity_error)
	if (cnt == 0)
		let cnt = LightlineNmGetTypeCount(s:severity_error)
	endif
	return cnt == 0 ? '' : printf('%d ', cnt)
endfunction

" calls LightlineLcGetTypeCount with type = warning

function! LightlineWarningCount()
	let cnt = LightlineLcGetTypeCount(s:severity_warning)
	if (cnt == 0)
		let cnt = LightlineNmGetTypeCount(s:severity_warning)
	endif
	return cnt == 0 ? '' : printf('%d ', cnt)
endfunction

function! LightlineNmGetTypeCount(type)
	let cnt = 0
	let key = '0'
	if (a:type == s:severity_error)
		let key = 'E'
	endif
	if (a:type == s:severity_warning)
		let key = 'W'
	endif
	if has_key(s:NmStatuslineCounts, key)
		let cnt = get(s:NmStatuslineCounts, key, 0)
	endif
	return cnt
endfunction

" counts keys with severity == type
function! LightlineLcGetTypeCount(type)
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

function! s:get_Nmdiagnostics()
	let s:NmStatuslineCounts = (neomake#statusline#LoclistCounts())
	"call lightline#update()
endfunction

function! s:record_diagnostics(state)
	" The returned message might not have the 'result' key
	if has_key(a:state, 'result')
		let result = json_decode(a:state.result)
		let s:diagnostics = result.diagnostics
	endif

	"call lightline#update()
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
noremap <leader>ec :e $MYVIMRC<CR>

" reload config
noremap <leader>rc :so $MYVIMRC<CR>

" Deal with the system clipboard CREDIT: Blaradox
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P

"}}}

" Miscellaneous Mappings{{{

" Easy window navigation
"map <C-h> <C-w>h
"map <C-j> <C-w>j
"map <C-k> <C-w>k
"map <C-l> <C-w>l

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

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
