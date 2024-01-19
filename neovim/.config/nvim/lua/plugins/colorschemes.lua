local skip = function(plugin)
    return ""
end

local use = function(plugin)
    return plugin
end

local colors = {
    use {
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
    -- prot
    use 'https://gitlab.com/protesilaos/tempus-themes-vim.git',
    -- first class light
    use 'romgrk/github-light.vim',
    use 'lourenci/github-colors',
    use 'sainnhe/everforest',
    -- oldvim
    use 'shaunsingh/solarized.nvim',
    use 'Reewr/vim-monokai-phoenix',
    use 'cultab/potato-colors',
    skip 'lifepillar/vim-solarized8',
    skip 'lifepillar/vim-gruvbox8',
    -- low contrast
       use  {
            "2nthony/vitesse.nvim",
            dependencies = { "tjdevries/colorbuddy.nvim" }
        },
    -- high constrast
    use 'bluz71/vim-moonfly-colors',
    use 'ntk148v/vim-horizon',
    use "zootedb0t/citruszest.nvim",
    use 'nyoom-engineering/oxocarbon.nvim',
    use 'Shatur/neovim-ayu',
    -- :set notermguicolors
    use 'noahfrederick/vim-noctu',
    use 'jsit/disco.vim',
    use 'deviantfero/wpgtk.vim',
    -- gruvbox
    use 'eddyekofo94/gruvbox-flat.nvim',
    use {
        'npxbr/gruvbox.nvim',
        dependencies = { 'rktjmp/lush.nvim' }
    },
    -- vscode
    use 'Mofiqul/vscode.nvim',
    use 'LunarVim/darkplus.nvim',
    -- one dark family
    use 'romgrk/doom-one.vim',
    use { 'joshdick/onedark.vim', branch = "main" },
    use 'folke/tokyonight.nvim',
    use {
        'olimorris/onedarkpro.nvim',
        dependencies = { 'rktjmp/lush.nvim' },
        branch = "main"
    },
}

-- set all colorschemes to not be lazy loaded
for _, scheme in ipairs(colors) do
    if type(scheme) == "string" then
        scheme = { scheme }
    end
    scheme.lazy = false
    scheme.priority = 1000
end


return colors
