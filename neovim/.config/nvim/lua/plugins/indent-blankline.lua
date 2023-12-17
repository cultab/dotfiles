local icons = require'user.icons'
return {
    'lukas-reineke/indent-blankline.nvim',
    version = '*',
    main = "ibl",
    setup = function()
        require "ilb".setup {
            indent = {
                char = icons.line.left_thin,
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
        local hooks = require "ibl.hooks"
        hooks.register(
            hooks.builtin.hide_first_space_indent_level
        )
    end
}
