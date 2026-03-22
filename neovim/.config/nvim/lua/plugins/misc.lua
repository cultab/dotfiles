return {
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = { fast_wrap = {} },
	},
	{
		'folke/lazydev.nvim',
		ft = 'lua', -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				vim.env.VIMRUNTIME,
				-- Load luvit types when the `vim.uv` word is found
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
			},
		},
	},
	{
		'OXY2DEV/helpview.nvim',
		lazy = false,
	},
	{
		'echasnovski/mini.align',
		version = '*',
		opts = {},
		cmd = 'MiniAlign',
	},
	{
		'kylechui/nvim-surround',
	},
	{
		'windwp/nvim-ts-autotag',
		opts = {
			filetypes = { 'html', 'xml' },
		},
		ft = { 'html', 'xml' },
	},
	{
		'kovetskiy/sxhkd-vim',
		ft = { 'sxhkd' },
	},
	{
		'ojroques/vim-oscyank',
	},
	-- {
	--     "m4xshen/hardtime.nvim",
	--     dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	--     opts = {}
	-- },
}
