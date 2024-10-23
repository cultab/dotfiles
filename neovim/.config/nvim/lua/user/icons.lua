local cozette = false

local lsp_icons = {
	cozette = {
		Text = '󰉿', --   󰉿
		Method = '∈', -- ?
		Function = '',
		Constructor = '',
		Field = '',
		Variable = '⍺',
		Class = '', -- 
		Interface = '⌘', -- 
		Module = '',
		Property = '∷', -- ?
		Unit = '€', --  ruler?
		Value = '',
		Enum = '',
		Keyword = '',
		Snippet = '謹',
		Color = '',
		File = '',
		Reference = '⇒', -- ?
		Folder = '',
		EnumMember = '',
		Constant = '',
		Struct = '󰙅',
		Event = '',
		Operator = '±',
		TypeParameter = '∀',
	},
	nerd = {
		Text = '󰉿',
		Method = '∈',
		Function = '󰊕',
		Constructor = '',
		Field = '',
		Variable = '⍺',
		Class = '󰅩',
		Interface = '⌘',
		Module = '󰆧',
		Property = '∷',
		Unit = '€',
		Value = '󰎠',
		Enum = '',
		Keyword = '󰌋',
		Snippet = '󰗀',
		Color = '󰏘',
		File = '󰈙',
		Reference = '⇒',
		Folder = '󰉋',
		EnumMember = '',
		Constant = '󰏿',
		Struct = '󰙅',
		Event = '',
		Operator = '±',
		TypeParameter = '∀',
	},
	vscode = {
		Text = '  ',
		Method = '  ',
		Function = '  ',
		Constructor = '  ',
		Field = '  ',
		Variable = '  ',
		Class = '  ',
		Interface = '  ',
		Module = '  ',
		Property = '  ',
		Unit = '  ',
		Value = '  ',
		Enum = '  ',
		Keyword = '  ',
		Snippet = '  ',
		Color = '  ',
		File = '  ',
		Reference = '  ',
		Folder = '  ',
		EnumMember = '  ',
		Constant = '  ',
		Struct = '  ',
		Event = '  ',
		Operator = '  ',
		TypeParameter = '  ',
	},
}

local borders = {
	square = {
		top_left = '┌',
		top_right = '┐',
		bottom_left = '└',
		bottom_right = '┘',
		horizontal = '─',
		vertical = '│',
	},
	round = {
		top_left = '╭',
		top_right = '╮',
		bottom_left = '╰',
		bottom_right = '╯',
		horizontal = '─',
		vertical = '│',
	},
}

local separators = {
	triangle = {
		right = '',
		left = '',
	},
}

local diffs = {
	outline = {
		added = ' ',
		modified = ' ',
		removed = ' ',
	},
	bold = {
		added = ' ',
		modified = '  ',
		removed = ' ',
	},
	cozette = {
		added = ' ',
		removed = ' ',
		modified = ' ',
	},
}

local icons = {
	separator = separators.triangle,
	diagnostic = {
		error = ' ',
		warn = ' ',
		info = ' ',
		hint = '󰌵 ',
	},
	fold = { -- WARN: single char wide
		close = '›',
		open = '⌵',
		sep = ' ',
		-- close = "",
		-- open = "",
	},
	line = {
		short = '⏽',
		center_dotted = '┊',
		center_line = '│',
		left_thin = '▏',
		left_medium = '▎',
		left_thick = '▊',
		right_thin = '▕',
	},
	misc = {
		neovim = ' ',
		vim = ' ',
		check = ' ',
		close = '✕ ',
		grep = ' ',
		right_arrow = '➜',
		search = '⌕ ', -- 󰃬
		settings = ' ',
		settings2 = ' ',
		term = ' ',
		x = '✗',
		circle_dot = ' ',
		circle_check = '󰄳 ',
		dead = '󰚌 ',
		folder = '󰉋 ',
		dashboard = '󰕮 '
	},
	listchars = {
		nbsp = '␣',
		trail = '·',
		-- tab = '   ',
		tab = '▏  ',
		eol = '↲ ',
	},
	file = {
		normal = ' ',
		modilied = '●',
		pinned = '󰐃 ',
	},
	git = {
		branch = ' ',
	},
	diff = diffs.bold,
	progress = { '██', '▇▇', '▆▆', '▅▅', '▄▄', '▃▃', '▂▂', '▁▁', '  ' },
	border = borders.round,
	lazy = {
		cmd = ' ',
		config = '',
		event = '',
		ft = ' ',
		init = ' ',
		import = ' ',
		keys = ' ',
		lazy = '󰒲 ',
		loaded = '●',
		not_loaded = '○',
		plugin = ' ',
		runtime = ' ',
		require = '󰢱 ',
		source = ' ',
		start = '⏵',
		task = '✔ ',
		list = { '●', '➜', '✭', '‒' },
	},
	lsp = lsp_icons.nerd,
}

if cozette then
	icons.lsp = lsp_icons.cozette
	icons.diff = diffs.cozette
end

return icons
