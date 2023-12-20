local icons = require'user.icons'
return {
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            -- signcolumn = false,
            numhl = true,
            signs = {
                add          = { text = icons.line.left_medium },
                change       = { text = icons.line.left_medium },
                delete       = { text = icons.line.left_medium },
                topdelete    = { text = icons.line.left_medium },
                changedelete = { text = icons.line.left_medium },
                untracked    = { text = icons.line.left_medium },
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
                clickhandlers = {
                    Lnum = builtin.gitsigns_click,
                },
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
                            colwidth = 2,
                            auto = false,
                        },
                        click = "v:lua.ScSa"
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
                            fillchar = icons.line.left_medium,
                            fillcharhl = "Nrline"
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
                },
            }
        end
    }
}
