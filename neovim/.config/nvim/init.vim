
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
set nocompatible
set relativenumber
set number
set signcolumn=yes

filetype plugin indent on
set smarttab
set autoindent
set cindent
set nowrap
set breakindent

set noexpandtab  " use ta🅱️ s
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround " round indent to shiftwidth

set splitbelow
set splitright
set autochdir  " automatically change directory
set hidden  " Required for operations modifying multiple buffers like rename. with langclient
set mouse=a  " enable mouse for a(ll) modes

set autoread " auto-update if changes are detected, that's a big IF btw

set inccommand=split " show substitutions live
set incsearch
set gdefault  " assume the 'g' in s/../../g
set ignorecase
set smartcase " all lower search is case insensitive
set spelllang=el

set foldmethod=marker

set scrolloff=3 " keep lines above and below cursor
set sidescroll=6

set shortmess+=c

set backup
set backupdir=~/.config/nvim/backup " don't leave a mess
set backupskip=/tmp/*
set undodir=~/.config/nvim/undo
set undofile
set noswapfile

set clipboard+=unnamedplus

set lazyredraw
set modeline

set noshowmode
set showcmd

set cursorline " highlight current line
set colorcolumn=80
set background=dark
set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz

let g:c_syntax_for_h = 1   " Assume .h files are c headers instead of cpp

"}}}

"{{{ Autocommands 

if has("nvim")
    augroup termBinds
        autocmd!
        autocmd TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
        autocmd FileType fzf tunmap <buffer> <Esc>
    augroup END

    augroup filetype_autocmds
        autocmd!
        autocmd FileType rmd,md map <F6> :!R -e 'require(rmarkdown); render("./'%'");'<CR>
        autocmd FileType sh,bash,vhdl,java call neomake#configure#automake('nwri', 0)
    augroup end
endif

if system('uname -r') =~ "Microsoft"
    augroup Yank
        autocmd!
        autocmd TextYankPost * :call system('clip.exe ',@")
    augroup END
endif

augroup formating
    autocmd!
    autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
    " autocmd BufWritePre *.py :call LanguageClient#textDocument_formatting_sync()
augroup END

augroup auto_sauce
    autocmd!
    autocmd BufWritePost init.vim nested source $MYVIMRC
    autocmd BufWritePost *.tmux,*.tmux.conf silent !tmux source-file ~/.tmux.conf
    autocmd BufWritePost *.xdefaults silent !xrdb -load -I"$HOME/.config/xrdb" ~/.config/xrdb/Xresources.xdefaults
    autocmd BufWritePost ~/.bashrc silent !source ~/.bashrc "seems like it does nothing lol
    autocmd BufWritePost *.tex,*.latex silent !xelatex % 
augroup END

augroup lazy_load
    autocmd!
    autocmd InsertEnter * call deoplete#enable()
    autocmd InsertEnter * call echodoc#enable()
augroup end

" relative line numbers in normal mode, absolute numbers in insert mode
augroup numbertoggle
    autocmd!
    autocmd InsertLeave * set relativenumber
    autocmd InsertEnter * set norelativenumber
augroup END

" fix langclient hover
augroup markdown_language_client_commands
    autocmd!
    autocmd WinLeave __LanguageClient__ ++nested call <SID>fixLanguageClientHover()
augroup END

augroup close_preview_split
    autocmd!
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
augroup END

" not yet supported
augroup lang_cliennt
    autocmd!
    autocmd User LanguageServerCrashed * echo OUPS OUPS
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

function! s:fixLanguageClientHover()
    setlocal wrap
    setlocal modifiable
    setlocal conceallevel=2
    normal i
    setlocal nonu nornu
    setlocal nomodifiable
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
Plug 'artur-shaik/vim-javacomplete2'
Plug 'jiangmiao/auto-pairs'
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

" Visual
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/CycleColor'

" Colorschemes
Plug 'drewtempelmeyer/palenight.vim'
Plug 'lifepillar/vim-gruvbox8'
Plug 'lifepillar/vim-solarized8'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'romgrk/github-light.vim'
Plug 'romgrk/doom-one.vim'

" Tmux intergration
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'

" Misc
Plug 'tpope/vim-sensible'
"Plug '~/.fonts/scientifica/ligature_plugins'

call plug#end()
"}}}

" Plugin Settings {{{

set omnifunc=syntaxcomplete#Complete
set listchars=tab:┊\ ,nbsp:␣,trail:·,extends:>,precedes:<
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
let g:AutoPairs['$']='$'

"}}}

" Visual + Lightline settings {{{

" Colorscheme Options
set termguicolors

let g:palenight_terminal_italics = 1
let g:solarized_extra_hi_groups = 1
let g:lightline#colorscheme#github_light#faithful = 0



colo github-light
"set background=light
colorscheme palenight

" Bufferline options
let g:lightline#bufferline#show_number = 1
let g:lightline#bufferline#min_buffer_count = 1
let g:lightline#bufferline#enable_devicons = 1

if has('gui_running') " disable gui bufferline
    set guioptions-=e
endif

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
    \   'separator'    : { 'left': '', 'right': '' },
    \   'subseparator' : { 'left': '', 'right': '' },
    \}

    " \   'separator'    : { 'left': '', 'right': '' },
    " \   'subseparator' : { 'left': '', 'right': '' },

" Lightline Functions {{{

"symbols cache
" ✖✗

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

" easier repeat
"map <leader><space> .

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

" split prefix, C-w is taken by TMUX
" nnoremap <C-a> <C-w>

" This unsets the last search pattern register by hitting ESC
nnoremap <silent><ESC> :nohlsearch<CR>

" easier navigation in normal / visual / operator pending mode
noremap H ^
noremap L $

nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
nnoremap <silent> <C-w>o :TmuxNavigatePrevious<cr>

" Change text without putting the text into register
noremap c "_c
noremap C "_C
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

" Output the current syntax group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"}}}
