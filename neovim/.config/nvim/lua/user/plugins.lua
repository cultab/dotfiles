
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

vim.cmd[[ packadd packer.nvim ]]

local ok, packer = pcall(require, "packer")
if not ok then
    return
end

packer.init {
    display = {
        open_fn = function ()
            return require("packer.util").float { border = "rounded" }
        end
    }
}

return require('packer').startup(function(use)
    -- Packer can manage itself
    use { 'wbthomason/packer.nvim', opt = true }

    -- lsp {{{
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'folke/lsp-colors.nvim'
    use 'ray-x/lsp_signature.nvim'
    use { 'weilbith/nvim-code-action-menu',--{{{
        cmd = 'CodeActionMenu',
    }--}}}
    use 'mfussenegger/nvim-jdtls'
    use "folke/lua-dev.nvim"
    use { 'jose-elias-alvarez/null-ls.nvim' }

    -- use { "ahmedkhalf/project.nvim",--{{{
    --     config = function()
    --         require("project_nvim").setup {
    --             detection_methods = { "lsp" },
    --             -- your configuration comes here
    --             -- or leave it empty to use the default settings
    --             -- refer to the configuration section below
    --             silent_chdir = false,
    --             ignore_lsp = { "sumneko_lua" }
    --         }
    --         require('telescope').load_extension('projects')
    --     end,
    --     requires = {"nvim-telescope/telescope.nvim"}
    -- }--}}}
    --- }}}

    -- cmp-nvim {{{
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'f3fora/cmp-spell'
        use 'hrsh7th/cmp-nvim-lua'
        use 'jc-doyle/cmp-pandoc-references'
        use 'kdheepak/cmp-latex-symbols'
        use 'andersevenrud/cmp-tmux'
        use 'tamago324/cmp-zsh'
        use 'L3MON4D3/LuaSnip'
        use 'saadparwaiz1/cmp_luasnip'
        use 'cultab/cmp-conventionalcommits' -- my fork with less features :^)
    -- }}}

    -- treesitter{{{
        use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',--{{{
            config = function()
                require('nvim-treesitter.configs').setup(require("user.treesitter").configs)
            end
        }--}}}
        use { 'nvim-treesitter/nvim-treesitter-textobjects',--{{{
            requires = { 'nvim-treesitter/nvim-treesitter' }
        }--}}}
        -- use { 'romgrk/nvim-treesitter-context',--{{{
        --     config = function ()
        --         require'treesitter-context'.setup(require("user.treesitter").context)
        --     end
        -- }--}}}
    -- }}}

    -- visual {{{
        -- major ui elements
        use { 'romgrk/barbar.nvim',--{{{
            requires = { 'kyazdani42/nvim-web-devicons', opt = false }
        }--}}}
        use { 'nvim-lualine/lualine.nvim',--{{{
            requires = {'kyazdani42/nvim-web-devicons', opt = false}
        }--}}}
        use { 'rcarriga/nvim-notify',--{{{
            config = function()
            -- replace nvim's vim.notify with nvim-notify
            local notify = require("notify")
            -- notify.setup({ max_width = 35 })
            vim.notify = notify
            -- vim.notify("Loaded nvim-notify!")
        end
        }--}}}

        -- context
        -- use 'haringsrob/nvim_context_vt'
        use 'lukas-reineke/indent-blankline.nvim'
        use { 'kosayoda/nvim-lightbulb',--{{{
            config = function ()
                vim.fn.sign_define('LightBulbSign', { text = "", texthl = "LspDiagnosticsDefaultInformation", linehl="", numhl="" })
                vim.cmd [[ autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb() ]]
            end
        }--}}}

        -- general changes
        use 'stevearc/dressing.nvim'
        use 'onsails/lspkind-nvim'
        use { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',--{{{
            config = function()
                -- Disable virtual_text since it's redundant due to lsp_lines.
                vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
                require("lsp_lines").setup()
            end,
        }--}}}

        use { 'glepnir/dashboard-nvim', --{{{
            opt = false,
            config = function()
                require "user.welcome"
            end
        }-- }}}

        -- colorising
        -- use { 'norcalli/nvim-colorizer.lua',--{{{
        --     config = function () require("colorizer").setup() end
        -- }--}}}
        use { 'RRethy/vim-hexokinase',--{{{
            run = "make hexokinase",
            config = function ()
                vim.cmd [[ let g:Hexokinase_highlighters = ['backgroundfull'] ]]
            end
        }--}}}
        use { 'folke/todo-comments.nvim',--{{{
            config = function()
                require('todo-comments').setup()
            end
        }--}}}

        -- extra
        use 'vim-pandoc/vim-pandoc-syntax'
        use 'liuchengxu/graphviz.vim'

        use { 'xiyaowong/nvim-transparent',--{{{
            config = function ()
                require("transparent").setup({
                    enable = false, -- boolean: enable transparent
                    -- extra_groups = { -- table/string: additional groups that should be cleared
                    --     -- In particular, when you set it to 'all', that means all available groups
                    --
                    --     -- example of akinsho/nvim-bufferline.lua
                    --     "BufferLineTabClose",
                    --     "BufferlineBufferSelected",
                    --     "BufferLineFill",
                    --     "BufferLineBackground",
                    --     "BufferLineSeparator",
                    --     "BufferLineIndicatorSelected",
                    -- },
                    -- extra_groups = 'all',
                    exclude = {}, -- table: groups you don't want to clear
                    })

            end
        }--}}}
        use 'folke/zen-mode.nvim'
        use 'folke/twilight.nvim'
    --}}}

    -- text manipulation {{{
        use 'godlygeek/tabular'
        use 'windwp/nvim-autopairs'
        use 'junegunn/vim-easy-align'
        use 'machakann/vim-sandwich'
        use { 'numToStr/Comment.nvim',--{{{
            config = function ()
                require("Comment").setup()
                local ft = require "Comment.ft"

                -- use // for single line and /* */ for blocks
                -- in languages that use both comment styles
                local langs = { 'c', 'cpp', 'cuda', 'javascript', 'typescript' }

                for _, lang in ipairs(langs) do
                    ft.set(lang, {'//%s', '/*%s*/'}).set('conf', '#%s')
                end
            end}--}}}
        use { 'windwp/nvim-ts-autotag',--{{{
            config = function ()
            require('nvim-ts-autotag').setup({
            filetypes = { "html" , "xml" },
            })
        end
        }--}}}
        use { 'xiyaowong/telescope-emoji.nvim',--{{{
            config = function ()
                require "user.telescope"
            end
        }--}}}
    --}}}

    -- colorschemes {{{
        use 'lifepillar/vim-solarized8'
        use 'ntk148v/vim-horizon'
        use { 'sainnhe/everforest',--{{{
            config = function ()
                if vim.g.colors_name == "everforest" then
                    -- vim.o.background = "light"
                    local noop = true
                    return  noop
                end
            end}--}}}
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
        use 'deviantfero/wpgtk.vim'
        use 'https://gitlab.com/protesilaos/tempus-themes-vim.git'
        use 'Mofiqul/vscode.nvim'
        use 'LunarVim/darkplus.nvim'
        use 'bluz71/vim-moonfly-colors'
        -- use 'ghifarit53/tokyonight-vim'
    -- }}}

    -- git {{{
        use { 'lewis6991/gitsigns.nvim',--{{{
            requires = { 'nvim-lua/plenary.nvim' },
            config = function ()
                require('gitsigns').setup{
                    keymaps = {
                        -- Default keymap options
                        noremap = true,
                        buffer = true,

                        -- ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
                        -- ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

                        -- ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
                        -- ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
                        -- ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
                        -- ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
                        -- ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
                        -- ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
                        -- ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
                        -- ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>'
                    }
                }
                end
        }--}}}
        use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
        use { 'rhysd/committia.vim' }--}}}

    -- misc {{{
        use { 'abecodes/tabout.nvim' ,--{{{
            config = function ()
                require('tabout').setup {
                    tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
                    backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
                    act_as_tab = true, -- shift content if tab out is not possible
                    act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                    default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
                    default_shift_tab = '<C-d>', -- reverse shift default action,
                    enable_backwards = true, -- well ...
                    completion = true, -- if the tabkey is used in a completion pum
                    tabouts = {
                        {open = "'", close = "'"},
                        {open = '"', close = '"'},
                        {open = '`', close = '`'},
                        {open = '(', close = ')'},
                        {open = '[', close = ']'},
                        {open = '{', close = '}'}
                    },
                    ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                    exclude = {} -- tabout will ignore these filetypes
                }
            end,
                wants = {'nvim-treesitter'}, -- or require if not used so far
                after = {'nvim-cmp'} -- if a completion plugin is using tabs load it before
        }--}}}
        use { 'folke/which-key.nvim',--{{{
        config = function ()
            require('which-key').setup{
                plugins = {
                    spelling = { enabled = true }
                }
            }
            end
        }--}}}
        use 'equalsraf/neovim-gui-shim'
        use { 'akinsho/toggleterm.nvim',--{{{
            config = function ()
                require("toggleterm").setup{
                    direction = "float",
                    start_in_insert = true
                }
            end
        }--}}}
        use 'benmills/vimux'
        use 'dstein64/vim-startuptime'
        use { 'aserowy/tmux.nvim',--{{{
            config = function ()
                require("tmux").setup{
                    navigation = { cycle_navigation = false }
                }
            end
        }--}}}
        use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        use { 'nvim-telescope/telescope.nvim',--{{{
            requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
            config = function()
                require "user.telescope"
            end
        }--}}}
        use { 'nvim-neorg/neorg',--{{{
            config = function ()
                require('neorg').setup {
                    load = {
                        ["core.defaults"] = {},
                        ["core.norg.concealer"] = {},
                        ["core.norg.esupports.metagen"] = {
                            config = {
                                type = "auto",
                            }
                        },
                        ["core.norg.completion"] = {
                            config = {
                                engine = "nvim-cmp"
                            },
                        },
                        ["core.keybinds"] = {
                            config = {
                                default_keybinds = true,
                                norg_leader = "<Leader>o"
                            }
                        },
                        -- ["core.norg.dirman"] = {
                        --     config = {
                        --         workspaces = {
                        --             default = "~/.neorg"
                        --         }
                        --     }
                        -- },
                        -- ["core.integrations.telescope"] = {},
                        ["core.export"] = {}

                    }
                }
            end,
            requires = "nvim-lua/plenary.nvim"
        }--}}}
        use { 'declancm/cinnamon.nvim',--{{{
            config = function()
                require('cinnamon').setup({
                    extra_keymaps = true
                })
            end
        }--}}}
        -- disabled { 'karb94/neoscroll.nvim',--{{{
        --     config = function()
        --      require("neoscroll").setup()
        --     end
        -- }--}}}

    --}}}

end)
