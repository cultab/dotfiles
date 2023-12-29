local M = {}

local function isWSL()
    return wezterm.target_triple == 'x86_64-pc-windows-msvc'
end

local fonts = {
    cozette = {
        { family = "CozetteHiDpi", },
        { family = "CozetteHiDpi", assume_emoji_presentation = true }
    }
}

M.pick = function(name, size)

end


return M
