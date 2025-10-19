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
				-- Load luvit types when the `vim.uv` word is found
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
			},
		},
	},
	{ -- optional cmp completion source for require statements and module annotations
		'hrsh7th/nvim-cmp',
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = 'lazydev',
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
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
		opts = {
			keymaps = {
				-- insert = '<C-g>s',
				-- insert_line = '<C-g>S',
				normal = 's',
				normal_cur = 'ss',
				normal_line = 'S',
				normal_cur_line = 'ySS',
				visual = 'S',
				visual_line = 'gS',
				delete = 'ds',
				change = 'cs',
				change_line = 'cS',
			},
		},
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
