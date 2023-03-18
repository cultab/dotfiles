function ReloadStatusline(theme)
    require("plenary.reload").reload_module("lualine", true)
    local statusline_config = {}
    if theme == "darkplus" or theme == "vscode" then
        statusline_config = require "user.vscode_statusline".config
    else
        -- statusline_config = require "user.my_statusline".config
        statusline_config = require "user.my_next_statusline".config
        -- statusline_config = require "user.evil_statusline".config
    end

    statusline_config.theme = theme

    require("lualine").setup(statusline_config)
end

local theme = "catppuccin"

-- HACK: see https://github.com/hoob3rt/lualine.nvim/issues/276
if not LUALINE_LOADED then
    ReloadStatusline(theme)
    LUALINE_LOADED = true
end

vim.cmd [[
augroup AutoReload
    autocmd ColorScheme * lua ReloadStatusline(theme)
augroup end
]]
