vim.g.dashboard_default_executive = 'telescope'
-- vim.g.dashboard_custom_header = {
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

-- vim.g.dashboard_custom_header = {
-- [[                                                     ]],
-- [[                                     _               ]],
-- [[                                    |_|              ]],
-- [[ ______   ______   ______  __   __   _   ___________ ]],
-- [[|  __  | | ____ | |  __  | \ \ / /  | | |  __   __  |]],
-- [[| |  | | | _____| | |  | |  \ v /   | | | |  | |  | |]],
-- [[| |  | | | |____  | |__| |   \ /    | | | |  | |  | |]],
-- [[|_|  |_| |______| |______|    v     |_| |_|  |_|  |_|]],
-- }

vim.g.dashboard_custom_header = {
[[                                        _                     ]],
[[                  _                    | |                    ]],
[[                 |_|                   | |                    ]],
[[ ______  __   __  _   ___________      | |  _    _   ______   ]],
[[|  __  | \ \ / / | | |  __   __  |     | | | |  | | |  __  |  ]],
[[| |  | |  \ v /  | | | |  | |  | |     | | | |  | | | |  | |  ]],
[[| |  | |   \ /   | | | |  | |  | |  _  | | | |__| | | |__| |_ ]],
[[|_|  |_|    v    |_| |_|  |_|  |_| |_| |_| |______| |________|]],
}

vim.g.dashboard_custom_section = {
    -- _1find_projects = {
    --     description = { " Recently opened projects      SPC f p" },
    --     command =  "Telescope projects"
    -- },
    _2find_history = {
        description = { "ﭯ Recently opened files         SPC f h" },
        command =  ":DashboardFindHistory"
    },
    _3new_file = {
        description = { " New file                      SPC c n" },
        command = ":DashboardNewFile"
    },
    _4find_file = {
        description = { " Find file                     SPC f f" },
        command =  ":Telescope find_files"
    },
    -- _5change_colorscheme = {
    --     description = { " Change Colorscheme            SPC t c" },
    --     command = ":DashboardChangeColorscheme"
    -- },
    _8edit_config = {
        description = { " Settings                      SPC c v" },
        command =  ":lua OpenConfig()"
    },
    _9exit = {
        description = { "x Exit Neovim                         q" },
        command = ":q"
    },
}

vim.cmd[[
    augroup UserDashboard
        autocmd!
        autocmd User DashboardReady lua require("user.mappings").set_welcome_mappings()
    augroup end
]]
