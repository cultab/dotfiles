local M = {}
local zip = require 'user.util'.zip
vim.g.dashboard_default_executive = 'telescope'

function OpenConfig()
    -- vim.cmd "tabnew $MYVIMRC | tcd %:p:h"
    local vimrc = vim.fn.expand("$MYVIMRC")
    vim.cmd.cd(vim.fs.dirname(vimrc))
    vim.cmd.edit(vimrc)
end


M.config = {
    hide = { statusline = false, tabline = false, winbar = false },
    theme = 'doom',
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
            -- {
            --     icon = 'test',
            --     icon_hl = 'group',
            --     desc = 'description',
            --     desc_hl = 'group',
            --     key = 'shortcut key in dashboard buffer not keymap !!',
            --     key_hl = 'group',
            --     action = '',
            -- },
            {
                icon = " ",
                desc = "New file                         ",
                key = "SPC n",
                action = "enew"
            },
            {
                icon = " ",
                desc = "Find file                        ",
                key = "SPC f",
                action = "Telescope find_files"
            },
            {
                icon = " ",
                desc = "Live grep                        ",
                key = "SPC /",
                action = "Telescope live_grep"
            },
            {
                icon = " ",
                desc = "Settings                         ",
                key = "SPC o",
                action = "lua OpenConfig()"
            },
            {
                icon = "x ",
                desc = "Exit Neovim                      ",
                key = "q    ",
                action = "q"
            }
        },
        -- footer = {},
    }
}


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


-- fallback highlights if missing from the current colorscheme
for link, group in zip(linkgroups, hlgroups) do
    if vim.fn.hlexists(group) == 0 then
        vim.api.nvim_set_hl(0, group, { link = link })
    end
end

vim.cmd [[
    augroup UserDashboard
        autocmd!
        autocmd FileType dashboard lua require("user.mappings").set_welcome_mappings()
    augroup end
]]

return M

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
