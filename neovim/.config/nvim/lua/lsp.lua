local map = vim.api.nvim_set_keymap

require('compe').setup{
    --{{{
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    resolve_timeout = 800;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
        border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
        winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
        max_width = 120,
        min_width = 60,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
};

  source = {
    path = true;
    buffer = true;
    calc = false;
    nvim_lsp = true;
    nvim_lua = false;
    vsnip = false;
    ultisnips = false;
    luasnip = false;
  };--}}}
}

local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
    require("lsp_signature").on_attach()--{{{
    require("nvim-autopairs.completion.compe").setup({
        map_cr = true, --  map <CR> on insert mode
        map_complete = true -- it will auto insert `(` after select function or method item
    })

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
    map("n", "<leader>f",  "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)--}}}
end

require("lsp-colors").setup({
    Error = "#db4b4b",
    Warning = "#e0af68",
    Information = "#0db9d7",
    Hint = "#10B981"
})

local luadev = require("lua-dev").setup({
    lspconfig = {
        cmd = { '/home/evan/.local/share/nvim/lspinstall/lua/sumneko-lua-language-server' },
        on_attach = on_attach
    }
})

lspconfig.sumneko_lua.setup(luadev)

lspconfig.pyls.setup{
    on_attach = on_attach,
    cmd = { 'pylsp' }
}

lspconfig.clangd.setup{on_attach = on_attach}

