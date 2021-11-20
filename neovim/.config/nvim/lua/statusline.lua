-- HACK: see https://github.com/hoob3rt/lualine.nvim/issues/276
if not LOAD_lualine then
    require('lualine').setup{
        options = { theme = "auto" }
    }
end

LOAD_lualine = true

function Reload_statusline(theme)
    require("plenary.reload").reload_module("lualine", true)
    require('lualine').setup{
        options = { theme = theme }
    }
end

