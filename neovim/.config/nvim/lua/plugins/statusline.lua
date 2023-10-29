function ReloadStatusline(theme)
    require("plenary.reload").reload_module("lualine", true)
    local statusline_config = {}
    if theme == "darkplus" or theme == "vscode" then
        statusline_config = require "user.statusline_vscode".config
    else
        -- statusline_config = require "user.my_statusline".config
        statusline_config = require "user.statusline_next".config
        -- statusline_config = require "user.statusline_evil".config
    end

    statusline_config.theme = theme

    require("lualine").setup(statusline_config)
end

local theme = "tokyonight"

vim.cmd [[
augroup AutoReload
autocmd ColorScheme * lua ReloadStatusline(theme)
augroup end
]]

LUALINE_LOADED = false

return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = false },
        config = function()

            -- HACK: see https://github.com/hoob3rt/lualine.nvim/issues/276
            if not LUALINE_LOADED then
                ReloadStatusline(theme)
                LUALINE_LOADED = true
            end
        end
    },
}
