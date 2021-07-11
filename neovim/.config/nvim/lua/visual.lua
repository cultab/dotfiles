function TestLongName()
    print("lel")
end

O.termguicolors = true

cmd [[highlight link CompeDocumentation Normal]]

require("colorizer").setup()
require('todo-comments').setup()

--{{{ lsp
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local icons = {--{{{
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Enum = "了 ",
    EnumMember = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = "ﰮ ",
    Keyword = " ",
    Method = "ƒ ",
    Module = " ",
    Property = " ",
    Snippet = "﬌ ",
    Struct = " ",
    Text = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
}--}}}

local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
    kinds[i] = icons[kind] or kind
end

--}}}

G.dashboard_custom_header = {
[[                                                     ]],
[[                                     _               ]],
[[                                    |_|              ]],
[[ ______   ______   ______  __   __   _   ___________ ]],
[[|  __  | | ____ | |  __  | \ \ / /  | | |  __   __  |]],
[[| |  | | | _____| | |  | |  \ v /   | | | |  | |  | |]],
[[| |  | | | |____  | |__| |   \ /    | | | |  | |  | |]],
[[|_|  |_| |______| |______|    v     |_| |_|  |_|  |_|]],
}

G.dashboard_custom_header = {
[[                                      __              ]],
[[                                     |  \             ]],
[[ _______   ______   ______  __     __ \▓▓______ ____  ]],
[[|       \ /      \ /      \|  \   /  \  \      \    \ ]],
[[| ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓\ /  ▓▓ ▓▓ ▓▓▓▓▓▓\▓▓▓▓\]],
[[| ▓▓  | ▓▓ ▓▓    ▓▓ ▓▓  | ▓▓ \▓▓\  ▓▓| ▓▓ ▓▓ | ▓▓ | ▓▓]],
[[| ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓__/ ▓▓  \▓▓ ▓▓ | ▓▓ ▓▓ | ▓▓ | ▓▓]],
[[| ▓▓  | ▓▓\▓▓     \\▓▓    ▓▓   \▓▓▓  | ▓▓ ▓▓ | ▓▓ | ▓▓]],
[[ \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓     \▓    \▓▓\▓▓  \▓▓  \▓▓]],
[[                                                      ]],
[[                                                      ]],
[[                                                      ]],
}

G.dashboard_default_executive = 'telescope'
-- g.dashboard_preview_command = 'cat'
-- g.dashboard_preview_pipeline = 'lolcat -h 0.5 -v -0.1'
-- g.dashboard_preview_file = '~/.config/nvim/logo.cat'
-- g.dashboard_preview_file_height = 8
-- g.dashboard_preview_file_width = 56

 -- used as separator for windows
O.fillchars = "vert:│"
O.listchars = "nbsp:␣,trail:·,extends:>,precedes:<,tab:  "
-- for tab : ┊
O.list = true
G.indent_blankline_enabled = true
G.indent_blankline_char = '│' -- '┊'
G.indent_blankline_filetype_exclude = {'help', 'terminal', 'dashboard'}
G.indent_blankline_use_treesitter = true
G.indent_blankline_show_current_context = true
G.indent_blankline_context_patterns = { 'class', 'function', 'method', '^if', '^while', '^for', '^table', 'block', 'arguments', 'loop' }
--  HACK: see: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59#issuecomment-806398054
vim.wo.colorcolumn = "99999"

O.number = true
O.relativenumber = false
O.signcolumn = 'auto:2-4'
O.foldmethod = 'marker'

O.scrolloff=3 -- keep lines above and below cursor
O.sidescroll=6
O.showmode = false
O.showcmd = true

-- o.colorcolumn = "80"
O.background = "dark"
O.cursorline = true -- highlight current line

-- Colorscheme Options
--
local sidebars = { "qf", "vista_kind", "terminal", "packer" }
local lualine_bold = true
local italic_functions = true
local hide_inactive_status = true

G.palenight_terminal_italics = true
G.solarized_extra_hi_groups = true
-- g.lightline#colorscheme#github_light#faithful = 0
G.ayucolor = "dark"
G.tokyonight_style = "night"

-- Tokyonight {{{
G.tokyonight_style = "night"
G.tokyonight_italic_functions = italic_functions
G.tokyonight_sidebars = sidebars
G.tokyonight_lualine_bold = lualine_bold
G.tokyonight_hide_inactive_statusline = hide_inactive_status
--}}}
-- Gruvbox {{{
G.gruvbox_italic_functions = italic_functions
G.gruvbox_sidebars = sidebars
G.gruvbox_lualine_bold = lualine_bold
G.gruvbox_hide_inactive_statusline = hide_inactive_status
--}}}

cmd "colorscheme gruvbox-flat"

-- HACK: see https://github.com/hoob3rt/lualine.nvim/issues/276
if not LOAD_lualine then
    require('lualine').setup{
    options = { theme = "gruvbox-flat" }
    }
end

LOAD_lualine = true

cmd [[
augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]
