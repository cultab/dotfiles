-- local skip = function(plugin)
-- 	return nil
-- end

local lazy = function(plug)
	local plugin = {}
	if type(plug) == 'string' then
		table.insert(plugin, plug)
	else
		plugin = plug
	end

	plugin.lazy = true
	plugin.cmd = 'LoadColorschemes'

	return plugin
end

local colors = {
	'tjdevries/colorbuddy.nvim',
	'rktjmp/lush.nvim',
	lazy 'diegoulloao/neofusion.nvim',
	lazy { 'UniWa-Community/uniwa.nvim', dev = true },
	'rktjmp/shipwright.nvim',
	lazy {
		'catppuccin/nvim',
		config = function()
			local cat = require 'catppuccin'
			cat.setup {
				transparency = false,
				integrations = {
					telescope = true,
					gitsigns = true,
					which_key = true,
					indent_blankline = {
						enabled = true,
						colored_indent_levels = true,
					},
					barbar = true,
					markdown = true,
				},
			}
		end,
	},
	{
		'rktjmp/lush.nvim',
		version = false,
	},
	-- prot
	lazy 'https://gitlab.com/protesilaos/tempus-themes-vim.git',
	-- first class light
	lazy 'romgrk/github-light.vim',
	lazy 'lourenci/github-colors',
	lazy 'sainnhe/everforest',
	-- oldvim
	lazy 'shaunsingh/solarized.nvim',
	lazy 'Reewr/vim-monokai-phoenix',
	lazy 'cultab/potato-colors',
	-- skip 'lifepillar/vim-solarized8',
	-- skip 'lifepillar/vim-gruvbox8',
	-- low contrast
	lazy 'oahlen/iceberg.nvim',
	lazy '2nthony/vitesse.nvim',
	-- high constrast
	lazy 'bluz71/vim-moonfly-colors',
	lazy 'ntk148v/vim-horizon',
	lazy 'zootedb0t/citruszest.nvim',
	lazy 'nyoom-engineering/oxocarbon.nvim',
	lazy 'Shatur/neovim-ayu',
	-- :set notermguicolors
	lazy 'noahfrederick/vim-noctu',
	lazy 'jsit/disco.vim',
	lazy 'deviantfero/wpgtk.vim',
	-- gruvbox
	lazy 'eddyekofo94/gruvbox-flat.nvim',
	lazy {
		'npxbr/gruvbox.nvim',
	},
	-- vscode
	lazy 'Mofiqul/vscode.nvim',
	lazy 'LunarVim/darkplus.nvim',
	-- one dark family
	lazy 'romgrk/doom-one.vim',
	lazy { 'joshdick/onedark.vim', branch = 'main' },
	lazy {
		'folke/tokyonight.nvim',
		opts = {
			-- NOTE: with some fonts, bold is an entirely different looking font, so it can be jarring to see the glyphs change shape
			on_highlights = function(highlights, _--[[colors]])
				highlights.GitSignsAdd.bold = true
				highlights.GitSignsChange.bold = true
				highlights.GitSignsDelete.bold = true
			end,
		},
	},
	lazy {
		'olimorris/onedarkpro.nvim',
		dependencies = { 'rktjmp/lush.nvim' },
		branch = 'main',
	},
}

return colors
