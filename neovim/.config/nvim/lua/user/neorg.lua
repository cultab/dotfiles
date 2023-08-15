local M = {}

M.config = function ()
    vim.defer_fn(function()
        print("Neorg")
    end, 1000)
    require('neorg').setup {
        load = {
            ["core.concealer"] = {
                config = {
                    folds = false,
                }
            },
            ["core.esupports.metagen"] = {
                config = {
                    type = "auto",
                }
            },
            ["core.completion"] = {
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
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        default = "~/.neorg"
                    }
                }
            },
            ["core.export"] = {}

        }
    }

end

return M
