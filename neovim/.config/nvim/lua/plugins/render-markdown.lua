return {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		enabled = true,
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		ft = { 'markdown', 'rmd', 'quarto' },
		opts = {
			anti_conceal = {
				enabled = true,
			},
			completions = { lsp = { enabled = true } },
			-- render_modes = true,
		},
	},
	{ 'OXY2DEV/markview.nvim', enabled = false },
}
