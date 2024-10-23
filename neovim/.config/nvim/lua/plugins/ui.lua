return {

	'stevearc/dressing.nvim',
	{ 'j-hui/fidget.nvim', opts = {} },
	{
		'prichrd/netrw.nvim',
		ft = 'netrw',
	},
	'MunifTanjim/nui.nvim',
	{
		'rcarriga/nvim-notify',
		config = function()
			require('notify').setup {
				stages = 'static',
				timeout = '2500', -- in ms
			}
			vim.notify = require 'notify'
		end,
	},
	-- {
	--     "X3eRo0/dired.nvim",
	--     requires = "MunifTanjim/nui.nvim",
	--     config = function()
	--         require("dired").setup {
	--             path_separator = "/",
	--             show_banner = false,
	--             show_hidden = true,
	--             show_dot_dirs = true,
	--             show_colors = true,
	--         }
	--     end
	-- },
	{ 'xiyaowong/nvim-cursorword' },
	{
		'akinsho/toggleterm.nvim',
		opts = {
			direction = 'vertical',
			start_in_insert = true,
			size = vim.o.columns * 0.4,
		},
		event = 'BufWinEnter',
		cmd = { 'TermExec', 'ToggleTermToggleAll', 'ToggleTerm' },
	},
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
