-- tabsize
vim.opt.expandtab = false -- tabs
vim.opt.tabstop = 4 -- tab size is 4
vim.opt.softtabstop = 4 -- expanded size is 4
vim.opt.shiftwidth = 4 -- indent size is 4
vim.opt.shiftround = true -- round indent to shiftwidth

vim.opt.smartindent = true

-- wrap
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(' ', 3) -- make it so that long lines wrap smartly, ~TJDevries
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Search Settings
vim.opt.inccommand = 'nosplit' -- show substitutions live, now without splitting!
vim.opt.gdefault = true -- assume the 'g' in s/../../g
vim.opt.smartcase = true -- all lower search is case insensitive
vim.opt.ignorecase = true
vim.opt.infercase = true

-- don't give |ins-completion-menu| messages. For example,
-- "-- XXX completion (YYY)", "match 1 of 2", "The only match",
vim.opt.shortmess:append 'c'

-- Backup and swap
vim.opt.backup = true
vim.opt.backupdir:remove '.'
vim.opt.undofile = true
vim.opt.undodir:remove '.'
vim.opt.swapfile = false

-- Misc Settings

local function paste()
	return {
		vim.split(vim.fn.getreg '', '\n'),
		vim.fn.getregtype '',
	}
end

-- if vim.env.WSL_DISTRO_NAME then
	-- vim.g.clipboard = {
	-- 	name = 'WslClipboard',
	-- 	copy = {
	-- 		['+'] = 'clip.exe',
	-- 		['*'] = 'clip.exe',
	-- 	},
	-- 	paste = {
	-- 		['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	-- 		['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	-- 	},
	-- 	cache_enabled = 0,
	-- }
if vim.env.SSH_TTY then
	vim.g.clipboard = {
		name = 'OSC 52',
		copy = {
			['+'] = require('vim.ui.clipboard.osc52').copy '+',
			['*'] = require('vim.ui.clipboard.osc52').copy '*',
		},
		paste = {
			['+'] = paste,
			['*'] = paste,
		},
	}
end
vim.opt.clipboard:prepend { 'unnamedplus' }

vim.opt.updatetime = 50 -- ms

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'screen'

vim.opt.autochdir = false -- automatically change directory
vim.opt.mouse = 'a' -- enable mouse for a(ll) modes
vim.opt.lazyredraw = false
vim.opt.modeline = true

-- language
vim.opt.spelllang = 'el,en'
-- vim.opt.spelloptions = 'camel' -- BUG: replaces words with single, accented, letters?
vim.opt.keymap = 'greek_utf-8'
vim.opt.iminsert = 0 -- default to english

vim.opt.virtualedit = 'block'

-- Assume .h files are c headers instead of cpp
vim.g.c_syntax_for_h = true

vim.opt.complete = '.,w,b,i,u,t,'
vim.opt.completeopt = 'menu,menuone,noselect' -- ,noinsert,longest"
vim.opt.formatoptions = vim.opt.formatoptions - 'a' - 't' + 'q' - 'o' + 'r' + 'n' + 'j' - '2'

vim.opt.autoread = true

local ____no = 1

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local misc = augroup('focusChecktime', {})

autocmd('FocusGained', {
	pattern = '*',
	command = ':checktime',
	group = misc,
})

local fo = augroup('filetypeOpts', {})

autocmd('FileType', {
	pattern = 'yaml,norg',
	command = 'setlocal ts=2 sts=2 sw=2 expandtab',
	group = fo,
})

autocmd('FileType', {
	pattern = 'norg,rmd,quarto,text',
	command = 'setlocal spell wrap',
	group = fo,
})

autocmd('BufEnter', {
	pattern = '*/srcpkgs/*/template',
	command = ':setfiletype sh',
	group = fo,
})

autocmd('TermOpen', {
	pattern = '*',
	command = 'nnoremap <buffer> <Esc> :ToggleTermToggleAll<CR>',
	group = fo,
})

autocmd('TermOpen', {
	pattern = '*',
	command = 'tnoremap <buffer> <Esc> <c-\\><c-n>',
	group = fo,
})

local ns = augroup('newSauce', {})

autocmd('BufWritePost', {
	pattern = '*/user/*.lua',
	group = ns,
	callback = function(_)
		for pkg, mod in pairs(package.loaded) do
			if string.find(pkg, 'user%..*') then
				local ignore = { 'lazy', 'colorscheme', 'lsp' }
				for _, ignored_pkg in pairs(ignore) do
					if pkg:find('user%.' .. ignored_pkg) then
						goto skip
					end
				end
				package.loaded[pkg] = nil
				::skip::
			end
		end
		vim.schedule(function()
			vim.cmd.source(vim.fn.expand '$MYVIMRC')
			vim.notify('Config reload successfull!', 'info', { title = 'Reloaded' })
		end)
	end,
})

autocmd('BufWritePost', {
	pattern = '.tmux.conf',
	command = "silent !tmux display-message 'Sourced .tmux.conf\\!' ';' source-file ~/.tmux.conf",
	group = ns,
})
autocmd('BufWritePost', {
	pattern = '*.xdefaults',
	command = 'silent !reload_xrdb',
	group = ns,
})
autocmd('BufWritePost', {
	pattern = 'bspwmrc',
	command = 'silent !~/.config/bspwm/bspwmrc',
	group = ns,
})
