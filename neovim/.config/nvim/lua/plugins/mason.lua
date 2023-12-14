return {
    {
        'williamboman/mason.nvim',
        version = "*",
        config = function()
            require 'mason'.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜ ",
                        package_uninstalled = "✗"
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
