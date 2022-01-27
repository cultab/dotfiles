function Reload_statusline(theme)
    require("plenary.reload").reload_module("lualine", true)
    require('lualine').setup{
        options = {
            theme = theme,
            component_separators = '⏽',
            section_separators = { left = '', right = '' },
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
end

local theme_name = "auto"

-- HACK: see https://github.com/hoob3rt/lualine.nvim/issues/276
if not LOAD_lualine then
    Reload_statusline(theme_name)
end
LOAD_lualine = true
