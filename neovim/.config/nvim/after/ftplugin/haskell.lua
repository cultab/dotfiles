local map = require 'user.map'.map
vim.opt.expandtab = true -- spaces
vim.opt.tabstop = 4 -- tab size is 4
vim.opt.softtabstop = 4 -- expanded size is 4
vim.opt.shiftwidth = 4 -- indent size is 4

-- ~/.config/nvim/after/ftplugin/haskell.lua

local ht = require 'haskell-tools'
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr }
local function keymap(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
end
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
map 'n' { nil, '[h]askell' }
keymap('n', '<leader>hl', vim.lsp.codelens.run, 'code[l]ens')
-- Hoogle search for the type signature of the definition under the cursor
keymap('n', '<leader>hs', ht.hoogle.hoogle_signature, 'hoogle [s]ignature')
-- Evaluate all code snippets
keymap('n', '<leader>he', ht.lsp.buf_eval_all, '[e]val')
-- Toggle a GHCi repl for the current package
keymap('n', '<leader>hr', ht.repl.toggle, '[r]epl')
-- Toggle a GHCi repl for the current buffer
keymap('n', '<leader>hb', function()
	ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, '[h]askel [b]uffer repl')
keymap('n', '<leader>hq', ht.repl.quit, 'repl [q]uit')
