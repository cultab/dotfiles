return {

	'stevearc/dressing.nvim',
	{ 'j-hui/fidget.nvim', opts = {} },
	'MunifTanjim/nui.nvim',
	{
		'rcarriga/nvim-notify',
		config = function()
			vim.schedule_wrap()
			require('notify').setup {
				stages = 'static',
				timeout = '2500', -- in ms
			}
			vim.notify = require 'notify'
		end,
	},
	{ 'xiyaowong/nvim-cursorword' },
	{
		'brenoprata10/nvim-highlight-colors',
		opts = { ---Render style
			---@usage 'background'|'foreground'|'virtual'
			render = 'virtual',

			-- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
			exclude_filetypes = { 'lazy' },
			exclude_buftypes = {},
		},
	},
	{
		'onsails/lspkind-nvim',
		version = '*',
	},
}
