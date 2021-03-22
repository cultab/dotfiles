
"                        _
"                       | |
"    _             _    | |               _
"   |_|           |_|   | |              |_|
"    _   ______    _   _| |_    __   __   _    ___________       _
"   | | |  __  |  | | |_   _|   \ \ / /  | |  |  __   __  |    _| |_
"   | | | |  | |  | |   | |      \ v /   | |  | |  | |  | |   |_   _|
"   | | | |  | |  | |   | |   _   \ /    | |  | |  | |  | |     |_|
"   |_| |_|  |_|  |_|   |_|  |_|   v     |_|  |_|  |_|  |_|
"  ___________________________________________________________________
" |___________________________________________________________________|
"

"Basic Settings {{{

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

"}}}

"{{{ Autocommands 

if has("nvim")
    augroup termBinds
        autocmd!
        autocmd TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
        autocmd FileType fzf tunmap <buffer> <Esc>
    augroup end

    augroup filetype_autocmds
        autocmd!
        autocmd FileType rmd,md map <F6> :!R -e 'require(rmarkdown); render("./'%'");'<CR>
        autocmd FileType sh,bash,vhdl call neomake#configure#automake('nwri', 0)
    augroup end
endif

if system('uname -r') =~ "Microsoft"
    augroup Yank
        autocmd!
        autocmd TextYankPost * :call system('clip.exe ',@")
    augroup end
endif

augroup auto_formating
    autocmd!
    autocmd BufWritePre *.go,*.dart :call LanguageClient#textDocument_formatting_sync()
    " autocmd BufWritePre *.py :call LanguageClient#textDocument_formatting_sync()
augroup end

augroup auto_sauce
    autocmd!
    autocmd BufWritePost init.vim nested source $MYVIMRC
    autocmd BufWritePost *.tmux,*.tmux.conf silent !tmux source-file ~/.tmux.conf
    autocmd BufWritePost *.xdefaults silent !reload_xrdb
    autocmd BufWritePost ~/.bashrc silent !source ~/.bashrc "seems like it does nothing lol
    autocmd BufWritePost *.tex,*.latex silent !xelatex % 
augroup end

augroup lazy_load
    autocmd!
    autocmd InsertEnter * call deoplete#enable()
    autocmd InsertEnter * call echodoc#enable()
augroup end

" relative line numbers in normal mode, absolute numbers in insert mode | ehhh..
" augroup numbertoggle
"     autocmd!
"     autocmd InsertLeave * set relativenumber
"     autocmd InsertEnter * set norelativenumber
" augroup end

"fix langclient hover
augroup customize_langclient_hover
    autocmd!
    autocmd WinLeave __LCNHover__ ++nested call <SID>fixLanguageClientHover()
    autocmd User LanguageServerCrashed * echo OUPS OUPS
augroup end

augroup close_preview_split
    autocmd!
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
augroup end

"}}}

"{{{ Functions

"function! FzfSpellSink(word)
"  exe 'normal! "_ciw'.a:word
"endfunction
"function! FzfSpell()
"  let suggestions = spellsuggest(expand("<cword>"))
"  return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
"endfunction
"nnoremap z= :call FzfSpell()<CR>

function! Render_R()
    :!R -e 'require(rmarkdown); render("./'%'");'
    echo 'Done!'
endfunction

function! s:fixLanguageClientHover()
    setlocal wrap
    setlocal conceallevel=2
    setlocal nonu nornu
endfunction

"}}}

" Plugins {{{

" Install vim-plug

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin("~/.config/nvim/plugged")

"Autocomplete
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh',}
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/echodoc.vim'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/neco-vim'
Plug 'neomake/neomake'
"Plug 'artur-shaik/vim-javacomplete2'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'

" Text manipulation
Plug 'godlygeek/tabular'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Highlighting
Plug 'lilydjwg/colorizer'
Plug 'tmux-plugins/vim-tmux'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'plasticboy/vim-markdown'

" Visual
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/CycleColor'

" Colorschemes
Plug 'drewtempelmeyer/palenight.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'lifepillar/vim-gruvbox8'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'romgrk/github-light.vim'
Plug 'romgrk/doom-one.vim'
Plug 'joshdick/onedark.vim'
Plug 'ghifarit53/tokyonight-vim'
Plug 'ayu-theme/ayu-vim'
Plug 'deviantfero/wpgtk.vim'

" Tmux intergration
Plug 'benmills/vimux'
"Plug 'christoomey/vim-tmux-navigator'

" Misc
Plug 'tpope/vim-sensible'
"Plug '~/.fonts/scientifica/ligature_plugins'

call plug#end()
"}}}

" Plugin Settings {{{

set omnifunc=syntaxcomplete#Complete
set listchars=tab:┊\ ,nbsp:␣,trail:·,extends:>,precedes:<
set list
set fillchars=vert:\│
set complete=.,w,b,i,u,t,
set completefunc=LanguageClient#complete
set completeopt=menu,longest
call deoplete#custom#source('_', 'matchers', ['matcher_head', 'matcher_length'])

" floating window
let g:echodoc#type = 'floating'

" Change the truncate width of completions.
call deoplete#custom#source('_', 'max_abbr_width', 0)

let g:LanguageClient_settingsPath = "~/.config/nvim/settings.json"

let g:LanguageClient_serverCommands = {
    \ 'python' : ['~/.local/bin/pyls'],
    \ 'cpp'    : ['/bin/clangd','--suggest-missing-includes' ],
    \ 'go'     : ['gopls'],
    \ 'c'      : ['/bin/clangd','--suggest-missing-includes' ],
    \ 'java'   : ['~/bin/jdtls'],
    \ 'dart'   : ['dart', '/opt/flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot', '--lsp']
    \}

    "\ 'vhdl'  : ['hdl_checker', '--lsp']
"let g:pandoc#modules#disabled = ["folding"]

let g:VimuxOrientation = "h"
let g:tmux_navigator_no_mappings = 1

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 1
let g:indent_guides_guide_size = 1

" adding the default first
let g:AutoPairs={'```': '```', '`': '`', '"': '"', '{': '}', '''': '''', '(': ')', '''''''': '''''''', '[': ']', '"""': '"""'}
" adding extra TODO: autocommand for markdown, rmarkdown,tex files
augroup AutoPairsGroup
    autocmd!
    autocmd FileType tex,rmd,md :let g:AutoPairs['$']='$'
augroup end

"}}}

" Visual + Lightline settings {{{

set number
set norelativenumber
set signcolumn=yes
set foldmethod=marker

set scrolloff=3 " keep lines above and below cursor
set sidescroll=6
set noshowmode
set showcmd

set colorcolumn=80
set background=dark
set cursorline " highlight current line
set termguicolors

" Colorscheme Options
let g:palenight_terminal_italics = 1
let g:solarized_extra_hi_groups = 1
let g:lightline#colorscheme#github_light#faithful = 0
let ayucolor="dark"

let g:tokyonight_style = "night"
let g:tokyonight_disable_italic_comment = 1
let g:tokyonight_transparent_background = 1
let g:tokyonight_enable_italics = 1 "only works with custom fonts, see github

"colo github-light
"set background=light
colorscheme gruvbox8_hard

" Bufferline options
let g:lightline#bufferline#show_number = 1
let g:lightline#bufferline#min_buffer_count = 1
let g:lightline#bufferline#enable_devicons = 1

if has('gui_running') " disable gui bufferline
    set guioptions-=e
endif

" Lightline options
let g:lightline = {
    \   'colorscheme' : 'gruvbox8',
    \   'active' : {
    \       'left' : [ [ 'mode', 'paste' ],
    \                  [ 'filename', 'modified', 'readonly' ] ],
    \       'right': [ [ 'err_cnt', 'wrn_cnt', 'lineinfo' ],
    \                 [ 'percent' ],
    \                  [ 'fileformat', 'fileencoding', 'filetype', 'dev_icn' ] ]
    \   },
    \   'inactive' : {
    \       'left' : [ [ 'filename' ] ],
    \       'right': [ [ 'lineinfo' ],
    \                [ 'percent' ] ]
    \   },
    \   'tabline' : {'left': [['buffers']], 'right': [['close']]},
    \   'component' : { 
    \       'lineinfo': ' %3l:%-2v'
    \   },
    \   'component_type' : {
    \       'buffers'  : 'tabsel',
    \       'readonly' : 'error',
    \       'err_cnt'  : 'error',
    \       'wrn_cnt'  : 'warning'
    \   },
    \   'component_function' : {
    \       'err_cnt'  : 'LightlineErrorCount',
    \       'wrn_cnt'  : 'LightlineWarningCount',
    \       'dev_icn'  : 'GetDevicon'
    \   },
    \   'component_expand' : {
    \       'buffers'  : 'lightline#bufferline#buffers',
    \       'readonly' : 'LightlineReadonly',
    \       'err_cnt'  : 'LightlineErrorCount',
    \       'wrn_cnt'  : 'LightlineWarningCount'
    \   },
    \   'separator'    : { 'left': '', 'right': '' },
    \   'subseparator' : { 'left': '', 'right': '' },
    \}

    " \   'separator'    : { 'left': '', 'right': '' },
    " \   'subseparator' : { 'left': '', 'right': '' },

" Lightline Functions {{{
"

"symbols cache
" ✖✗

function! GetDevicon()
    " also add a space at the end
    return WebDevIconsGetFileTypeSymbol() . ' '
endfunction

function! LightlineReadonly()
    return &readonly ? ' ' : ''
endfunction

" The following is practicaly stolen right out of
" airline's interface with LanguageClient
augroup lint_config
    autocmd!
"    autocmd User LanguageClientStarted setlocal signcolumn=yes
"    autocmd User LanguageClientStopped setlocal signcolumn=auto
    autocmd User LanguageClientDiagnosticsChanged call s:get_diagnostics()
    autocmd User NeomakeCountsChanged call s:get_Nmdiagnostics()
augroup end

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
    return cnt == 0 ? '' : printf('%d  ', cnt)
endfunction

" calls LightlineLcGetTypeCount with type = warning

function! LightlineWarningCount()
    let cnt = LightlineLcGetTypeCount(s:severity_warning)
    if (cnt == 0)
        let cnt = LightlineNmGetTypeCount(s:severity_warning)
    endif
    return cnt == 0 ? '' : printf('%d  ', cnt)
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

"{{{ fzf settings TODO: fix this mess

" Using floating windows of Neovim to start fzf

if has('nvim')

    let $FZF_DEFAULT_OPTS = '--preview-window=right:75% --preview=bat'
    let g:LanguageClient_selectionUI = 'fzf' " TODO: make a bug report that this is not actually default
    " function! FloatingFZF()
    "     let width = float2nr(&columns * 0.9)
    "     let height = float2nr(&lines * 0.6)
    "     let opts = { 'relative': 'editor',
    "                \ 'row': (&lines - height) / 2,
    "                \ 'col': (&columns - width) / 2,
    "                \ 'width': width,
    "                \ 'height': height }

    "     let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    "     call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
    " endfunction

    " let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

"}}}

" Mappings {{{

" so much more convenient
map <space> <leader>

if system('uname -r') =~ "Microsoft"
    nnoremap <leader>p :let @+=system('powershell.exe -Command Get-Clipboard')<CR> p
endif

" fzf
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fa :Ag<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <leader>fc :Colors<CR>
nnoremap <leader>ft :Tags<CR>

" langclient
nnoremap <leader>sa   :call LanguageClient#textDocument_codeAction()<CR>
nnoremap <leader>sm	  :call LanguageClient_contextMenu()<CR>
nnoremap <F5>         :call LanguageClient_contextMenu()<CR>
nnoremap <silent>Y    :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent>gd   :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent><F2> :call LanguageClient#textDocument_rename()<CR>

" list
nnoremap <leader>bl :ls:<CR>
" edit
nnoremap <leader>be :b<space>
" command
nnoremap <leader>bb :ls<CR>:b
" last used buffer
nnoremap <leader>bt :b#<CR>
" delete current buffer
nnoremap <leader>bd :bdelete<CR>

" vimux run last command
map <leader>cl :VimuxRunLastCommand<CR>
" Prompt for a command to run map
map <Leader>cc :VimuxPromptCommand<CR>

" edit configs
noremap <leader>cb :e ~/.bashrc<CR>
noremap <leader>ct :e ~/.tmux.conf<CR>
noremap <leader>cs :e ~/repos/st/config.h<CR>
noremap <leader>cd :e ~/repos/dwm/config.h<CR>
noremap <leader>cv :e $MYVIMRC<CR>
noremap <leader>cx :e ~/.config/xrdb/<CR>
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

" enter inserts seletion, C-CR otherwise text is literaly inserted
inoremap <expr> <C-CR>  pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" select with tab
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-g>u\<S-Tab>"

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

" CycleColors, it's bound in the plugin but incase I forget
nnoremap <f4> :CycleColorNext<CR>
nnoremap <f3> :CycleColorPrev<CR>

" I never use Ex mode, so re-run macros instead
nnoremap Q @@

" sane movement through wrapping lines
noremap j gj
noremap k gk
noremap ξ gj
noremap κ gk

" sometimes I get off the shift key too slowly, ~~maybe don't do it then?~~,
" HA abbr to the rescue
cabbr Q q
cabbr W w
cabbr Wq wq
cabbr WQ wq
cabbr Wa wa
cabbr WA wa

" Output the current syntax group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"}}}
