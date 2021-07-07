local o = vim.o
local g = vim.g

o.termguicolors = true

require("colorizer").setup()

function TestLongName()
    print("lel")
end

g.dashboard_custom_header = {
[[                                                     ]],
[[                                     _               ]],
[[                                    |_|              ]],
[[ ______   ______   ______  __   __   _   ___________ ]],
[[|  __  | | ____ | |  __  | \ \ / /  | | |  __   __  |]],
[[| |  | | | _____| | |  | |  \ v /   | | | |  | |  | |]],
[[| |  | | | |____  | |__| |   \ /    | | | |  | |  | |]],
[[|_|  |_| |______| |______|    v     |_| |_|  |_|  |_|]],
}

-- g.dashboard_preview_command = 'cat'
-- g.dashboard_preview_pipeline = 'lolcat -h 0.5 -v -0.1'
-- g.dashboard_preview_file = '~/.config/nvim/logo.cat'
-- g.dashboard_preview_file_height = 8
-- g.dashboard_preview_file_width = 56

 -- used as separator for windows
o.fillchars = "vert:│"
o.listchars = "nbsp:␣,trail:·,extends:>,precedes:<,tab:  "
-- for tab : ┊
o.list = true
g.indent_blankline_enabled = true
g.indent_blankline_char = '│' -- '┊'
g.indent_blankline_filetype_exclude = {'help', 'terminal', 'dashboard'}
g.indent_blankline_use_treesitter = true
-- HACK: see: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59#issuecomment-806398054
vim.wo.colorcolumn = "99999"

o.number = true
o.relativenumber = false
o.signcolumn = 'yes:2'
o.foldmethod = 'marker'

o.scrolloff=3 -- keep lines above and below cursor
o.sidescroll=6
o.showmode = false
o.showcmd = true

-- o.colorcolumn = "80"
o.background = "dark"
o.cursorline = true -- highlight current line

-- Colorscheme Options
--
local sidebars = { "qf", "vista_kind", "terminal", "packer" }
local lualine_bold = true
local italic_functions = true
local hide_inactive_status = true

g.palenight_terminal_italics = true
g.solarized_extra_hi_groups = true
-- g.lightline#colorscheme#github_light#faithful = 0
g.ayucolor = "dark"
g.tokyonight_style = "night"

-- Tokyonight {{{
g.tokyonight_style = "night"
g.tokyonight_italic_functions = italic_functions
g.tokyonight_sidebars = sidebars
g.tokyonight_lualine_bold = lualine_bold
g.tokyonight_hide_inactive_statusline = hide_inactive_status
--}}}
-- Gruvbox {{{
g.gruvbox_italic_functions = italic_functions
g.gruvbox_sidebars = sidebars
g.gruvbox_lualine_bold = lualine_bold
g.gruvbox_hide_inactive_statusline = hide_inactive_status
--}}}

vim.cmd "colorscheme gruvbox-flat"

-- HACK: see https://github.com/hoob3rt/lualine.nvim/issues/276
if not LOAD_lualine then
    require('lualine').setup{
    options = { theme = "gruvbox-flat" }
    }
end

LOAD_lualine = true
