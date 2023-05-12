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
    t = "Τερματικό",
    nt = "Κανονικό",
    ["\22"] = "Επιλογής-Κουτί",
    niI = "Δε ξέρω μπρο είσαι μόνος σου ¯¯\\_(ツ)_/¯¯"
}

local short_mode_map = {
    n = "N",
    c = "C",
    i = "I",
    V = "V",
    R = "R",
    t = "T",
    nt = "N",
    ["\22"] = "VB",
}

local function mode()
    local cur_mode = vim.api.nvim_get_mode().mode
    -- local text = greek_mode_map[cur_mode]
    local text = short_mode_map[cur_mode]
    if text == nil then
        return cur_mode
    end
    return text
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
        lualine_a = { mode },
        lualine_b = { 'branch' },
        lualine_c = { {
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
        -- right sections
        lualine_y = { 'filetype' },
        lualine_x = { 'searchcount' },
        lualine_z = { 'progress', 'location' },
    },
    tabline = {},
    extensions = {},
}

M.config = config

return M
