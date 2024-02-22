local icons = require 'user.icons'
return {
	'lukas-reineke/indent-blankline.nvim',
	config = function()
		require('ibl').setup {
			indent = {
				char = icons.line.left_thin,
				-- highlight = { "Function", "Label" }
			},
			scope = {
				enabled = false,
				show_start = false,
				show_end = false,
				highlight = { 'Label' },
			},
			exclude = {
				filetypes = {
					'lspinfo',
					'help',
					'terminal',
					'dashboard',
					'checkhealth',
					'man',
					'gitcommit',
					'TelescopePrompt',
					'TelescopeResults',
				},
			},
		}
		-- local hooks = require "ibl.hooks"
		-- hooks.register(
		--     hooks.builtin.hide_first_space_indent_level
		-- )
	end,
}
