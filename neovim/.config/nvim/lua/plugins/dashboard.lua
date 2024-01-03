-- Custom headers: {{{
-- db.custom_header = {
-- [[                                      __              ]],
-- [[                                     |  \             ]],
-- [[ _______   ______   ______  __     __ \▓▓______ ____  ]],
-- [[|       \ /      \ /      \|  \   /  \  \      \    \ ]],
-- [[| ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓\ /  ▓▓ ▓▓ ▓▓▓▓▓▓\▓▓▓▓\]],
-- [[| ▓▓  | ▓▓ ▓▓    ▓▓ ▓▓  | ▓▓ \▓▓\  ▓▓| ▓▓ ▓▓ | ▓▓ | ▓▓]],
-- [[| ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓__/ ▓▓  \▓▓ ▓▓ | ▓▓ ▓▓ | ▓▓ | ▓▓]],
-- [[| ▓▓  | ▓▓\▓▓     \\▓▓    ▓▓   \▓▓▓  | ▓▓ ▓▓ | ▓▓ | ▓▓]],
-- [[ \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓     \▓    \▓▓\▓▓  \▓▓  \▓▓]],
-- [[                                                      ]],
-- [[                                                      ]],
-- [[                                                      ]],
-- }

-- db.custom_header = {
-- [[                                        _                     ]],
-- [[                  _                    | |                    ]],
-- [[                 |_|                   | |                    ]],
-- [[ ______  __   __  _   ___________      | |  _    _   ______   ]],
-- [[|  __  | \ \ / / | | |  __   __  |     | | | |  | | |  __  |  ]],
-- [[| |  | |  \ v /  | | | |  | |  | |     | | | |  | | | |  | |  ]],
-- [[| |  | |   \ /   | | | |  | |  | |  _  | | | |__| | | |__| |_ ]],
-- [[|_|  |_|    v    |_| |_|  |_|  |_| |_| |_| |______| |________|]],
-- }
-- }}}
--
local zip = require 'user.util'.zip
local icons = require 'user.icons'
vim.g.dashboard_default_executive = 'telescope'

function OpenConfig()
    -- vim.cmd "tabnew $MYVIMRC | tcd %:p:h"
    local vimrc = vim.fn.expand("$MYVIMRC")
    vim.cmd.cd(vim.fs.dirname(vimrc))
    vim.cmd.edit(vimrc) -- HACK: yes twice
    vim.cmd.edit(vimrc)
end

local hlgroups = {
    "DashboardHeader",
    "DashboardFooter",
    "DashboardDesc",
    "DashboardKey",
    "DashboardIcon",
    "DashboardShortCut"
}

local linkgroups = {
    "Function",
    "Number",
    "Identifier",
    "Operator",
    "Identifier",
    "Function",
}


function DashboardFallback()
    -- fallback highlights if missing from the current colorscheme
    for link, group in zip(linkgroups, hlgroups) do
        if vim.fn.hlexists(group) == 0 then
            vim.api.nvim_set_hl(0, group, { link = link })
        end
    end
end

vim.cmd [[
augroup UserDashboard
autocmd!
autocmd FileType dashboard lua require("user.mappings").set_welcome_mappings()
autocmd ColorScheme * lua DashboardFallback()
augroup end
]]

return {
    {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        opts = {
            theme = 'doom',
            hide = { statusline = false, tabline = false, winbar = false },
            config = {
                header = {
                    [[                                                     ]],
                    [[                                     _               ]],
                    [[                                    |_|              ]],
                    [[ ______   ______   ______  __   __   _   ___________ ]],
                    [[|  __  | | ____ | |  __  | \ \ / /  | | |  __   __  |]],
                    [[| |  | | | _____| | |  | |  \ v /   | | | |  | |  | |]],
                    [[| |  | | | |____  | |__| |   \ /    | | | |  | |  | |]],
                    [[|_|  |_| |______| |______|    v     |_| |_|  |_|  |_|]],
                    [[                                                     ]],
                },
                center = {
                    {
                        icon = icons.file.normal,
                        desc = "New file                         ",
                        key = "SPC n",
                        action = "enew"
                    },
                    {
                        icon = icons.misc.search,
                        desc = "Find file                        ",
                        key = "SPC f",
                        action = "Telescope find_files"
                    },
                    {
                        icon = icons.misc.grep,
                        desc = "Live grep                        ",
                        key = "SPC /",
                        action = "Telescope live_grep"
                    },
                    {
                        icon = icons.misc.settings,
                        desc = "Settings                         ",
                        key = "SPC o",
                        action = "lua OpenConfig()"
                    },
                    {
                        icon = icons.misc.close,
                        desc = "Exit Neovim                      ",
                        key = "q",
                        action = "q"
                    }
                    -- {
                    --     icon = 'test',
                    --     icon_hl = 'group',
                    --     desc = 'description',
                    --     desc_hl = 'group',
                    --     key = 'shortcut key in dashboard buffer not keymap !!',
                    --     key_hl = 'group',
                    --     action = '',
                    -- },
                },
                -- footer = {},
            }
        }
    }
}
