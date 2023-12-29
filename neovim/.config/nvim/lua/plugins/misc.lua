return {
    {
        'onsails/lspkind-nvim',
        version = "*",
    },
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
        opts = {
            keywords = {
                FIX  = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                -- BECAUSE       = { icon = "∵", color = "argumentation" },
                -- EXPLANATION   = { icon = "∵", color = "argumentation" },
                -- REASON        = { icon = "∵", color = "argumentation" },
                -- JUSTIFICATION = { icon = "∵", color = "argumentation" },
                -- REF           = { icon = "", color = "info" },
                -- REFERENCE     = { icon = "", color = "info" },
                -- SRC           = { icon = "", color = "info" },
                -- URL           = { icon = "", color = "info" },
                -- THEREFORE     = { icon = "∴", color = "argumentation" },
                -- CONCLUSION    = { icon = "∴", color = "default" },
                -- QED           = { icon = "∴", color = "argumentation" },
                -- WARN          = { icon = "󰀦", color = "warning" },
                -- WARNING       = { icon = "󰀦", color = "warning" },
                -- DOC           = { icon = "", color = "info" },
                -- DOCUMENTATION = { icon = "", color = "info" },
                -- DEF           = { icon = "∆", color = "info" },
                -- DEFINITION    = { icon = "∆", color = "info" },
                -- NOMENCLATURE  = { icon = "∆", color = "info" },
                -- YIKES         = { icon = "⁉", color = "error" },
                -- WHAA          = { icon = "⁇", color = "default" },
                -- BUG           = { icon = "", color = "error" },
                -- BAD           = { icon = "󰇸", color = "default" },
                -- BROKEN        = { icon = "󰋮", color = "error" },
                -- CHALLENGE     = { icon = "", color = "actionItem" },
                -- CLAIM         = { icon = "➰", color = "argumentation" },
                -- CONTEXT       = { icon = "❄", color = "info" },
                -- DECIDE        = { icon = "", color = "actionItem" },
                -- DISABLED      = { icon = "", color = "default" },
                -- FIXME         = { icon = "", color = "error" },
                -- HACK          = { icon = "", color = "info" },
                -- IDEA          = { icon = "☀", color = "idea" },
                -- LOOKUP        = { icon = "󰊪", color = "actionItem" },
                -- MAYBE         = { icon = "󱍊", color = "idea" },
                -- NOTE          = { icon = "❦", color = "info" },
                -- NICE          = { icon = "", color = "idea" },
                -- PITCH         = { icon = "♮", color = "argumentation" },
                -- PROMISE       = { icon = "✪", color = "actionItem" },
                -- RESEARCH      = { icon = "⚗", color = "actionItem" },
                -- SAD           = { icon = "󰋔", color = "default" },
                -- SECTION       = { icon = "§", color = "info" },
                -- TIP           = { icon = "󰓠", color = "argumentation" },
                -- TODO          = { icon = "★", color = "actionItem" },
                -- WORRY         = { icon = "⌇", color = "warning" },
            },
            -- colors = {
            --     actionItem = { "ActionItem", "#A0CC00" },
            --     argumentation = { "Argument", "#8C268C" },
            --     default = { "Identifier", "#999999" },
            --     error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
            --     idea = { "IdeaMsg", "#FDFF74" },
            --     info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
            --     warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FB8F24" },
            -- }
        },
        version = "*",
    },
    {
        'akinsho/toggleterm.nvim',
        opts = {
            direction = "vertical",
            start_in_insert = true,
            size = vim.o.columns * 0.4
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
