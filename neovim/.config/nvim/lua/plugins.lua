
-- packer is optional
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', opt = true }

    -- lsp and treesitter {{{
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'folke/lsp-colors.nvim'
    use 'ray-x/lsp_signature.nvim'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',--{{{
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
    use { 'nvim-treesitter/nvim-treesitter-textobjects',--{{{
        requires = { 'nvim-treesitter/nvim-treesitter' }
    }--}}}
    -- use 'neomake/neomake'
    -- cmp-nvim
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'f3fora/cmp-spell'
    use { 'andersevenrud/compe-tmux' }
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    use { 'jose-elias-alvarez/null-ls.nvim',
        config = function ()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.code_actions.proselint,
                    -- null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.diagnostics.shellcheck,
                    null_ls.builtins.formatting.codespell,
                    null_ls.builtins.formatting.styler,
                    null_ls.builtins.formatting.shfmt,
                }
            })
        end}

    use { 'romgrk/nvim-treesitter-context',--{{{
        config = function ()
            require'treesitter-context'.setup{
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                throttle = true, -- Throttles plugin updates (may improve performance)
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                    -- For all filetypes
                    -- Note that setting an entry here replaces all other patterns for this entry.
                    -- By setting the 'default' entry below, you can control which nodes you want to
                    -- appear in the context window.
                    -- default = {
                    --     'class',
                    --     'function',
                    --     'method',
                    --     'for', -- These won't appear in the context
                    --     'while',
                    --     'if',
                    --     'switch',
                    --     'case',
                    -- },
                    -- Example for a specific filetype.
                    -- If a pattern is missing, *open a PR* so everyone can benefit.
                    --   rust = {
                    --       'impl_item',
                    --   },
                },
            }
        end
    }--}}}
    -- use { 'ms-jpq/coq_nvim', branch = 'coq'}
    -- use { 'ms-jpq/coq.artifacts', branch= 'artifacts'}

    use { 'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    }
    use 'mfussenegger/nvim-jdtls'
    use "folke/lua-dev.nvim"
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
        requires = {"nvim-telescope/telescope.nvim"}
    }--}}}
    --}}}

    -- visual {{{
    use { 'kosayoda/nvim-lightbulb',--{{{
        config = function ()
            vim.fn.sign_define('LightBulbSign', { text = "", texthl = "LspDiagnosticsDefaultInformation", linehl="", numhl="" })
            vim.cmd [[ autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb() ]]
        end
    }--}}}
    use { 'lukas-reineke/indent-blankline.nvim' }
    use { 'nvim-lualine/lualine.nvim',--{{{
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }--}}}
    use { 'glepnir/dashboard-nvim', --{{{
        opt = false,
        config = function()
            vim.g.dashboard_default_executive = 'telescope'
            -- vim.g.dashboard_custom_header = {
            -- [[                                      __              ]],
            -- [[                                     |  \             ]],
            -- [[ _______   ______   ______  __     __ \▓▓______ ____  ]],
            -- [[|       \ /      \ /      \|  \   /  \  \      \    \ ]],
            -- [[| ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\\▓▓\ /  ▓▓ ▓▓ ▓▓▓▓▓▓\▓▓▓▓\]],
            -- [[| ▓▓  | ▓▓ ▓▓    ▓▓ ▓▓  | ▓▓ \▓▓\  ▓▓| ▓▓ ▓▓ | ▓▓ | ▓▓]],
            -- [[| ▓▓  | ▓▓ ▓▓▓▓▓▓▓▓ ▓▓__/ ▓▓  \▓▓ ▓▓ | ▓▓ ▓▓ | ▓▓ | ▓▓]],
            -- [[| ▓▓  | ▓▓\▓▓     \\▓▓    ▓▓   \▓▓▓  | ▓▓ ▓▓ | ▓▓ | ▓▓]],
            -- [[ \▓▓   \▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓     \▓    \▓▓\▓▓  \▓▓  \▓▓]],
            -- [[                                                      ]],
            -- [[                                                      ]],
            -- [[                                                      ]],
            -- }

            vim.g.dashboard_custom_header = {
            [[                                                     ]],
            [[                                     _               ]],
            [[                                    |_|              ]],
            [[ ______   ______   ______  __   __   _   ___________ ]],
            [[|  __  | | ____ | |  __  | \ \ / /  | | |  __   __  |]],
            [[| |  | | | _____| | |  | |  \ v /   | | | |  | |  | |]],
            [[| |  | | | |____  | |__| |   \ /    | | | |  | |  | |]],
            [[|_|  |_| |______| |______|    v     |_| |_|  |_|  |_|]],
            }

            vim.g.dashboard_custom_section = {
                _1find_projects = {
                    description = { " Recently opened projects      SPC f p" },
                    command =  "Telescope projects"
                },
                _2find_history = {
                    description = { "ﭯ Recently opened files         SPC f h" },
                    command =  ":DashboardFindHistory"
                },
                _3new_file = {
                    description = { " New file                      SPC c n" },
                    command = ":DashboardNewFile"
                },
                _4find_file = {
                    description = { " Find file                     SPC f f" },
                    command =  ":DashboardFindFile"
                },
                _5change_colorscheme = {
                    description = { " Change Colorscheme            SPC t c" },
                    command = ":DashboardChangeColorscheme"
                },
                _8edit_config = {
                    description = { " Settings                      SPC c v" },
                    command =  ":lua Open_config()"
                },
                _9exit = {
                    description = { "x Exit                                q" },
                    command = ":q"
                },
            }

            vim.cmd [[
                nnoremap <buffer> <silent> <Leader>fp :Telescope projects<CR>
                nnoremap <buffer> <silent> <Leader>fh :DashboardFindHistory<CR>
              " nnoremap <buffer> <silent> <Leader>ff :DashboardFindFile<CR>
                nnoremap <buffer> <silent> <Leader>tc :DashboardChangeColorscheme<CR>
                nnoremap <buffer> <silent> <Leader>cn :DashboardNewFile<CR>
              " nnoremap <buffer> <silent> <Leader>fa :DashboardFindWord<CR>
              " nnoremap <buffer> <silent> <Leader>fb :DashboardJumpMark<CR>
                augroup exit
                    autocmd!
                    autocmd User DashboardReady nnoremap <buffer> q :q<CR>
                augroup end
            ]]

        end
    }-- }}}
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
    use { 'karb94/neoscroll.nvim',--{{{
        config = function()
	        require("neoscroll").setup()
        end
    }--}}}
	use 'folke/zen-mode.nvim'
    use 'folke/twilight.nvim'
    use { 'norcalli/nvim-colorizer.lua',--{{{
        config = function () require("colorizer").setup() end
    }--}}}
    use { 'folke/todo-comments.nvim',--{{{
        config = function()
            require('nvim_comment').setup()
            require('todo-comments').setup()
        end
    }--}}}
    use 'vim-pandoc/vim-pandoc-syntax'
    use 'plasticboy/vim-markdown'
    use 'liuchengxu/graphviz.vim'
    use 'onsails/lspkind-nvim'
    --}}}

    -- text manipulation {{{
    -- use { 'filipdutescu/renamer.nvim',--{{{
    --     requires = { "nvim-lua/plenary.nvim"},
    --     config = function ()
    --         local mappings_utils = require('renamer.mappings.utils')
    --         require('renamer').setup {
    --             -- The popup title, shown if `border` is true
    --             title = 'Rename',
    --             -- The padding around the popup content
    --             padding = {
    --                 top = 0,
    --                 left = 0,
    --                 bottom = 0,
    --                 right = 0,
    --             },
    --             -- Whether or not to shown a border around the popup
    --             border = true,
    --             -- The characters which make up the border
    --             border_chars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    --             -- Whether or not to highlight the current word references through LSP
    --             show_refs = true,
    --             -- Whether or not to add resulting changes to the quickfix list
    --             with_qf_list = true,
    --             -- Whether or not to enter the new name through the UI or Neovim's `input`
    --             -- prompt
    --             with_popup = true,
    --             -- The keymaps available while in the `renamer` buffer. The example below
    --             -- overrides the default values, but you can add others as well.
    --             mappings = {
    --                 ['<c-i>'] = mappings_utils.set_cursor_to_start,
    --                 ['<c-a>'] = mappings_utils.set_cursor_to_end,
    --                 ['<c-e>'] = mappings_utils.set_cursor_to_word_end,
    --                 ['<c-b>'] = mappings_utils.set_cursor_to_word_start,
    --                 ['<c-c>'] = mappings_utils.clear_line,
    --                 ['<c-u>'] = mappings_utils.undo,
    --                 ['<c-r>'] = mappings_utils.redo,
    --             },
    --             -- Custom handler to be run after successfully renaming the word. Receives
    --             -- the LSP 'textDocument/rename' raw response as its parameter.
    --             handler = nil,
    --         }
    --     end
    -- }--}}}
    use 'godlygeek/tabular'
    use 'windwp/nvim-autopairs'
    use 'junegunn/vim-easy-align'
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
    use { 'xiyaowong/telescope-emoji.nvim',--{{{
        config = function ()
            require("telescope").load_extension("emoji")
        end
    }--}}}
    --}}}

    -- colorschemes {{{
    use 'lifepillar/vim-solarized8'
    use 'ntk148v/vim-horizon'
    use { 'sainnhe/everforest',
        config = function ()
            if vim.g.colors_name == "everforest" then
                vim.o.background = "light"
            end
        end}
    -- use 'lifepillar/vim-gruvbox8'
    use { 'npxbr/gruvbox.nvim',--{{{
        requires = { 'rktjmp/lush.nvim' }
    }--}}}
    use { 'olimorris/onedarkpro.nvim',--{{{
        requires = { 'rktjmp/lush.nvim'},
        branch = "main"
    }--}}}
    use { 'catppuccin/nvim',--{{{
        config = function ()
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
    }--}}}
    use 'eddyekofo94/gruvbox-flat.nvim'
    use 'romgrk/github-light.vim'
    use 'romgrk/doom-one.vim'
    use { 'joshdick/onedark.vim', branch = "main"}
    use 'folke/tokyonight.nvim'
    use 'Shatur/neovim-ayu'
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
    use 'dstein64/vim-startuptime'
    use { 'aserowy/tmux.nvim',
        config = function ()
            require("tmux").setup{
                navigation = { cycle_navigation = false }
            }
        end}
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

    --}}}

end)
