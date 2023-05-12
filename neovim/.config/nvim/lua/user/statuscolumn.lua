local builtin = require 'statuscol.builtin'

-- ┆
require('gitsigns').setup {
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '│' },
        topdelete    = { text = '│' },
        changedelete = { text = '│' },
        untracked    = { text = ' ' },
    },
}

require 'statuscol'.setup {
    -- setopt = true,
    relculright = true,
    segments = {
        {
            text = { builtin.foldfunc },
            click = "v:lua.ScFa"
        },
        {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
        },
        {
            sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
        },
        {
            sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
            click = "v:lua.ScSa"
        },
        {
            sign = { name = { "GitSigns*" },
            click = "v:lua.ScSa"
        }
        },
    }
}
