local M = {}

local luasnip = require "luasnip"
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
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }
        ),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }
        ),
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lua' }, -- first because it only completes under vim.*
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
        format = require("lspkind").cmp_format({ with_text = false, menu = {
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
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline', keyword_pattern=[=[[^[:blank:]\!]*]=] }
    })
})

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } }
})

-- Setup lspconfig.
M.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())


local autopairs = require "nvim-autopairs.completion.cmp"
cmp.event:on("confirm_done",autopairs.on_confirm_done( { map_char = { tex = '' } }))

return M
