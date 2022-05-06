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
    _1find_projects = {
        description = { " Recently opened projects      SPC f p" },
        command =  "Telescope projects"
    },
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
        command =  ":DashboardFindFile"
    },
    _5change_colorscheme = {
        description = { " Change Colorscheme            SPC t c" },
        command = ":DashboardChangeColorscheme"
    },
    _8edit_config = {
        description = { " Settings                      SPC c v" },
        command =  ":lua OpenConfig()"
    },
    _9exit = {
        description = { "x Exit Neovim                         q" },
        command = ":q"
    },
}

function WelcomeMappings()
    vim.cmd [[
        nnoremap <buffer> <silent> <Leader>fp :Telescope projects<CR>
        nnoremap <buffer> <silent> <Leader>fh :DashboardFindHistory<CR>
        nnoremap <buffer> <silent> <Leader>tc :DashboardChangeColorscheme<CR>
        nnoremap <buffer> <silent> <Leader>cn :DashboardNewFile<CR>
        nnoremap <buffer> q :q<CR>
        " nnoremap <buffer> <silent> <Leader>ff :DashboardFindFile<CR>
        " nnoremap <buffer> <silent> <Leader>fa :DashboardFindWord<CR>
        " nnoremap <buffer> <silent> <Leader>fb :DashboardJumpMark<CR>
    ]]
end


vim.cmd[[
    augroup UserDashboard
        autocmd!
        autocmd User DashboardReady lua WelcomeMappings()
    augroup end
]]
