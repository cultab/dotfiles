local zip = require'user.util'.zip
local db = require('dashboard')
vim.g.dashboard_default_executive = 'telescope'

function OpenConfig()
    vim.cmd "tabnew $MYVIMRC | tcd %:p:h"
    -- vim.cmd[[:next $MYVIMRC ~/.config/nvim/lua/user/*.lua]]
    -- vim.cmd [[:cd ~/.config/nvim]]
    -- vim.cmd[[:e $MYVIMRC]]
end

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

db.custom_header = {
[[                                                     ]],
[[                                     _               ]],
[[                                    |_|              ]],
[[ ______   ______   ______  __   __   _   ___________ ]],
[[|  __  | | ____ | |  __  | \ \ / /  | | |  __   __  |]],
[[| |  | | | _____| | |  | |  \ v /   | | | |  | |  | |]],
[[| |  | | | |____  | |__| |   \ /    | | | |  | |  | |]],
[[|_|  |_| |______| |______|    v     |_| |_|  |_|  |_|]],
}


db.custom_center = {
    {
        icon = " ",
        desc = "New file                         ",
        shortcut = "SPC n",
        action = "enew"
    },
    {
        icon = " ",
        desc = "Find file                        ",
        shortcut = "SPC f" ,
        action =  "Telescope find_files"
    },
    {
        icon = " ",
        desc = "Live grep                        ",
        shortcut = "SPC /" ,
        action =  "Telescope live_grep"
    },
    {
        icon = " ",
        desc = "Settings                         ",
        shortcut = "SPC o",
        action =  "lua OpenConfig()"
    },
    {
        icon = "x ",
        desc = "Exit Neovim                      ",
        shortcut = "q    ",
        action = "q"
    }
}

local hlgroups = {
    "DashboardHeader",
    "DashboardCenter",
    "DashboardShortCut",
    "DashboardFooter"
}

local linkgroups = {
    "Function",
    "String",
    "Number",
    "Operator"
}


-- fallback highlights if missing from the current colorscheme
for link, group in zip(linkgroups, hlgroups) do
    if vim.fn.hlexists(group) == 0 then
        vim.api.nvim_set_hl(0, group, { link = link })
    end
end
-- for i, group in ipairs(hlgroups) do
--     if vim.fn.hlexists(group) == 0 then
--         vim.api.nvim_set_hl(0, group, { link = linkgroups[i] })
--     end
-- end

vim.cmd[[
    augroup UserDashboard
        autocmd!
        autocmd User DashboardReady lua require("user.mappings").set_welcome_mappings()
    augroup end
]]
