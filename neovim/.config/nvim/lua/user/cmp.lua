local M = {}

local cmp = require "cmp"

cmp.setup({
    -- enabled = function()
    --     local context = require"cmp.config.context"
    --     if context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment") then
    --         return false
    --     else
    --         return true
    --     end
    -- end,
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = require'user.mappings'.get_cmp_mappings(),
    sources = cmp.config.sources({
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'conventionalcommits' },
        { name = 'neorg' },
        { name = 'nvim_lsp' },
        { name = 'pandoc_references' },
        { name = "latex_symbols" },
        { name = 'buffer', keyword_length = 2, max_item_count = 5 }, -- keep spam to a mininum
        { name = 'tmux', keyword_length = 2, max_item_count = 5 },
        { name = 'path' },
        { name = 'zsh' },
    }),
    formatting = {
        format = require("lspkind").cmp_format({ mode = "symbol_text", menu = {
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            pandoc_references = "[Pandoc]",
            path = "[Path]",
            buffer = "[Buffer]",
            tmux = "[tmux]",
            nvim_lua = "[nvim]",
            latex_symbols = "[LaTeX]",
            zsh = "[zsh]",
            neorg = "[neorg]",
            conventionalcommits = "[git]",
        }})
    },
    view = {
        experimental = {
            ghost_text = true,
        }
    },
})

require'cmp_zsh'.setup {
  zshrc = true, -- Source the zshrc (adding all custom completions). default: false
  filetypes = { "deoledit", "zsh", "bash", "fish", "sh" } -- Filetypes to enable cmp_zsh source. default: {"*"}
}

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources( {
            { name = 'path' }
        }, {
            { name = 'cmdline', keyword_pattern=[=[[^[:blank:]\!]*]=] }
        }
    )
})

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } }
})

-- Setup lspconfig.
M.capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


local autopairs = require "nvim-autopairs.completion.cmp"
cmp.event:on("confirm_done",autopairs.on_confirm_done( { map_char = { tex = '' } }))

return M
