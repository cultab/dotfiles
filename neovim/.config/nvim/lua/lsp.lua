-- Setup nvim-cmp.{{{
local luasnip = require("luasnip")
local cmp = require("cmp")

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
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = 'spell' },
        { name = 'path' },
        { name = 'buffer' },
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
    }),
    formatting = {
        format = require("lspkind").cmp_format({ with_text = false, menu = {
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            spell = "[Spell]",
            path = "[Path]",
            Buffer = "[Buffer]",
        }})
    },
    experimental = {
        ghost_text = true,
        native_menu = true
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--}}}

local autopairs = require('nvim-autopairs')

autopairs.setup{
    fast_wrap = {},
}


vim.cmd [[
    augroup diagnostics_on_hold
    autocmd!
    autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })
    augroup end
]]

local lspconfig = require("lspconfig")
local lspinstall_path = '/home/evan/.local/share/nvim/lspinstall'

local on_attach = function() -- client, bufnr{{{
    require("lsp_signature").on_attach({
         bind = true,
         doc_lines = 0,
         hint_enable = false,
        --  handler_opts = {
        --      border = "none"
        -- }
    })
    --  require("nvim-autopairs.completion.compe").setup({
    --      map_cr = true, --  map <CR> on insert mode
    --      map_complete = true -- it will auto insert `(` after select function or method item
    -- })
    local mappings = require("mappings")
    mappings.lsp_mappings()

end --}}}

local luadev = require("lua-dev").setup{--{{{
    lspconfig = {
        cmd = { lspinstall_path .. '/lua/sumneko-lua-language-server' },
        on_attach = on_attach,
        capabilities = capabilities
    }
}

-- lspconfig.sumneko_lua.setup(luadev)
-- luadev = {
--     cmd = { lspinstall_path .. '/lua/sumneko-lua-language-server' },
--     on_attach = on_attach,
--     capabilities = capabilities
-- }

lspconfig.sumneko_lua.setup(luadev) --}}}

PYTHON_THING = "empty"

function Find_python_venv()
    -- return the path to a currently activated python venv
    -- supports Conda, pyenv, pipenv
    if vim.env.CONDA_PREFIX ~= nil then
        PYTHON_THING = "conda"
        return vim.env.CONDA_PREFIX
    elseif vim.env.PYENV_VIRTUAL_ENV ~= nil then
        PYTHON_THING = "pyenv"
        return vim.env.PYENV_VIRTUAL_ENV
    else
        local pipe = io.popen("pipenv --venv 2> /dev/null")
        local line = pipe:read()
        pipe:close()
        if line ~= nil and line:find("^/home/") ~= nil then
            PYTHON_THING = "pipenv"
            return line
        else
            PYTHON_THING = "none"
            return ""
        end
    end
end

local function get_pyls_plugins()
    local pylsp_plugins = {}
    local python_venv = Find_python_venv()

    pylsp_plugins.pydocstyle = {
            enabled = true
    }

    if python_venv ~= "" then
        pylsp_plugins.jedi = {
                environment = python_venv
        }
    end
    return pylsp_plugins
end

function Pylsp_setup()
    lspconfig.pylsp.setup{
        cmd = { 'pylsp_start' },
        on_attach = on_attach,
        settings = {
            pylsp = {
                plugins = get_pyls_plugins()
            }
        },
        capabilities = capabilities
    }
    -- HACK: pretty sure this is an implementation detail :^)
    require("lspconfig")["pylsp"].manager.try_add()
end

vim.cmd [[
    augroup Pylsp
        autocmd!
        autocmd FileType python lua Pylsp_setup()
    augroup end
]]

-- lspconfig.pyright.setup{
--     cmd = { lspinstall_path .. '/python/node_modules/.bin/pyright-langserver', '--stdio' },
--     on_attach = on_attach,
--     capabilities = capabilities,
-- }

-- vim.lsp.set_log_level("debug")

lspconfig.clangd.setup{--{{{
    on_attach = on_attach,
    capabilities = capabilities
}--}}}

lspconfig.tsserver.setup{--{{{
    cmd = { lspinstall_path .. '/typescript/node_modules/.bin/typescript-language-server', '--stdio' },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "javascript" },
    root_dir = function() return vim.loop.cwd() end -- run lsp for javascript in any directory
}--}}}

lspconfig.r_language_server.setup{--{{{
    on_attach = on_attach,
    capabilities = capabilities
}--}}}

lspconfig.diagnosticls.setup{--{{{
    cmd = { lspinstall_path .. '/diagnosticls/node_modules/.bin/diagnostic-languageserver', '--stdio' },
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "bash", "sh" },
    init_options = {
        filetypes = {
            sh = "shellcheck",
            bash = "shellcheck",
        },
        formatFiletypes = {
        sh = "shfmt",
        bash = "shfmt",
        },
        formatters = {
            shfmt = {
                command = "shfmt",
                args = { "-i", "2", "-bn", "-ci", "-sr", },
            }
        },
        linters = {
            shellcheck = {
                command = "shellcheck",
                rootPatterns = {},
                isStdout = true,
                isStderr = false,
                debounce = 100,
                args = { "--format=gcc", "-"},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "shellcheck",
                formatLines = 1,
                formatPattern = {
                    "^([^:]+):(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
                    {
                        line = 2,
                        column = 3,
                        endline = 2,
                        endColumn = 3,
                        message = {5},
                        security = 4
                    }
                },
                securities  = {
                    error  ="error",
                    warning = "warning",
                    note = "info"
                },
            }
        }
    }
}--}}}

function Jdtls_configure()--{{{
    require('jdtls').start_or_attach{
        cmd = { lspinstall_path .. '/java/jdtls.sh', '/home/evan/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')},
        root_dir = require('jdtls.setup').find_root({'gradle.build', 'pom.xml', '.git'}),
        on_attach = on_attach,
        capabilities = capabilities
    }

    vim.cmd [[
    nnoremap <leader>xv <Cmd>lua require('jdtls').extract_variable()<CR>
    vnoremap <leader>xv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
    nnoremap <leader>xc <Cmd>lua require('jdtls').extract_constant()<CR>
    vnoremap <leader>xc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
    vnoremap <leader>xm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>
    ]]

    local finders = require'telescope.finders'
    local sorters = require'telescope.sorters'
    local actions = require'telescope.actions'
    local pickers = require'telescope.pickers'

    require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
    local opts = {}
    pickers.new(opts, {
        prompt_title = prompt,
        finder    = finders.new_table {
        results = items,
        entry_maker = function(entry)
            return {
            value = entry,
            display = label_fn(entry),
            ordinal = label_fn(entry),
            }
        end,
        },
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
            local selection = actions.get_selected_entry(prompt_bufnr)
            actions.close(prompt_bufnr)

            cb(selection.value)
        end)

        return true
        end,
    }):find()
    end
end

vim.cmd [[
augroup lsp
    au!
    au FileType java lua _G.Jdtls_configure()
augroup end
]]

-- lspconfig.jdtls.setup{
--     cmd = { lspinstall_path .. '/java/jdtls.sh' },
--     on_attach = on_attach,
-- }

--}}}

lspconfig.gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities
}

-- lspconfig.r_language_server.setup{
--     on_attach = on_attach,
--     capabilities = capabilities,
--     cmd = { 'R', '--slave', '-e', 'languageserver::run()' }
-- }

lspconfig.bashls.setup{--{{{
    cmd = { lspinstall_path .. '/bash/node_modules/.bin/bash-language-server', 'start' },
    on_attach = on_attach,
    capabilities = capabilities
}--}}}
