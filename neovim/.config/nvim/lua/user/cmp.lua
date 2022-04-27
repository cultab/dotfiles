local M = {}

local luasnip = require "luasnip"
local cmp = require "cmp"

local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
        end,
    },
    mapping = {
        -- ['<Tab>'] = cmp.mapping.select_next_item({ cmp.SelectBehavior.Select }),
        -- ['<S-Tab>'] = cmp.mapping.select_prev_item({ cmp.SelectBehavior.Select }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
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
        -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        -- ['<C-e>'] = cmp.mapping({
        -- i = cmp.mapping.abort(),
        -- c = cmp.mapping.close(),
        -- }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lua' }, -- first because it only completes under vim.*
        { name = 'luasnip' }, -- For luasnip users.
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
            zsh = "[zsh]"
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
        { name = 'cmdline' }
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
