require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.esupports.metagen"] = {
            config = {
                type = "auto",
            }
        },
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp"
            },
        },
        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
                norg_leader = "<Leader>o"
            }
        },
        -- ["core.norg.dirman"] = {
        --     config = {
        --         workspaces = {
        --             default = "~/.neorg"
        --         }
        --     }
        -- },
        -- ["core.integrations.telescope"] = {},
        ["core.export"] = {}

    }
}
