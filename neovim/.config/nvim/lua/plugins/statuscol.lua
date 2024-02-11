local icons = require 'user.icons'
local git_sign_icon = icons.line.left_medium
return {
	{
		'lewis6991/gitsigns.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			-- signcolumn = false,
			numhl = true,
			signs = {
				add          = { text = git_sign_icon },
				change       = { text = git_sign_icon },
				delete       = { text = git_sign_icon },
				topdelete    = { text = git_sign_icon },
				changedelete = { text = git_sign_icon },
				untracked    = { text = git_sign_icon },
			},
		},
	},
	{
		'luukvbaal/statuscol.nvim',
		branch = "0.10",
		config = function()
			local builtin = require 'statuscol.builtin'
			require 'statuscol'.setup {
				-- setopt = true,
				relculright = true,
				clickhandlers = {
					Lnum = builtin.gitsigns_click,
				},
				segments = {
					{
						sign = {
							name = { ".*" },
							namespace = { ".*" },
							-- namespace = { ".*diagnostic.*" },
							-- name = { "todo%-sign.*" }, -- WARN: escape the dash `-`
							maxwidth = 1,
							colwidth = 2,
							auto = false,
							wrap = true,
						},
					},
					{
						text = { builtin.lnumfunc, " " },
						colwidth = 1,
						click = "v:lua.ScLa",
					},
					{
						sign = {
							name = { "GitSigns*" },
							namespace = { "gitsigns" },
							colwidth = 1,
							fillchar = git_sign_icon,
							fillcharhl = "Nrline"
						},
						click = "v:lua.ScSa"
					},
					{
						text = { builtin.foldfunc, " " },
						hl = "FoldColumn",
						wrap = true,
						colwidth = 1,
						click = "v:lua.ScFa"
					},
				},
			}
		end
	}
}
