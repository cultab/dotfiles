local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- lsp {{{
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'folke/lsp-colors.nvim',
    { 'weilbith/nvim-code-action-menu', --{{{
        cmd = 'CodeActionMenu',
    }, --}}}
    { 'mfussenegger/nvim-jdtls', ft = "java" },

    "folke/neodev.nvim",
    'jose-elias-alvarez/null-ls.nvim',
    -- }}}

    -- cmp-nvim {{{
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'f3fora/cmp-spell',
    'jc-doyle/cmp-pandoc-references',
    'kdheepak/cmp-latex-symbols',
    'andersevenrud/cmp-tmux',
    'tamago324/cmp-zsh',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'cultab/cmp-conventionalcommits', -- my fork with less features :^)
    -- }}}

    -- treesitter {{{
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/playground',
    -- }}}

    -- visual {{{
    -- major ui elements
    { 'romgrk/barbar.nvim', --{{{
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = false },
        config = require 'user.bufferline'.config,
    }, --}}}
    { 'nvim-lualine/lualine.nvim', --{{{
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = false }
    }, --}}}
    { 'rcarriga/nvim-notify', -- {{{
        config = function()
            require 'notify'.setup {
                stages = "static",
                timeout = "2500" -- in ms
            }
    end }, -- }}}
    -- { "folke/noice.nvim", -- {{{
    --     config = function()
    --         require("noice").setup {
    --             lsp = { progress = { enabled = true },
    --                 override = {
    --                     -- override the default lsp markdown formatter with Noice
    --                     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    --                     -- override the lsp markdown formatter with Noice
    --                     ["vim.lsp.util.stylize_markdown"] = true,
    --                     -- override cmp documentation with Noice (needs the other options to work)
    --                     ["cmp.entry.get_documentation"] = true,
    --                 },
    --             },
    --             popupmenu = { backend = "nui", },
    --             cmdline = { enabled = false },
    --             messages = { enabled = false },
    --         }
    --     end,
    --     dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify", }
    -- } --}}}
     'MunifTanjim/nui.nvim',
    { 'j-hui/fidget.nvim', tag = 'legacy' },
     'prichrd/netrw.nvim',
     'luukvbaal/statuscol.nvim',

    -- context
    { 'lukas-reineke/indent-blankline.nvim', version = 'v2.20.8' },

    -- general changes
    'stevearc/dressing.nvim',
    'onsails/lspkind-nvim',
    { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', --{{{
        config = function()
            -- Disable virtual_text since it's redundant due to lsp_lines.
            vim.diagnostic.config({ virtual_text = false, virtual_lines = { only_current_line = true } })
            require("lsp_lines").setup()
        end,
    }, --}}}
    { dir = '~/repos/headlines.nvim' },

    { 'glepnir/dashboard-nvim', config = function()
        require 'dashboard'.setup(require 'user.welcome'.config)
    end },

    -- colorising
    { 'RRethy/vim-hexokinase', --{{{
        build = "make hexokinase",
        config = function()
            vim.g.Hexokinase_highlighters = { "foregroundfull" }
        end
    }, --}}}
    { 'folke/todo-comments.nvim', --{{{
        config = function()
            require('todo-comments').setup()
        end
    }, --}}}

    -- extra
    { 'nyngwang/murmur.lua',
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
    },
    --}}}

    -- text manipulation {{{
    'godlygeek/tabular',
    'windwp/nvim-autopairs',
    'junegunn/vim-easy-align',
    'machakann/vim-sandwich',
    { 'numToStr/Comment.nvim', --{{{
        config = function()
            require("Comment").setup()
            local ft = require "Comment.ft"

            -- // for single line and /* */ for blocks
            -- in languages that both comment styles
            local langs = { 'c', 'cpp', 'cuda', 'javascript', 'typescript' }

            for _, lang in ipairs(langs) do
                ft.set(lang, { '//%s', '/*%s*/' }).set('conf', '#%s')
            end
        end,
        event = "BufRead"
    },
    --}}}
    { 'windwp/nvim-ts-autotag', --{{{
        config = function()
            require('nvim-ts-autotag').setup({
                filetypes = { "html", "xml" },
            })
        end
    }, --}}}
    { 'xiyaowong/telescope-emoji.nvim' },
    --}}}

    -- colorschemes {{{
    -- 'lifepillar/vim-solarized8'
    'shaunsingh/solarized.nvim',
    'ntk148v/vim-horizon',
    { 'sainnhe/everforest', --{{{
        config = function()
            if vim.g.colors_name == "everforest" then
                -- vim.o.background = "light"
                local noop = true
                return noop
            end
        end }, --}}}
    -- 'lifepillar/vim-gruvbox8'
    { 'npxbr/gruvbox.nvim', --{{{
        dependencies = { 'rktjmp/lush.nvim' }
    }, --}}}
    { 'olimorris/onedarkpro.nvim', --{{{
        dependencies = { 'rktjmp/lush.nvim' },
        branch = "main"
    }, --}}}
    { 'catppuccin/nvim', --{{{
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
    }, --}}}
    'eddyekofo94/gruvbox-flat.nvim',
    'romgrk/github-light.vim',
    'romgrk/doom-one.vim',
    { 'joshdick/onedark.vim', branch = "main" },
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
    -- }}}

    -- git {{{
    { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, },
    -- { 'TimUntersberger/neogit',
    --     dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' }
    -- }
    { 'rhysd/committia.vim',
        config = function()
            vim.g.committia_open_only_vim_starting = 0
        end },
    --}}}

    -- languages / filetypes{{{
    'kovetskiy/sxhkd-vim',
    -- }}}

    -- misc {{{
    { 'folke/which-key.nvim', --{{{
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
    }, --}}}
    'equalsraf/neovim-gui-shim',
    { 'akinsho/toggleterm.nvim', --{{{
        config = function()
            require("toggleterm").setup {
                direction = "float", -- "horizontal", --"float",
                start_in_insert = true
            }
        end,
        event = "BufWinEnter"
    }, --}}}
    { 'dstein64/vim-startuptime', cmd = "StartupTime" },
    { 'numToStr/Navigator.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope.nvim', --{{{
        dependencies = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } }
    }, --}}}
    { 'nvim-neorg/neorg',
        commit = 'f296a22',
        dependencies = "nvim-lua/plenary.nvim",
        ft = "norg",
        config = require 'user.neorg'.config
    },
    'lewis6991/impatient.nvim',
    'quarto-dev/quarto-nvim',
    'jmbuhr/otter.nvim',
    -- { 'quarto-dev/quarto-vim',-- {{{
    --     ft = 'quarto',
    --     dependencies = { 'vim-pandoc/vim-pandoc-syntax' },
    --     -- note: needs additional syntax highlighting enabled for markdown
    --     --       in `nvim-treesitter`
    --     config = function()
    --   -- conceal can be tricky becaboth
    --   -- the treesitter highlighting and the
    --   -- regex vim syntax files can define conceals
    --
    --   -- see `:h conceallevel`
    --   vim.opt.conceallevel = 1
    --
    --   -- disable conceal in markdown/quarto
    --   vim.g['pandoc#syntax#conceal#use'] = true
    --
    --   -- embeds are already handled by treesitter injectons
    --   vim.g['pandoc#syntax#codeblocks#embeds#use'] = false
    --   vim.g['pandoc#syntax#conceal#blacklist'] = { 'codeblock_delim', 'codeblock_start' }
    --
    --   -- but allow some types of conceal in math regions:
    --   -- see `:h g:tex_conceal`
    --   vim.g['tex_conceal'] = 'gm'
    --     end
    --   }-- }}}
    -- vim: set foldenable:foldmethod=marker:
})
