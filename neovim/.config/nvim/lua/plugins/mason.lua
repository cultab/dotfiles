local icons = require'user.icons'

return {
    {
        'williamboman/mason.nvim',
        version = "*",
        config = function()
            require 'mason'.setup({
                ui = {
                    icons = {
                        package_installed = icons.misc.check,
                        package_pending = icons.misc.right_arrow,
                        package_uninstalled = icons.misc.x,
                    }
                }
            })

        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {},
    },
    {
        'neovim/nvim-lspconfig',
        version = '*',
    },
    'folke/lsp-colors.nvim',
}
