"Basic Settings {{{
set nocompatible
set relativenumber
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab                     " no ta🅱️ s
set shiftround " round indent to shiftwidth
filetype plugin indent on
set smarttab
set autoindent
set cindent
set splitbelow
set splitright
let g:c_syntax_for_h = 1   " Assume .h files are c headers instead of cpp
set noautochdir
set hidden                 " Required for operations modifying multiple buffers like rename. with langclient
set mouse=a                " enable mouse for a(ll) modes
set autoread               " auto-update if changes are detected
set incsearch
set gdefault               " assume the 'g' in s/../../g
set smartcase " all lower search is case insensitive
set foldmethod=marker
set scrolloff=3 " keep lines above and below cursor
set inccommand=split " show substitutions live
set shortmess+=c
set backup
set backupdir=~/.config/nvim/backup " don't leave a mess
set backupskip=/tmp/*
set undofile
set undodir=~/.config/nvim/undo
set noswapfile
set clipboard+=unnamedplus
set termguicolors " more colors ?
syntax on
set lazyredraw
set modeline
set signcolumn=yes " Always draw the signcolumn.
set noshowmode
set showcmd
set nowrap
set breakindent
set cursorline " highlight current line
set background=dark
set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz


"}}}

"{{{ Autocommands 

"augroup close_preview_split
"    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
"augroup END

augroup PrettyIndent
    autocmd!
    autocmd TextChanged * call PrettyIndent()
    autocmd BufEnter * call PrettyIndent()
    autocmd InsertLeave * call PrettyIndent()
augroup END

augroup auto_sauce
    autocmd! BufWritePost $MYVIMRC source $MYVIMRC
    autocmd! BufWritePost *.tmux,*.tmux.conf silent !tmux source-file ~/.tmux.conf
    autocmd! BufWritePost ~/.bashrc silent !source ~/.bashrc "seems like it does nothing lol
augroup END

augroup lazy_load
    autocmd InsertEnter * call deoplete#enable()
    autocmd InsertEnter * call echodoc#enable()
augroup end

augroup filetype_autocmds
    autocmd FileType rmd,md map <F6> :!R -e 'require(rmarkdown); render("./'%'");'<CR>
    autocmd FileType sh,bash call NeomakeInit()
augroup end

" relative line numbers in normal mode, absolute numbers in insert mode
augroup numbertoggle
    autocmd!
    autocmd InsertLeave * set relativenumber
    autocmd InsertEnter * set norelativenumber
augroup END

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

function! NeomakeInit()
    :Neomake
    call neomake#configure#automake('nw', 750)
    call neomake#configure#automake('rw', 1000)
    call neomake#configure#automake('w')
endfunction

function! PrettyIndent()
    let l:view=winsaveview()
    call cursor(1, 1)
    call nvim_buf_clear_namespace(0, g:pretty_indent_namespace, 1, -1)
    while 1
        let l:match = search('^$', 'W')
        if l:match ==# 0
            break
        endif
        let l:indent = cindent(l:match)
        if l:indent > 0
            call nvim_buf_set_virtual_text(
            \   0,
            \   g:pretty_indent_namespace,
            \   l:match - 1,
            \   [[repeat(repeat(' ', &shiftwidth - 1) . '│', l:indent / &shiftwidth), 'IndentGuide']],
            \   {}
            \)
        endif
    endwhile
    call winrestview(l:view)
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
Plug 'jiangmiao/auto-pairs'

" Text manipulation
Plug 'godlygeek/tabular'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'

" (Optional from langclient) Multi-entry selection UI.
Plug 'junegunn/fzf'

" Highlighting
Plug 'lilydjwg/colorizer'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Visual
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'vim-scripts/CycleColor'

" Colorschemes
Plug 'cultab/palenight.vim'
Plug 'joshdick/onedark.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'cultab/plastic.vim'

" Tmux intergration
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
Plug 'benmills/vimux'

" Misc
Plug 'tpope/vim-sensible'

call plug#end()
"}}}

" Plugin Settings {{{

" ctest
set completeopt=menu,longest

call deoplete#custom#source('_', 'matchers', ['matcher_head', 'matcher_length'])

" floating window
let g:echodoc#type = 'floating'

" Change the truncate width of completions.
call deoplete#custom#source('_', 'max_abbr_width', 0)

let g:LanguageClient_serverCommands = {
    \ 'c'     : ['/bin/clangd','--suggest-missing-includes' ],
    \ 'cpp'   : ['/bin/clangd','--suggest-missing-includes' ],
    \ 'python': ['~/.local/bin/pyls'],
    \ 'vhdl'  : ['hdl_checker', '--lsp']
    \}

"let g:pandoc#modules#disabled = ["folding"]

let g:VimuxOrientation = "h"
let g:tmux_navigator_no_mappings = 1

let g:indentLine_setColors = 0
let g:pretty_indent_namespace = nvim_create_namespace('pretty_indent')
let g:indentLine_char = '│'

"}}}

" Visual + Lightline settings {{{

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
    \       'left' : [ [ 'mode', 'paste' ],
    \                  [ 'filename', 'modified', 'readonly' ] ],
    \       'right': [ [ 'err_cnt', 'wrn_cnt', 'lineinfo' ],
    \                 [ 'percent' ],
    \                  [ 'fileformat', 'fileencoding', 'filetype' ] ]
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
    \       'wrn_cnt'  : 'LightlineWarningCount'
    \   },
    \   'component_expand' : {
    \       'buffers'  : 'lightline#bufferline#buffers',
    \       'readonly' : 'LightlineReadonly',
    \       'err_cnt'  : 'LightlineErrorCount',
    \       'wrn_cnt'  : 'LightlineWarningCount'
    \   },
    \   'separator'    : { 'left': '', 'right': '' },
    \   'subseparator' : { 'left': '', 'right': '' },
    \}

" Lightline Functions {{{

function! LightlineReadonly()
    return &readonly ? '' : ''
endfunction

" The following is practicaly stolen right out of
" airline's interface with LanguageClient
augroup lint_config
    autocmd!
"    autocmd User LanguageClientStarted setlocal signcolumn=yes
"    autocmd User LanguageClientStopped setlocal signcolumn=auto
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

" Mappings {{{

" so much more convenient
map <space> <leader>

" easier repeat
map <leader><space> .

" TODO: consider Unite.vim or any other buffer managing plugin

" fzf
nnoremap <leader>ff :FZF<CR>

" langclient
nnoremap <leader>sm :call LanguageClient_contextMenu()<CR>
nnoremap <leader>sa :call LanguageClient#textDocument_codeAction()<CR>
"nnoremap <leader>sa :call LanguageClient#handleCodeLensAction()<CR>
"nnoremap <leader>sa :call LanguageClient#handleCodeLensAction()<CR>

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

" langclient
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> U :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" enter inserts seletion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-g>u\<S-Tab>"

nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-l> :TmuxNavigateRight<CR>

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz

" split prefix, C-w is taken by TMUX
" nnoremap <C-a> <C-w>

" This unsets the last search pattern register by hitting ESC
nnoremap <silent><ESC> :nohlsearch<CR>

" easier navigation in normal / visual / operator pending mode
noremap K {
noremap J }
noremap H ^
noremap L $

" Change text without putting the text into register,
nnoremap c "_c
nnoremap C "_C
nnoremap cc "_cc
nnoremap x "_x

" Move text
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

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
