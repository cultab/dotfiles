local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    print("Cloning to: " .. install_path .. "...")
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer, close and reopen Neovim..."
end

vim.cmd [[ packadd packer.nvim ]]

local ok, packer = pcall(require, "packer")
if not ok then
    return
end

packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end
    }
}

return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', opt = true }

    -- lsp {{{
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'folke/lsp-colors.nvim'
    -- use 'ray-x/lsp_signature.nvim'
    use { 'weilbith/nvim-code-action-menu', --{{{
        cmd = 'CodeActionMenu',
    } --}}}
    use { 'mfussenegger/nvim-jdtls', ft = "java" }

    use "folke/neodev.nvim"
    use 'jose-elias-alvarez/null-ls.nvim'
    -- }}}

    -- cmp-nvim {{{
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'f3fora/cmp-spell'
    use 'jc-doyle/cmp-pandoc-references'
    use 'kdheepak/cmp-latex-symbols'
    use 'andersevenrud/cmp-tmux'
    use 'tamago324/cmp-zsh'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'cultab/cmp-conventionalcommits' -- my fork with less features :^)
    -- }}}

    -- treesitter{{{
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', --{{{
        config = function()
            require('nvim-treesitter.configs').setup(require("user.treesitter").configs)
        end,
        -- event = "BufReadPost"
    } --}}}
    use { 'nvim-treesitter/nvim-treesitter-textobjects', --{{{
        requires = { 'nvim-treesitter/nvim-treesitter' },
        event = "BufReadPost"
    } --}}}
    -- use { 'romgrk/nvim-treesitter-context',--{{{
    --     config = function ()
    --         require'treesitter-context'.setup(require("user.treesitter").context)
    --     end
    -- } --}}}
    -- }}}

    -- visual {{{
    -- major ui elements
    use { 'romgrk/barbar.nvim', --{{{
        requires = { 'kyazdani42/nvim-web-devicons', opt = false },
        config = require 'user.bufferline'.config,
    } --}}}
    use { 'nvim-lualine/lualine.nvim', --{{{
        requires = { 'kyazdani42/nvim-web-devicons', opt = false }
    } --}}}
    use { 'rcarriga/nvim-notify', -- {{{
        config = function()
            require 'notify'.setup {
                stages = "static",
                timeout = "2500" -- in ms
            }
        end } -- }}}
    use { "folke/noice.nvim", -- {{{
        config = function()
            require("noice").setup {
                lsp = { progress = { enabled = true },
                    override = {
                        -- override the default lsp markdown formatter with Noice
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        -- override the lsp markdown formatter with Noice
                        ["vim.lsp.util.stylize_markdown"] = true,
                        -- override cmp documentation with Noice (needs the other options to work)
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                popupmenu = { backend = "nui", },
                cmdline =  { enabled = false },
                messages = { enabled = false },
            }
        end,
        requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify", }
    } --}}}
    use { 'prichrd/netrw.nvim' }

    -- context
    use 'lukas-reineke/indent-blankline.nvim'

    -- general changes
    use 'stevearc/dressing.nvim'
    use 'onsails/lspkind-nvim'
    use { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', --{{{
        config = function()
            -- Disable virtual_text since it's redundant due to lsp_lines.
            vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
            require("lsp_lines").setup()
        end,
    } --}}}

    use { 'glepnir/dashboard-nvim' }

    -- colorising
    use { 'RRethy/vim-hexokinase', --{{{
        run = "make hexokinase",
        config = function()
            vim.g.Hexokinase_highlighters = { "foregroundfull" }
        end
    } --}}}
    use { 'folke/todo-comments.nvim', --{{{
        config = function()
            require('todo-comments').setup()
        end
    } --}}}

    -- extra
    use { 'nyngwang/murmur.lua',
        config = function()
            AUGROUP = 'murmur_hold'
            vim.api.nvim_create_augroup(AUGROUP, { clear = true })
            require('murmur').setup {
                -- cursor_rgb = 'purple', -- default to '#393939'
                max_len = 80, -- maximum word-length to highlight
                -- disable_on_lines = 2000, -- to prevent lagging on large files. Default to 2000 lines.
                exclude_filetypes = {},
                callbacks = {
                    -- to trigger the close_events of vim.diagnostic.open_float.
                    function()
                        -- Close floating diag. and make it triggerable again.
                        vim.cmd('doautocmd InsertEnter')
                        vim.w.diag_shown = false
                    end,
                }
            }
            vim.api.nvim_create_autocmd('CursorHold', {
                group = AUGROUP,
                pattern = '*',
                callback = function()
                    -- skip when a float-win already exists.
                    if vim.w.diag_shown then return end

                    -- open float-win when hovering on a cursor-word.
                    if vim.w.cursor_word ~= '' then
                        vim.diagnostic.open_float(nil, {
                            focusable = true,
                            close_events = { 'InsertEnter' },
                            border = 'rounded',
                            source = 'always',
                            prefix = ' ',
                            scope = 'cursor',
                        })
                        vim.w.diag_shown = true
                    end
                end
            })

        end
    }
    use 'vim-pandoc/vim-pandoc-syntax'
    --}}}

    -- text manipulation {{{
    use 'godlygeek/tabular'
    use 'windwp/nvim-autopairs'
    use 'junegunn/vim-easy-align'
    use 'machakann/vim-sandwich'
    use { 'numToStr/Comment.nvim', --{{{
        config = function()
            require("Comment").setup()
            local ft = require "Comment.ft"

            -- use // for single line and /* */ for blocks
            -- in languages that use both comment styles
            local langs = { 'c', 'cpp', 'cuda', 'javascript', 'typescript' }

            for _, lang in ipairs(langs) do
                ft.set(lang, { '//%s', '/*%s*/' }).set('conf', '#%s')
            end
        end,
        event = "BufRead"
    }
    --}}}
    use { 'windwp/nvim-ts-autotag', --{{{
        config = function()
            require('nvim-ts-autotag').setup({
                filetypes = { "html", "xml" },
            })
        end
    } --}}}
    use { 'xiyaowong/telescope-emoji.nvim' }
    --}}}

    -- colorschemes {{{
    -- use 'lifepillar/vim-solarized8'
    use 'shaunsingh/solarized.nvim'
    use 'ntk148v/vim-horizon'
    use { 'sainnhe/everforest', --{{{
        config = function()
            if vim.g.colors_name == "everforest" then
                -- vim.o.background = "light"
                local noop = true
                return noop
            end
        end } --}}}
    -- use 'lifepillar/vim-gruvbox8'
    use { 'npxbr/gruvbox.nvim', --{{{
        requires = { 'rktjmp/lush.nvim' }
    } --}}}
    use { 'olimorris/onedarkpro.nvim', --{{{
        requires = { 'rktjmp/lush.nvim' },
        branch = "main"
    } --}}}
    use { 'catppuccin/nvim', --{{{
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
    } --}}}
    use 'eddyekofo94/gruvbox-flat.nvim'
    use 'romgrk/github-light.vim'
    use 'romgrk/doom-one.vim'
    use { 'joshdick/onedark.vim', branch = "main" }
    use 'folke/tokyonight.nvim'
    use 'Shatur/neovim-ayu'
    use 'Reewr/vim-monokai-phoenix'
    use 'cultab/potato-colors'
    use 'noahfrederick/vim-noctu'
    use 'jsit/disco.vim'
    use 'lourenci/github-colors'
    use 'deviantfero/wpgtk.vim'
    use 'https://gitlab.com/protesilaos/tempus-themes-vim.git'
    use 'Mofiqul/vscode.nvim'
    use 'LunarVim/darkplus.nvim'
    use 'bluz71/vim-moonfly-colors'
    use 'B4mbus/oxocarbon-lua.nvim'
    use {'shaunsingh/oxocarbon.nvim', run = './install.sh'}
    -- }}}

    -- git {{{
    use { 'lewis6991/gitsigns.nvim', --{{{
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup()
        end,
        -- event = "BufRead"
    } --}}}
    use { 'TimUntersberger/neogit',
        requires = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' }
    }
    use { 'rhysd/committia.vim',
        config = function()
            vim.g.committia_open_only_vim_starting = 0

        end }
    --}}}

    -- languages / filetypes{{{
    use 'kovetskiy/sxhkd-vim'
    -- }}}

    -- misc {{{
    use { 'folke/which-key.nvim', --{{{
        config = function()
            require('which-key').setup {
                plugins = {
                    spelling = { enabled = true }
                },
                show_help = false, -- for Noice
                show_keys = false
            }
        end,
        -- event = "BufWinEnter"
    } --}}}
    use 'equalsraf/neovim-gui-shim'
    use { 'akinsho/toggleterm.nvim', --{{{
        config = function()
            require("toggleterm").setup {
                direction = "horizontal", --"float",
                start_in_insert = true
            }
        end,
        event = "BufWinEnter"
    } --}}}
    use { 'dstein64/vim-startuptime', cmd = "StartupTime" }
    use { 'numToStr/Navigator.nvim' }
    -- use { 'aserowy/tmux.nvim', --{{{
    --     config = function()
    --         require("tmux").setup {
    --             navigation = {
    --                 cycle_navigation = false,
    --                 enable_default_keybindings = false,
    --             },
    --             resize = {
    --                 enable_default_keybindings = false,
    --             }
    --         }
    --     end
    -- } --}}}
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope.nvim', --{{{
        requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } }
    } --}}}
    use { 'nvim-neorg/neorg', requires = "nvim-lua/plenary.nvim", ft = "norg", config = require 'user.neorg'.config }
    use 'lewis6991/impatient.nvim'
    --}}}


end)

-- vim: set foldenable:foldmethod=marker:
