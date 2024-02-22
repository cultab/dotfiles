local icons = require 'user.icons'

return {
	{
		'williamboman/mason.nvim',
		version = '*',
		cmd = { 'Mason' },
		config = function()
			require('mason').setup {
				ui = {
					icons = {
						package_installed = icons.misc.circle_check,
						package_pending = icons.misc.circle_dot,
						package_uninstalled = icons.misc.dead,
					},
				},
			}
		end,
	},
	{
		'williamboman/mason-lspconfig.nvim',
		lazy = true,
		opts = {},
	},
	{
		'neovim/nvim-lspconfig',
		version = '*',
	},
	'folke/lsp-colors.nvim',
}
