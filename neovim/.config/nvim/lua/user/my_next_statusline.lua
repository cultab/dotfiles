local M = {}

-- local sep = {
--     left = '',
--     right = ''
-- }
local sep = {
    left = '',
    right = ''
}

local greek_mode_map = {
    n = "Κανονικό",
    c = "Εντολής",
    i = "Εισαγωγής",
    V = "Επιλογής",
    R = "Αντικατάστασης",
    ["\22"] = "Επιλογής-Κουτί",
    niI = "Δε ξέρω μπρο είσαι μόνος σου ¯¯\\_(ツ)_/¯¯"
}

local short_mode_map = {
    n = "N",
    c = "C",
    i = "I",
    V = "V",
    R = "R",
    ["\22"] = "VB",
}

local function mode()
    local cur_mode = vim.api.nvim_get_mode().mode
    return short_mode_map[cur_mode]
end

local config = {
    options = {
        theme = "auto",
        component_separators = '⏽',
        section_separators = sep,
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
        globalstatus = true,
    },
    sections = {
        -- left sections
        lualine_a = { mode, 'branch' },
        lualine_b = { 'filetype' },
        lualine_c = { { 'filename', separator = { right = '', left = ''}, }, },
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
