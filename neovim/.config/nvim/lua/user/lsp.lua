local cmp = require "user.cmp"

local capabilities = cmp.capabilities

local lsp_installer = require "nvim-lsp-installer"

local on_attach = function()
    require("lsp_signature").on_attach({
         bind = true,
         doc_lines = 0,
         hint_enable = true,
         hint_prefix = " ",
         handler_opts = {
             border = "shadow"
        }
    })

    require "user.mappings".set_lsp_mappings()
end

-- Now we'll create a server_opts table where we'll specify our custom LSP server configuration
local server_opts = {
    ["sumneko_lua"] = function(opts)
        local lua_dev = require "lua-dev"
        opts.settings = lua_dev.setup().settings
        -- opts.root_dir = function ()
        --     print(vim.fn.getcwd())
        --     return vim.fn.getcwd()
        -- end
    end,
    ["diagnosticls"] = function(opts)--{{{
        opts.settings = {
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
        }
    end,--}}}
}

lsp_installer.on_server_ready(function(server)
    -- Specify the default options which we'll use to setup all servers
    local opts = {
        on_attach = on_attach,
    }

    if server_opts[server.name] then
        server_opts[server.name](opts)
    end

    server:setup(opts)
end)
--}}}

-- Include the servers you want to have installed by default below
local servers = {
    "bashls",
    "tsserver",
    "sumneko_lua@v2.5.6"
}

for _, identifier in pairs(servers) do
    -- support auto-installing pinned versions
    local name, version = require("nvim-lsp-installer.servers").parse_server_identifier(identifier)

    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found then
        if not server:is_installed() then
            if version then
                vim.notify("Installing " .. name .. "@v" .. version)
                server:install(version)
            else
                vim.notify("Installing " .. name  .. " latest version")
                server:install()
            end
        end
    end
end

local autopairs = require 'nvim-autopairs'

autopairs.setup{
    fast_wrap = {},
}

-- vim.cmd [[
--     augroup diagnostics_on_hold
--     autocmd!
--     autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
--     augroup end
-- ]]


local lspconfig = require("lspconfig")
local lspinstall_path = vim.fn["stdpath"]("data") .. "/lsp_servers"

-- pylsp settings {{{

function Find_python_venv()
    -- return the path to a currently activated python venv
    -- supports Conda, pyenv, pipenv
    if vim.env.CONDA_PREFIX ~= nil then
        return vim.env.CONDA_PREFIX
    elseif vim.env.PYENV_VIRTUAL_ENV ~= nil then
        return vim.env.PYENV_VIRTUAL_ENV
    else
        local pipe = io.popen("pipenv --venv 2> /dev/null")
        local line = pipe:read()
        pipe:close()
        if line ~= nil and line:find("^/home/") ~= nil then
            return line
        else
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
]]--}}}

lspconfig.gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    -- settings = {
    --     gopls = {
    --         semanticTokens = true,
    --         staticcheck = true
    --     }
    -- }
}

local clangd_caps = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = "utf-16" })

lspconfig.clangd.setup{
    on_attach = on_attach,
    capabilities = clangd_caps,
    filetypes = { "c", "cpp", "cuda" }
}

-- No config needed {{{
lspconfig.r_language_server.setup{
    on_attach = on_attach,
    capabilities = capabilities
}
--}}}

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

--}}}


local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- disabled{{{
        -- null_ls.builtins.code_actions.proselint,
        -- null_ls.builtins.diagnostics.vale.with({
        --     -- filetypes = {},
        --     -- filetypes = { "markdown", "tex", "text" },
        --     extra_args = { "--config=" .. vim.fn.expand("~/.config/doc/vale/.vale.ini")}
        --     -- args = { "--config=/home/evan/.config/doc/vale/.vale.ini", "--no-exit", "--output=JSON", "$FILENAME" }
        -- }),}}}
        -- R
        null_ls.builtins.formatting.styler,
        -- shell
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.diagnostics.shellcheck,
        -- null_ls.builtins.formatting.shellharden, rust is borked
        -- python
        -- null_ls.builtins.diagnostics.pylint,
        -- c++
        null_ls.builtins.diagnostics.cppcheck,
        -- generic
        null_ls.builtins.formatting.trim_whitespace,
        -- null_ls.builtins.formatting.codespell,
    },
    on_attach = on_attach
})
