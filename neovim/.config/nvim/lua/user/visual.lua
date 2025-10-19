if vim.g.nvui then
	-- Configure through vim commands
	vim.cmd [[
    ]]
end

local icons = require 'user.icons'

-- vim.g.ts_highlight_lua = true
-- vim.opt.pumblend = 20 -- pseudo transparency for popup windows

-- vim.o.foldtext = require('user.foldfunc').lua_global_func
vim.o.foldtext = ''
vim.o.termguicolors = true
vim.o.laststatus = 3

vim.cmd [[highlight link CompeDocumentation Normal]]

vim.diagnostic.config {
	float = {
		close_events = { 'InsertEnter', 'CursorMoved' },
		border = 'rounded',
		source = 'always',
		prefix = ' ',
		scope = 'cursor',
	},
	signs = {text = {
		[vim.diagnostic.severity.ERROR] = icons.diagnostic.error,
		[vim.diagnostic.severity.WARN] = icons.diagnostic.warn,
		[vim.diagnostic.severity.INFO] = icons.diagnostic.info,
		[vim.diagnostic.severity.HINT] = icons.diagnostic.hint,
	}}
}


-- used as separator for windows

vim.opt.fillchars = {
	vert = icons.line.center_line,
	foldclose = icons.fold.close,
	foldopen = icons.fold.open,
	foldsep = icons.fold.sep,
}
vim.o.list = true
vim.opt.listchars = {
	nbsp = icons.listchars.nbsp,
	trail = icons.listchars.trail,
	tab = icons.listchars.tab,
}

-- HACK: see: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59#issuecomment-806398054"
vim.wo.colorcolumn = '99999'

vim.o.number = true
vim.o.relativenumber = true
-- vim.o.signcolumn = 'yes:3'
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = true
vim.o.foldlevelstart = 99
vim.o.foldcolumn = '1'

vim.o.scrolloff = 1 -- keep lines above and below cursor
vim.o.sidescroll = 1
vim.o.showmode = false
vim.o.showcmd = true

vim.o.background = 'dark'
vim.o.cursorline = true -- highlight current line

-- Colorscheme Options

local function scope()
	local sidebars = { 'qf', 'vista_kind', 'terminal', 'packer' }
	local transparent = false
	local lualine_bold = true
	local italic_functions = true
	local hide_inactive_status = true

	vim.g.palenight_terminal_italics = true
	vim.g.solarized_extra_hi_groups = true
	vim.g.ayucolor = 'dark'

	-- Tokyonight {{{
	vim.g.tokyonight_transparent = transparent
	vim.g.tokyonight_italic_functions = italic_functions
	vim.g.tokyonight_sidebars = sidebars
	vim.g.tokyonight_lualine_bold = lualine_bold
	vim.g.tokyonight_hide_inactive_statusline = hide_inactive_status
	--}}}
	-- Gruvbox {{{
	vim.g.gruvbox_italic_functions = italic_functions
	vim.g.gruvbox_transparent = transparent
	vim.g.gruvbox_sidebars = sidebars
	vim.g.gruvbox_lualine_bold = lualine_bold
	vim.g.gruvbox_hide_inactive_statusline = hide_inactive_status
	--}}}
	-- vscode {{{
	vim.g.vscode_style = 'dark'
	vim.g.vscode_italic_comment = 1
	--}}}
	-- oxocarbon {{{
	vim.g.oxocarbon_lua_keep_terminal = true
	-- }}}
end
scope()

vim.cmd [[
augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]
