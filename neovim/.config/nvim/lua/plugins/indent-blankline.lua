local icons = require 'user.icons'
return {
	'lukas-reineke/indent-blankline.nvim',
	config = function()
		local char = icons.line.left_thin
		require('ibl').setup {
			indent = {
				char = char,
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
		local hooks = require 'ibl.hooks'
		hooks.register(hooks.type.VIRTUAL_TEXT, function(_, _, _, virt_text)
			if virt_text[1] and virt_text[1][1] == char then
				virt_text[1] = { ' ', { '@ibl.whitespace.char.1' } }
			end

			return virt_text
		end)
		-- hooks.register(
		--     hooks.builtin.hide_first_space_indent_level
		-- )
	end,
}
