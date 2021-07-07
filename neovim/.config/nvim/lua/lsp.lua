local map = vim.api.nvim_set_keymap

require("lsp-colors").setup({
    Error = "#db4b4b",
    Warning = "#e0af68",
    Information = "#0db9d7",
    Hint = "#10B981"
})

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
    cmd = { '/home/evan/.local/share/nvim/lspinstall/lua/sumneko-lua-language-server' },
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
            },
        },
    },
  on_attach = require'completion'.on_attach,
}

require'lspconfig'.pyls.setup{
    on_attach=require'completion'.on_attach,
    cmd = { 'pylsp' }
}
require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}

local opts = { noremap=true, silent=false }

map('n', 'gD',         '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
map('n', 'gd',         '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
map('n', 'K',          '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
map('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
map('n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
map('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
map('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
map('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
map('n', '<leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
map('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>', opts)
map('n', '<leader>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
map('n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
map('n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
map('n', '<leader>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
map("n", "<leader>f",  "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
