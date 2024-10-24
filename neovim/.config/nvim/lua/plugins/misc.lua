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
		opts = { },
	},
	{
		'godlygeek/tabular',
		cmd = 'Tabularize',
	},
	{
		'lsvmello/elastictabstops.nvim',
		cmds = { 'ElasticTabstopsEnable', 'ElasticTabstopsDisable' },
		config = true,
	},
	{
		'junegunn/vim-easy-align',
		cmd = 'EasyAlign',
	},
	{
		'machakann/vim-sandwich',
		event = 'InsertEnter',
	},
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
			local ft = require 'Comment.ft'

			-- // for single line and /* */ for blocks
			-- in languages that both comment styles
			local langs = { 'c', 'cpp', 'cuda', 'javascript', 'typescript' }

			for _, lang in ipairs(langs) do
				ft.set(lang, { '//%s', '/*%s*/' }).set('conf', '#%s')
			end
		end,
		keys = { 'gcc', 'gc' }
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
		"ojroques/vim-oscyank",
	}
	-- {
	--     "m4xshen/hardtime.nvim",
	--     dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	--     opts = {}
	-- },
}
