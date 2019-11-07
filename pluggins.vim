"Plugins 
call plug#begin("~/.config/nvim/plugged")

"Autocomplete
Plug 'Shougo/deoplete.nvim'
Plug 'https://github.com/vim-scripts/dbext.vim'
Plug 'https://github.com/ervandew/supertab'
Plug 'borissov/vim-mysql-suggestions'
Plug 'https://github.com/Shougo/deoplete-clangx'
Plug 'https://github.com/Shougo/neco-syntax'
"Plug 'jiangxincode/mpi.vim'

"Linting
Plug 'nvie/vim-flake8'

"Autoclose
Plug 'jiangmiao/auto-pairs'

"Visual
Plug 'vim-airline/vim-airline'
"Plug 'mengelbrecht/lightline-bufferline'

"Colorschemes
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'elitetester29/plastic.vim'
Plug 'https://github.com/vim-scripts/CycleColor'
Plug 'joshdick/onedark.vim'

"Misc
Plug 'sheerun/vim-polyglot'
Plug 'captbaritone/better-indent-support-for-php-with-html'

"Disabled 
"Plug 'zxqfl/tabnine-vim'
"Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

call plug#end()

"Start deoplete automatically
let g:deoplete#enable_at_startup = 1

"Colorscheme Options
colorscheme plastic
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
set termguicolors
"let g:airline_theme='gruvbox'
"let g:gruvbox_italic=1
"colorscheme gruvbox

"mySQL completion
let g:database_host = "localhost"
let g:database_password = "rootP"
let g:database_database = "warehouse"
let g:database_user = "root"

