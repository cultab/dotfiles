-- HACK: see https://github.com/nvim-treesitter/nvim-treesitter/issues/3538
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--     pattern = { "*.lua" },
--     command = "TSBufEnable highlight",
-- })

vim.cmd [[highlight link @H1Marker @variable.builtin ]]
vim.cmd [[highlight link @H2Marker MatchParen ]]
vim.cmd [[highlight link @H3Marker @string ]]
vim.cmd [[highlight link @H4Marker @operator ]]
vim.cmd [[highlight link @H5Marker @function ]]
vim.cmd [[highlight link @H6Marker @constructor ]]
-- vim.cmd [[highlight link @codeblock Pmenu]]
-- vim.cmd [[highlight link @codeblock_lang @keyword ]]


-- M.context = {
--     enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
--     throttle = true, -- Throttles plugin updates (may improve performance)
--     max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
--     patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
--         -- For all filetypes
--         -- Note that setting an entry here replaces all other patterns for this entry.
--         -- By setting the 'default' entry below, you can control which nodes you want to
--         -- appear in the context window.
--         -- default = {
--         --     'class',
--         --     'function',
--         --     'method',
--         --     'for', -- These won't appear in the context
--         --     'while',
--         --     'if',
--         --     'switch',
--         --     'case',
--         -- },
--         -- Example for a specific filetype.
--         -- If a pattern is missing, *open a PR* so everyone can benefit.
--         --   rust = {
--         --       'impl_item',
--         --   },
--     },
-- }


return {
    {
        'nvim-treesitter/nvim-treesitter', build = ':TSUpdate',
        opts = {
            ensure_installed = "all", -- one of "all"  or a list of languages
            highlight = { enable = true },
            incremental_selection = { enable = false },
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
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["al"] = "@loop.outer",
                        ["il"] = "@loop.inner",
                        ["la"] = "@assignment.lhs",
                        ["ra"] = "@assignment.rhs",
                        ["ib"] = "@block.inner",
                        ["ab"] = "@block.outer",
                    }
                }
            },
            indent = {
                enable = false,
                disable = { 'python', 'java' }
            },
            playground = {
                enable = true,
                disable = {},
                updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                persist_queries = false, -- Whether the query persists across vim sessions
                keybindings = {
                    toggle_query_editor = 'o',
                    toggle_hl_groups = 'i',
                    toggle_injected_languages = 't',
                    toggle_anonymous_nodes = 'a',
                    toggle_language_display = 'I',
                    focus_language = 'f',
                    unfocus_language = 'F',
                    update = 'R',
                    goto_node = '<cr>',
                    show_help = '?',
                },
            }
        }
    },
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/playground',
}
