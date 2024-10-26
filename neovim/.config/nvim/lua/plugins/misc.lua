return {
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		opts = { fast_wrap = {} },
	},
	{
		--[[
lua= vim.lsp.get_active_clients({ name = "lua_ls" })[1].config.settings.Lua
--]]
		'folke/neodev.nvim',
		opts = {},
	},
	{
		'OXY2DEV/helpview.nvim',
		lazy = false,
	},
	{
		'echasnovski/mini.align',
		version = '*',
		opts = {},
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
		'weilbith/nvim-code-action-menu',
		cmd = 'CodeActionMenu',
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
