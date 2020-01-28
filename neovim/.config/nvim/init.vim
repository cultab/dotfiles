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
Plug 'godlygeek/tabular'

" (Optional from langclient) Multi-entry selection UI.
Plug 'junegunn/fzf'

" Highlighting
Plug 'sheerun/vim-polyglot'
Plug 'lilydjwg/colorizer'

" Visual
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'

" Colorschemes
Plug 'cultab/palenight.vim'
Plug 'cultab/plastic.vim'
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'

" Tmux intergration
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'

" Misc
Plug 'neomake/neomake'
Plug 'https://github.com/vim-scripts/CycleColor'
Plug 'tpope/vim-sensible'

" Disabled
"Plug 'captbaritone/better-indent-support-for-php-with-html'

call plug#end()
"}}}

" Miscellaneous Plugin Settings{{{


let g:VimuxOrientation = "h"


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
let g:palenight_terminal_italics = 1
"let g:onedark_terminal_italics = 1

colorscheme palenight "after settings

" Bufferline options
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#min_buffer_count = 1
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#unicode_symbols = 1
if has('gui_running')
	set guioptions-=e
endif

"symbols cache
" ✖✗

" Lightline options
let g:lightline = {	
	\   'colorscheme' : 'palenight',
	\   'active' : {
	\	   'left' : [ [ 'mode', 'paste' ],
	\				[ 'filename', 'modified', 'readonly' ] ],
	\	   'right': [ [ 'err_cnt', 'wrn_cnt', 'lineinfo' ],
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
	\   'separator'	: { 'left': '', 'right': '' },
	\   'subseparator' : { 'left': '', 'right': '|' },
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
	call lightline#update()
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

" list buffers
nnoremap <leader>bl :ls:<CR>
" buffer command
nnoremap <leader>bc :ls<CR>:b
" last used buffer
nnoremap <leader>bt :b#<CR>                          
" edit buffer
nnoremap <leader>be :b<space>                        
" delete current buffer
nnoremap <leader>bd :bdelete<CR>
" next buffer
nnoremap <leader>bn :bn<CR>                          
" previews buffer
nnoremap <leader>bp :bp<CR>                          
" goto buffer in bufferline
nnoremap <Leader>b1 <Plug>lightline#bufferline#go(1) 
nnoremap <Leader>b2 <Plug>lightline#bufferline#go(2)
nnoremap <Leader>b3 <Plug>lightline#bufferline#go(3)
nnoremap <Leader>b4 <Plug>lightline#bufferline#go(4)
nnoremap <Leader>b5 <Plug>lightline#bufferline#go(5)
nnoremap <Leader>b6 <Plug>lightline#bufferline#go(6)
nnoremap <Leader>b7 <Plug>lightline#bufferline#go(7)
nnoremap <Leader>b8 <Plug>lightline#bufferline#go(8)
nnoremap <Leader>b9 <Plug>lightline#bufferline#go(9)
nnoremap <Leader>b0 <Plug>lightline#bufferline#go(10)

" vimux run last command
map <leader>vl :VimuxRunLastCommand<CR>
" Prompt for a command to run map
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vm :VimuxPromptCommand("make ")<CR>

" edit vimrc
noremap <leader>ce :e $MYVIMRC<CR>
" reload config
noremap <leader>cr :so $MYVIMRC<CR>

" config plug install
nnoremap <leader>cpi :PlugInstall<CR>
nnoremap <leader>cpc :PlugClean<CR>

" text tabulirize
noremap <leader>tt :Tabularize<space>/
" text align
noremap <leader>ta :EasyAlign<CR>

" Deal with the system clipboard CREDIT: Blaradox
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P

"}}}

" Miscellaneous Mappings{{{

" Custom Key Bindings

nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>

" split prefix, C-w is taken by TMUX
nnoremap <C-a> <C-w>

" This unsets the last search pattern register by hitting ESC
nnoremap <silent><ESC> :nohlsearch<CR>

" Move text
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" CycleColors, it's bound in the plugin but incase I forget
nnoremap <f4> :CycleColorNext<cr>
nnoremap <f3> :CycleColorPrev<cr>

" Go into normal mode with Esc from terminal mode
tnoremap <Esc> <C-\><C-n>

" editing important files w/o running vim as root
cnoremap w!! w !sudo tee % > /dev/null

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
