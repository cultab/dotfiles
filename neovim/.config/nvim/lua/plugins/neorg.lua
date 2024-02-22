return {
	{
		'nvim-neorg/neorg',
		commit = 'f296a22',
		dependencies = 'nvim-lua/plenary.nvim',
		ft = 'norg',
		opts = {
			load = {
				['core.concealer'] = {
					config = {
						folds = false,
					},
				},
				['core.esupports.metagen'] = {
					config = {
						type = 'auto',
					},
				},
				['core.completion'] = {
					config = {
						engine = 'nvim-cmp',
					},
				},
				['core.keybinds'] = {
					config = {
						default_keybinds = true,
						norg_leader = '<Leader>m',
					},
				},
				['core.dirman'] = {
					config = {
						workspaces = {
							default = '~/.neorg',
						},
					},
				},
				['core.export'] = {},
			},
		},
	},
}
