-- vim.g.python3_host_prog = "$PYENV_ROOT/shims/python3"
require 'user.options'
require 'user.visual'

require 'user.lazy'


vim.cmd.colorscheme(require'user.colorscheme')
require 'user.mappings'
require 'user.lsp'
