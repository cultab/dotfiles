-- vscode {{{
local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
}

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁", "  " }

	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end--}}}

function Reload_statusline(theme)
    require("plenary.reload").reload_module("lualine", true)
    if theme ~= "darkplus" then
        require('lualine').setup{
            options = {
                theme = theme,
                component_separators = '⏽',
                section_separators = { left = '', right = '' },
                disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
            },
            sections = {
                -- left sections
                lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 }, },
                lualine_b = { 'filename' },
                lualine_c = { 'branch' },
                -- right sections
                lualine_x = { {
                    'diagnostics',
                    sources = {'nvim_diagnostic'},
                    symbols = {
                        error = ' ',
                        warn = ' ',
                        info = ' ',
                        hint = ' ',
                    } }
                },
                lualine_y = { 'fileformat', 'filetype', 'progress' },
                lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
            },
            inactive_sections = {
                lualine_a = { 'filename' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' },
            },
            tabline = {},
            extensions = {},
        }
    else
        require('lualine').setup{
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { branch, diagnostics },
            lualine_b = { mode },
            lualine_c = {},
            lualine_x = { diff, spaces, "encoding", filetype },
            lualine_y = { location },
            lualine_z = { progress },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {},}
    end
end

local theme_name = "auto"

-- HACK: see https://github.com/hoob3rt/lualine.nvim/issues/276
if not LOAD_lualine then
    Reload_statusline(theme_name)
end
LOAD_lualine = true

