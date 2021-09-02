
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
    use  'ray-x/lsp_signature.nvim'
    use '/hrsh7th/nvim-compe'
    -- use { 'ms-jpq/coq_nvim', branch = 'coq'}
    -- use { 'ms-jpq/coq.artifacts', branch= 'artifacts'}
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', branch = '0.5-compat',--{{{
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
                highlight = { enable = true  },
                incremental_selection = { enable = true },
                textobjects = {
                    enable = true,
                    lsp_interop = {
                        enable = true,
                        -- peek_definition_code = {
                        --     ["df"] = "@function.outer",
                        --     ["dc"] = "@class.outer",
                        -- },
                    },
                    select = {
                        enable = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                        }
                    }
                },
                indent = {
                    enable = true,
                    disable = { 'python', 'java' }
                },
            }
        end
    }--}}}
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'neomake/neomake'
    use 'mfussenegger/nvim-jdtls'
    use { "ahmedkhalf/project.nvim",--{{{
        config = function()
            require("project_nvim").setup {

            detection_methods = { "lsp" },
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            }
            require('telescope').load_extension('projects')
        end,
        requires = {"nvim/telescope"}
    }--}}}

    --}}}

    -- visual {{{
    use 'lukas-reineke/indent-blankline.nvim'
    use { 'hoob3rt/lualine.nvim',--{{{
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }--}}}
    use { 'glepnir/dashboard-nvim', --{{{
        config = function() 
            G.dashboard_default_executive = 'telescope'
            G.dashboard_custom_header = {
            [[                                      __              ]],
            [[                                     |  \             ]],
            [[ _______   ______   ______  __     __ \▓▓______ ____  ]],
            [[|       \ /      \ /      \|  \   /  \  \      \    \ ]],
            [[| ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓\ /  ▓▓ ▓▓ ▓▓▓▓▓▓\▓▓▓▓\]],
            [[| ▓▓  | ▓▓ ▓▓    ▓▓ ▓▓  | ▓▓ \▓▓\  ▓▓| ▓▓ ▓▓ | ▓▓ | ▓▓]],
            [[| ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓__/ ▓▓  \▓▓ ▓▓ | ▓▓ ▓▓ | ▓▓ | ▓▓]],
            [[| ▓▓  | ▓▓\▓▓     \\▓▓    ▓▓   \▓▓▓  | ▓▓ ▓▓ | ▓▓ | ▓▓]],
            [[ \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓     \▓    \▓▓\▓▓  \▓▓  \▓▓]],
            [[                                                      ]],
            [[                                                      ]],
            [[                                                      ]],
            }

            -- G.dashboard_custom_header = {
            -- [[                                                     ]],
            -- [[                                     _               ]],
            -- [[                                    |_|              ]],
            -- [[ ______   ______   ______  __   __   _   ___________ ]],
            -- [[|  __  | | ____ | |  __  | \ \ / /  | | |  __   __  |]],
            -- [[| |  | | | _____| | |  | |  \ v /   | | | |  | |  | |]],
            -- [[| |  | | | |____  | |__| |   \ /    | | | |  | |  | |]],
            -- [[|_|  |_| |______| |______|    v     |_| |_|  |_|  |_|]],
            -- }

            G.dashboard_custom_section = {
                _1find_projects = {
                    description = { " Recently opened projects               SPC f p" },
                    command =  "Telescope projects"
                },
                _2new_file = {
                    description = { " New file                               SPC c n" },
                    command = ":DashboardNewFile"
                },
                _3find_history = {
                    description = { "ﭯ Recently opened files                  SPC f h" },
                    command =  ":DashboardFindHistory"
                },
                _4find_file = {
                    description = { " Find file                              SPC f f" },
                    command =  ":DashboardFindFile"
                },
                _5change_colorscheme = {
                    description = { " Change colorscheme                     SPC t c" },
                    command = ":DashboardChangeColorscheme"
                },
                _8edit_config = {
                    description = { " Edit init.lua                          SPC c v" },
                    command =  ":echo('not implemented')"
                },
                _9exit = {
                    description = { "x Exit                                         q" },
                    command = ":q"
                },
            }

            vim.cmd [[
                nnoremap <silent> <Leader>fp :Telescope projects<CR>
                nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
                " nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
                nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
                nnoremap <silent> <Leader>cn :DashboardNewFile<CR>
                " nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
                " nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
                augroup exit
                    autocmd!
                    autocmd User DashboardReady nnoremap q :q<CR>
                augroup end
            ]]

        end
    }-- }}}
    use 'ntk148v/vim-horizon'
    use { 'romgrk/barbar.nvim',--{{{
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }--}}}
    use { 'lewis6991/gitsigns.nvim',--{{{
		requires = { 'nvim-lua/plenary.nvim' },
        config = function ()
            require('gitsigns').setup{
                keymaps = {
                    -- Default keymap options
                    noremap = true,
                    buffer = true,

                    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
                    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

                    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
                    ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
                    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
                    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
                    ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
                    ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
                    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
                    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>'
                }
            }
            end
    }--}}}
	use 'folke/zen-mode.nvim'
    use 'folke/twilight.nvim'
    use { 'norcalli/nvim-colorizer.lua',
        config = function () require("colorizer").setup() end
    }
    use { 'folke/todo-comments.nvim',--{{{
        config = function()
            require('nvim_comment').setup()
            require('todo-comments').setup()
        end
    }--}}}
    use 'sheerun/vim-polyglot'
    use 'vim-pandoc/vim-pandoc-syntax'
    use 'plasticboy/vim-markdown'
    use 'liuchengxu/graphviz.vim'
    --}}}

    -- text manipulation {{{
    use 'windwp/nvim-autopairs'
    use { 'blackCauldron7/surround.nvim', --{{{
        config = function()
        require('surround').setup{}
            end
    }--}}}
    use 'terrortylor/nvim-comment'
    use { 'windwp/nvim-ts-autotag',--{{{
        config = function ()
        require('nvim-ts-autotag').setup({
        filetypes = { "html" , "xml" },
        })
    end
    }--}}}
    --}}}

    -- colorschemes {{{
    use 'lifepillar/vim-solarized8'
    -- use 'lifepillar/vim-gruvbox8'
    use { 'npxbr/gruvbox.nvim',--{{{
        requires = { 'rktjmp/lush.nvim' }
    }--}}}
    use { 'olimorris/onedark.nvim',--{{{
        requires = { 'rktjmp/lush.nvim'}
    }--}}}
    use { '/Pocco81/Catppuccino.nvim',--{{{
        config = function ()
            cat = require("catppuccino")
            cat.setup({
                colorscheme = "neon_latte",
                transparency = false,
                integrations = {
                    telescope = true,
                    gitsigns = true,
                    which_key = true,
                    indent_blankline = true,
                    barbar = true,
                    markdown = true
                }
            })

            if vim.g.colors_name == "catppuccino" then
                cat.load()
            end
        end
    }--}}}
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
    use { 'folke/which-key.nvim',--{{{
    config = function ()
        require('which-key').setup{
            plugins = {
                spelling = { enabled = true }
            }
        }
        end
    }--}}}
    use 'benmills/vimux'
    use "folke/lua-dev.nvim"
    use { 'nvim-telescope/telescope.nvim',--{{{
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
        config = function()
            local actions = require('telescope.actions')
            require('telescope').setup{
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close
                        },
                    },
                }
            }
        end
    }--}}}
    use 'sindrets/diffview.nvim'

    --}}}

end)
