return {
    'onsails/lspkind-nvim',
    {
        'windwp/nvim-autopairs',
        opts = { fast_wrap = {} }
    },
    -- {
    --     "folke/neodev.nvim",
    --     opts = {},
    -- },
    {
        'godlygeek/tabular',
        cmd = "Tabularize"
    },
    {
        'junegunn/vim-easy-align',
        cmd = "EasyAlign"
    },
    'machakann/vim-sandwich',
    {
        'numToStr/Comment.nvim',
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
    {
        'windwp/nvim-ts-autotag',
        opts = {
            filetypes = { "html", "xml" },
        },
        ft = { "html", "xml" }
    },
    'stevearc/dressing.nvim',
    { 'j-hui/fidget.nvim', tag = 'legacy' },
    {
        'nyngwang/murmur.lua',
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
    {
        'prichrd/netrw.nvim',
        ft = "netrw"
    },
    'MunifTanjim/nui.nvim',
    {
        'rcarriga/nvim-notify',
        opts = {
            stages = "static",
            timeout = "2500" -- in ms
        },
    },
    {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    },
    {
        'kovetskiy/sxhkd-vim',
        ft = { "sxhkd" }
    },
    {
        'folke/todo-comments.nvim',
        config = true,
    },
    {
        'akinsho/toggleterm.nvim',
        opts = {
            direction = "horizontal", -- "horizontal", --"float",
            start_in_insert = true
        }
        ,
        event = "BufWinEnter",
        cmd = { "TermExec", "ToggleTermToggleAll", "ToggleTerm" }
    },
    {
        'RRethy/vim-hexokinase',
        build = "make hexokinase",
        config = function()
            vim.g.Hexokinase_highlighters = { "foregroundfull" }
        end
    },
}
