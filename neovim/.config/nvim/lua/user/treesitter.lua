local M = {}

M.configs = {
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

M.context = {
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

return M
