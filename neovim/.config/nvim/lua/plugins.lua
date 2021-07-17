
-- packer is optional
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', opt = true }

    -- lsp and treesitter {{{
    use 'neovim/nvim-lspconfig'
    use 'kabouzeid/nvim-lspinstall'
    use 'folke/lsp-colors.nvim'
    -- use 'nvim-lua/completion-nvim'
    use  "ray-x/lsp_signature.nvim"
    use '/hrsh7th/nvim-compe'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'neomake/neomake'
    --}}}

    -- visual {{{
    use 'lukas-reineke/indent-blankline.nvim'
    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    use 'glepnir/dashboard-nvim'
    use 'ntk148v/vim-horizon'
    use {
        'romgrk/barbar.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
        'lewis6991/gitsigns.nvim',
		requires = { 'nvim-lua/plenary.nvim' }
    }
	use 'folke/zen-mode.nvim'
    use 'folke/twilight.nvim'
    use 'norcalli/nvim-colorizer.lua'
    use 'folke/todo-comments.nvim'
    use 'sheerun/vim-polyglot'
    use 'vim-pandoc/vim-pandoc-syntax'
    use 'plasticboy/vim-markdown'
    --}}}

    -- text manipulation {{{
    use 'windwp/nvim-autopairs'
    use 'blackCauldron7/surround.nvim'
    use 'terrortylor/nvim-comment'
    use 'windwp/nvim-ts-autotag'
    --}}}

    -- colorschemes {{{
    use 'lifepillar/vim-solarized8'
    -- use 'lifepillar/vim-gruvbox8'
    use {
        'npxbr/gruvbox.nvim',
        requires = { 'rktjmp/lush.nvim' }
    }
    use {
        'olimorris/onedark.nvim',
        requires = { 'rktjmp/lush.nvim'}
    }
    use 'eddyekofo94/gruvbox-flat.nvim'
    use 'romgrk/github-light.vim'
    use 'romgrk/doom-one.vim'
    use 'joshdick/onedark.vim'
    use 'folke/tokyonight.nvim'
    use 'ayu-theme/ayu-vim'
    use 'Reewr/vim-monokai-phoenix'
    use 'cultab/potato-colors'
    use 'noahfrederick/vim-noctu'
    use 'jsit/disco.vim'
    use 'lourenci/github-colors'
    -- use 'ghifarit53/tokyonight-vim'
    -- }}}

    -- misc {{{
    use 'folke/which-key.nvim'
    use 'benmills/vimux'
    use "folke/lua-dev.nvim"
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    use 'sindrets/diffview.nvim'

    --}}}

end)
