return {
	{
		'hrsh7th/nvim-cmp',
		config = function()
			local cmp = require 'cmp'
			cmp.setup {
				-- enabled = function()
				--     local context = require"cmp.config.context"
				--     if context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment") then
				--         return false
				--     else
				--         return true
				--     end
				-- end,
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = require('user.mappings').get_cmp_mappings(),
				sources = cmp.config.sources {
					{ name = 'luasnip' },
					{ name = 'nvim_lsp' },
					{ name = 'buffer', keyword_length = 2, max_item_count = 5 }, -- keep spam to a mininum
					-- { name = 'tmux',               keyword_length = 2, max_item_count = 5 },
					{ name = 'path' },
					-- { name = 'zsh' },
					-- { name = 'spell' },
					{ name = 'nvim_lua' },
				},
				formatting = {
					fields = { 'abbr', 'kind', 'menu' },
					format = require('lspkind').cmp_format {
						symbol_map = require('user.icons').lsp,
						mode = 'symbol_text',
						menu = {
							luasnip = '[Snippet]',
							otter = '[Otter]',
							conventionalcommits = '[git]',
							neorg = '[neorg]',
							nvim_lsp = '[LSP]',
							pandoc_references = '[Pandoc]',
							latex_symbols = '[LaTeX]',
							buffer = '[Buffer]',
							-- tmux = "[tmux]",
							path = '[Path]',
							-- zsh = "[zsh]",
							-- spell = "[spell]",
							nvim_lua = '[nvim]',
						},
					},
				},
				view = {
					experimental = {
						ghost_text = true,
					},
				},
			}
			cmp.setup.filetype({ 'md', 'rmd', 'qmd' }, {
				sources = {
					{ name = 'otter' },
					{ name = 'neorg' },
					{ name = 'pandoc_references' },
					{ name = 'latex_symbols' },
				},
			})
			cmp.setup.filetype({ 'gitcommit' }, {
				sources = {
					{ name = 'conventionalcommits' },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' },
				}, {
					{ name = 'cmdline', ignore_cmds = {} }, -- keyword_pattern=[=[[^[:blank:]\!]*]=]
				}),
			})

			cmp.setup.cmdline('/', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = 'buffer' } },
			})

			local autopairs = require 'nvim-autopairs.completion.cmp'
			cmp.event:on('confirm_done', autopairs.on_confirm_done { map_char = { tex = '' } })
		end,
		event = { 'InsertEnter', 'CmdlineEnter' },
		dependencies = {
			'saadparwaiz1/cmp_luasnip',
			{
				'L3MON4D3/LuaSnip',
				dependencies = { 'rafamadriz/friendly-snippets' },
				config = function()
					require('luasnip.loaders.from_vscode').lazy_load()
				end,
			},
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'f3fora/cmp-spell',
			{
				'jc-doyle/cmp-pandoc-references',
			},
			{
				'kdheepak/cmp-latex-symbols',
			},
			'andersevenrud/cmp-tmux',
			{
				'tamago324/cmp-zsh',
				opts = {
					zshrc = true, -- Source the zshrc (adding all custom completions). default: false
					filetypes = { 'deoledit', 'zsh', 'bash', 'fish', 'sh' }, -- Filetypes to enable cmp_zsh source. default: {"*"}
				},
			},
			'cultab/cmp-conventionalcommits', -- my fork with less features :^)
		},
	},
	{
		'ray-x/lsp_signature.nvim',
		version = false,
		event = 'VeryLazy',
		opts = {},
		config = function(_, opts)
			require('lsp_signature').setup(opts)
		end,
	},
}
