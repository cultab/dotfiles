return {
    -- 'lifepillar/vim-solarized8'
    'shaunsingh/solarized.nvim',
    'ntk148v/vim-horizon',
    {
        'sainnhe/everforest',
        config = function()
            if vim.g.colors_name == "everforest" then
                -- vim.o.background = "light"
                local noop = true
                return noop
            end
        end
    },
    -- 'lifepillar/vim-gruvbox8'
    {
        'npxbr/gruvbox.nvim',
        dependencies = { 'rktjmp/lush.nvim' }
    },
    {
        'olimorris/onedarkpro.nvim',
        dependencies = { 'rktjmp/lush.nvim' },
        branch = "main"
    },
    {
        'catppuccin/nvim',
        config = function()
            local cat = require("catppuccin")
            cat.setup({
                -- colorscheme = "neon_latte",
                transparency = false,
                integrations = {
                    telescope = true,
                    gitsigns = true,
                    which_key = true,
                    indent_blankline = {
                        enabled = true,
                        colored_indent_levels = true
                    },
                    barbar = true,
                    markdown = true
                }
            })
        end
    },
    'eddyekofo94/gruvbox-flat.nvim',
    'romgrk/github-light.vim',
    'romgrk/doom-one.vim',
    { 'joshdick/onedark.vim',      branch = "main" },
    'folke/tokyonight.nvim',
    'Shatur/neovim-ayu',
    'Reewr/vim-monokai-phoenix',
    'cultab/potato-colors',
    'noahfrederick/vim-noctu',
    'jsit/disco.vim',
    'lourenci/github-colors',
    'deviantfero/wpgtk.vim',
    'https://gitlab.com/protesilaos/tempus-themes-vim.git',
    'Mofiqul/vscode.nvim',
    'LunarVim/darkplus.nvim',
    'bluz71/vim-moonfly-colors',
    'B4mbus/oxocarbon-lua.nvim',
    { 'shaunsingh/oxocarbon.nvim', build = './install.sh' },
}
