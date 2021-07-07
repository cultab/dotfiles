
-- packer is optional
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use { 'wbthomason/packer.nvim', opt = true }

    --lsp and treesitter {{{
	use 'neovim/nvim-lspconfig'
    use 'kabouzeid/nvim-lspinstall'
    use 'folke/lsp-colors.nvim'
    use 'nvim-lua/completion-nvim'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
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
		'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }
	}
	use 'norcalli/nvim-colorizer.lua'
	use 'folke/todo-comments.nvim'
    use 'sheerun/vim-polyglot'
	--}}}

    -- text manipulation {{{
    use 'windwp/nvim-autopairs'
	use 'blackCauldron7/surroud.nvim'
	use '/b3nj5m1n/kommentary'
	--}}}

	-- colorschemes {{{
	use 'lifepillar/vim-solarized8'
	use 'lifepillar/vim-gruvbox8'
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
	-- use 'ghifarit53/tokyonight-vim'
	-- }}}

-- misc{{{
	use 'folke/which-key.nvim'
	use 'benmills/vimux'
	--}}}

end)
