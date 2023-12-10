return {
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            -- signcolumn = false,
            numhl = true,
            signs = {
                add          = { text = '▏' },
                change       = { text = '▏' },
                delete       = { text = '▏' },
                topdelete    = { text = '▏' },
                changedelete = { text = '▏' },
                untracked    = { text = '▏' },
            },
        },
    },
    {
        'luukvbaal/statuscol.nvim',
        config = function()
            local builtin = require 'statuscol.builtin'
            require 'statuscol'.setup {
                -- setopt = true,
                relculright = true,
                segments = {
                    {
                        sign = {
                            name = { ".*" },
                            maxwidth = 1,
                            colwidth = 1,
                            auto = true,
                            wrap = true,
                        },
                    },
                    {
                        sign = {
                            name = { "Diagnostic" },
                            maxwidth = 1,
                            colwidth = 1,
                            auto = true,
                        },
                        click = "v:lua.ScSa"
                    },
                    {
                        text = { builtin.foldfunc, " " },
                        hl = "FoldColumn",
                        wrap = true,
                        colwidth = 1,
                        click = "v:lua.ScFa"
                    },
                    {
                        text = { builtin.lnumfunc, " " },
                        colwidth = 1,
                        click = "v:lua.ScLa",
                    },
                    {
                        sign = {
                            name = { "GitSigns*" },
                            colwidth = 1,
                            fillchar = "▏",
                            fillcharhl = "Nrline"
                        },
                        click = "v:lua.ScSa"
                    },
                },
            }
        end
    }
}
