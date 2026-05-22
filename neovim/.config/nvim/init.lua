require 'user.options'
require 'user.visual'

if not vim.g.vscode then
	require 'user.lazy'
	require 'user.lsp'
end

vim.cmd.colorscheme(require 'user.colorscheme')

require 'user.mappings'


