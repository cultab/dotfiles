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
        -- component_separators = '',
        component_separators = '⏽',
        section_separators = sep, -- { left = '', right = '' },
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
        globalstatus = true,
    },
    sections = {
        -- left sections
        lualine_a = { { 'mode', fmt = function(str) return str:sub(1,1) end } },
        lualine_b = { { 'branch' } },
        lualine_c = { { 'filetype', separator = { right = '', left = ''}, }, 'filename' },
        -- right sections
        lualine_z = { 'location', 'progress' },
        lualine_x = { { 'searchcount' } },
        lualine_y = { {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = {
                error = ' ',
                warn  = ' ',
                info  = ' ',
                hint  = ' ',
            }
        }
        },
    },
    tabline = {},
    extensions = {},
}

M.config = config

return M
