local M = {}

M.config = function ()
    vim.defer_fn(function()
        print("Neorg")
    end, 1000)
    require('neorg').setup {
        load = {
            ["core.defaults"] = {},
            ["core.norg.concealer"] = {
                config = {
                    folds = false,
                }
            },
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
                    norg_leader = "<Leader>m"
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

end

return M
