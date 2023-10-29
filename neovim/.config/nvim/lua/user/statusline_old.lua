local M = {}

-- local sep = {
--     left = '',
--     right = ''
-- }
local sep = {
    left = '',
    right = ''
}

local config = {
    options = {
        theme = "this will get replaced",
        component_separators = '⏽',
        section_separators = sep , -- { left = '', right = '' },
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
        globalstatus = true,
    },
    sections = {
        -- left sections
        lualine_a = { { 'mode', separator = { left = sep.right }, right_padding = 2 }, },
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
        lualine_z = { { 'location', separator = { right = sep.left }, left_padding = 2 } },
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

M.config = config

return M
