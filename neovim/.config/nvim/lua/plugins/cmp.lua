return {
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require "cmp"
            cmp.setup {
                -- enabled = function()
                --     local context = require"cmp.config.context"
                --     if context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment") then
                --         return false
                --     else
                --         return true
                --     end
                -- end,
                window = {
                    completion    = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = require 'user.mappings'.get_cmp_mappings(),
                sources = cmp.config.sources({
                    { name = 'luasnip' },
                    { name = 'otter' },
                    { name = 'conventionalcommits' },
                    { name = 'neorg' },
                    { name = 'nvim_lsp' },
                    { name = 'pandoc_references' },
                    { name = "latex_symbols" },
                    { name = 'buffer',             keyword_length = 2, max_item_count = 5 }, -- keep spam to a mininum
                    { name = 'tmux',               keyword_length = 2, max_item_count = 5 },
                    { name = 'path' },
                    { name = 'zsh' },
                }),
                formatting = {
                    fields = { "abbr", "kind", "menu" },
                    format = require("lspkind").cmp_format({
                        symbol_map = require 'user.icons'.lsp_cozette,
                        mode = "symbol_text",
                        menu = {
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            otter = "[Otter]",
                            pandoc_references = "[Pandoc]",
                            path = "[Path]",
                            buffer = "[Buffer]",
                            tmux = "[tmux]",
                            nvim_lua = "[nvim]",
                            latex_symbols = "[LaTeX]",
                            zsh = "[zsh]",
                            neorg = "[neorg]",
                            conventionalcommits = "[git]",
                        },
                    })
                },
                view = {
                    experimental = {
                        ghost_text = true,
                    }
                },
            }

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline', ignore_cmds = {} } -- keyword_pattern=[=[[^[:blank:]\!]*]=]
                }
                )
            })

            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = 'buffer' } }
            })



            local autopairs = require "nvim-autopairs.completion.cmp"
            cmp.event:on("confirm_done", autopairs.on_confirm_done({ map_char = { tex = '' } }))
        end,
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
        }
    },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'f3fora/cmp-spell',
    'jc-doyle/cmp-pandoc-references',
    'kdheepak/cmp-latex-symbols',
    'andersevenrud/cmp-tmux',
    {
        'tamago324/cmp-zsh',
        opts = {
            zshrc = true,                                           -- Source the zshrc (adding all custom completions). default: false
            filetypes = { "deoledit", "zsh", "bash", "fish", "sh" } -- Filetypes to enable cmp_zsh source. default: {"*"}
        }
    },
    {
        "ray-x/lsp_signature.nvim",
        version = false,
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },
    'cultab/cmp-conventionalcommits', -- my fork with less features :^)
}
