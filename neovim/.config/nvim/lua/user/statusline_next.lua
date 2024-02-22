local M = {}

local icons = require 'user.icons'
-- local sep = {
-- 	left = '',
-- 	right = '',
-- }
local sep = {
    left = '',
    right = ''
}

local greek_modemap = {
	n = 'Κανονικό',
	nt = 'Κανονικό-Τερματικό',
	c = 'Εντολής',
	i = 'Εισαγωγής',
	v = 'Επιλογής',
	V = 'Επιλογής-Γραμμή',
	['^V'] = 'Επιλογής-Κουτί',
	R = 'Αντικατάστασης',
	t = 'Τερματικό',
	niI = 'Δε ξέρω βρο είσαι μόνος σου ¯¯\\_(ツ)_/¯¯',
}

local greek_possesive_modemap = {
	n = 'Κανονικού',
	nt = 'Κανονικού-Τερματικού',
	c = 'Εντολής',
	i = 'Εισαγωγής',
	v = 'Επιλογής',
	V = 'Επιλογής-Γραμμής',
	['^V'] = 'Επιλογής-Κουτιού',
	R = 'Αντικατάστασης',
	t = 'Τερματικού',
	niI = 'Δε ξέρω βρο είσαι μόνος σου ¯¯\\_(ツ)_/¯¯',
}

local short_modemap = {
	n = 'N',
	nt = 'N',
	c = 'C',
	i = 'I',
	v = 'V',
	V = 'VL',
	['^V'] = 'VB',
	R = 'R',
	t = 'T',
}

local long_modemap = {
	n = 'Normal',
	nt = 'Normal',
	c = 'Command',
	i = 'Insert',
	v = 'Visual',
	V = 'Visual Line',
	['^V'] = 'Visual Block',
	R = 'Replace',
	t = 'Terminal',
}

local function mode_with_modemap(map)
	return function()
		local cur_mode = vim.api.nvim_get_mode().mode
		local text = map[cur_mode]
		if text == nil then
			return cur_mode
		end
		return text --.. "|" .. cur_mode .. "|"
	end
end

local gr_mode = { mode_with_modemap(greek_modemap), icon = icons.misc.neovim }
local short_mode = { mode_with_modemap(short_modemap), icon = icons.misc.vim }
local long_mode = { mode_with_modemap(long_modemap) }

M.config = {
	options = {
		theme = 'auto',
		component_separators = icons.line.short,
		section_separators = sep,
		disabled_filetypes = { 'alpha', 'dashboard', 'NvimTree', 'Outline' },
		globalstatus = true,
	},
	sections = {
		-- left sections
		lualine_a = { short_mode },
		lualine_b = { 'branch', 'diff' },
		lualine_c = { 'man', 'mason', 'lazy', 'quickfix' },
		-- right sections
		lualine_y = {
			'filetype',
			{
				'diagnostics',
				sources = { 'nvim_diagnostic' },
				symbols = {
					error = icons.diagnostic.error,
					warn = icons.diagnostic.warn,
					info = icons.diagnostic.info,
					hint = icons.diagnostic.hint,
				},
			},
		},
		lualine_x = { 'searchcount' },
		lualine_z = { 'progress', 'location' },
	},
	tabline = {},
	extensions = { 'mason', 'lazy', 'quickfix', 'man' },
}

return M
