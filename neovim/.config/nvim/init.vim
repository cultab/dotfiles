"Basic Neovim Settings {{{

set nocompatible
set relativenumber
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab					 " no ta🅱️ s
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
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
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
Plug 'vim-scripts/CycleColor'
Plug 'tpope/vim-sensible'

" Disabled
"Plug 'captbaritone/better-indent-support-for-php-with-html'

call plug#end()
"}}}

" Miscellaneous Plugin Settings{{{

"let g:pandoc#modules#disabled = ["folding"]

let g:VimuxOrientation = "h"
let g:tmux_navigator_no_mappings = 1

"}}}

" Autocomplete & related settings {{{
" complete from highlight files
set omnifunc=syntaxcomplete#Complete
" autocomplete don't insert
set completeopt=menuone,preview

" Start deoplete,echodoc automatically
let g:deoplete#enable_at_startup = 1
let g:echodoc_enable_at_startup = 1

" floating window
let g:echodoc#type = 'floating'

" Change the truncate width of completions.
call deoplete#custom#source('_', 'max_abbr_width', 0)

let g:LanguageClient_serverCommands = {
	\ 'python': ['~/.local/bin/pyls'],
    \ 'vhdl'  : ['hdl_checker', '--lsp'],
	\ 'c'     : ['/bin/clangd'],
	\ 'cpp'   : ['/bin/clangd']
	\}

"}}}

" Per Filetype Settings {{{

set foldmethod=marker
augroup my_autocmds
autocmd FileType c,h,java,cpp,hpp setlocal nofoldenable foldmethod=syntax foldnestmax=1 foldminlines=10
autocmd FileType sh,bash call NeomakeInit()
autocmd FileType rmd map <F6> :!echo<space>-e<space>"require(rmarkdown)\nrender('<c-r>%')"<space>\|<space>R<space>--vanilla<CR>
autocmd FileType rmd setlocal nowrap
augroup end

function! NeomakeInit()
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
let g:lightline#bufferline#show_number = 1
let g:lightline#bufferline#min_buffer_count = 1
let g:lightline#bufferline#enable_devicons = 1
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
	\   'separator'	: { 'left': '', 'right': '' },
	\   'subseparator' : { 'left': '|', 'right': '|' },
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

"{{{ Markdown Preview

let g:mkdp_browser = 'vivaldi-snapshot'

"}}}

"{{{ fzf settings

" Using floating windows of Neovim to start fzf
if has('nvim')
	let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2'

	function! FloatingFZF()
		let width = float2nr(&columns * 0.9)
		let height = float2nr(&lines * 0.6)
		let opts = { 'relative': 'editor',
		           \ 'row': (&lines - height) / 2,
		           \ 'col': (&columns - width) / 2,
		           \ 'width': width,
		           \ 'height': height }

		let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
		call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
	endfunction

	let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

"}}}

" Leader Mappings{{{

" so much more convenient
map <space> <leader>

" easier repeat
map <leader><space> .

" TODO: consider Unite.vim or any other buffer managing plugin

" fzf
nnoremap <leader>f :FZF<CR>

" list
nnoremap <leader>bl :ls:<CR>
" edit
nnoremap <leader>be :b<space>
" command
nnoremap <leader>bc :ls<CR>:b
" last used buffer
nnoremap <leader>bt :b#<CR>                          
" delete current buffer
nnoremap <leader>bd :bdelete<CR>

" vimux run last command
map <leader>vl :VimuxRunLastCommand<CR>
" Prompt for a command to run map
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vm :VimuxPromptCommand("make ")<CR>

" edit configs
noremap <leader>cb :e ~/.bashrc<CR>
noremap <leader>ct :e ~/.tmux.conf<CR>
noremap <leader>cs :e $repos/st/config.h<CR>
noremap <leader>cv :e $MYVIMRC<CR>
" reload vim config
noremap <leader>cr :so $MYVIMRC<CR>

" config plug install
nnoremap <leader>cpi :PlugInstall<CR>
nnoremap <leader>cpc :PlugClean<CR>
nnoremap <leader>cpu :PlugUpdate<CR>

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

" langclient
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> U :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" enter inserts seletion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-g>u\<S-Tab>"

nnoremap <silent> <M-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <M-j> :TmuxNavigateDown<CR>
nnoremap <silent> <M-k> :TmuxNavigateUp<CR>
nnoremap <silent> <M-l> :TmuxNavigateRight<CR>

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
nnoremap <f4> :CycleColorNext<CR>
nnoremap <f3> :CycleColorPrev<CR>

" Go into normal mode with Esc from terminal mode
tnoremap <Esc> <C-\><C-n>

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
