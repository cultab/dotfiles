return {
    'lukas-reineke/indent-blankline.nvim',
    version = '*',
    main = "ibl",
    opts = {
        indent = {
            char = '▏',
            -- char = '┊',
            -- char = '│',
            -- highlight = { "Function", "Label" }
        },
        scope = {
            enabled = true,
            show_start = false,
            show_end = false,
            highlight = { "Label" },
        },
        exclude = {
            filetypes = {
                'lspinfo',
                'help',
                'terminal',
                'dashboard',
                'checkhealth',
                'man',
                'gitcommit',
                'TelescopePrompt',
                'TelescopeResults',
            },
        },
    }
}
