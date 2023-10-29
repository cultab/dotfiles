return {
    {
        {
            'rhysd/committia.vim',
            config = function()
                vim.g.committia_open_only_vim_starting = 0
            end,
            ft = "gitcommit"
        },
            'TimUntersberger/neogit',
            deps = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
            opts = {
                integrations = {
                    diffview = true
                },
                -- Setting any section to `false` will make the section not render at all
                sections = {
                    untracked = {
                        folded = false,
                        hidden = false,
                    },
                    unstaged = {
                        folded = false,
                        hidden = false,
                    },
                    staged = {
                        folded = false,
                        hidden = false,
                    },
                    stashes = {
                        folded = true,
                        hidden = false,
                    },
                    unpulled = {
                        folded = true,
                        hidden = false,
                    },
                    unmerged = {
                        folded = false,
                        hidden = false,
                    },
                    recent = {
                        folded = true,
                        hidden = false,
                    },
                },
                -- override/add mappings
                mappings = {
                    -- modify status buffer mappings
                    status = {
                        -- Adds a mapping with "B" as key that does the "BranchPopup" command
                        ["B"] = "BranchPopup",
                        -- -- Removes the default mapping of "s"
                        -- ["s"] = "",
                    }
                }
            }
        }
    }
