local M = {}
local utils = require "user.mason_utils"
local lspconfig = require "lspconfig"
local toMason = require "mason-lspconfig".get_mappings().lspconfig_to_mason

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {
    -- jedi_language_server = {},
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pydocstyle = {
                        enabled = true,
                        ignore = {
                            "D101",
                            "D102",
                            "D103",
                            "D203",
                            "D107",
                            "D100",
                        },
                    },
                    mypy = { enabled = true },
                    pylint = {
                        enabled = false,
                        ignore = {
                            "C0116",
                            "C0114",
                        }
                    },
                    jedi_completion = { enabled = true },
                    rope_completion = {
                        enabled = false,
                        eager = true
                    },
                    isort = { enabled = true },
                }
            }
        },
    },
    -- pylyzer = {},
    -- tsserver = {
    --     filetype = { "js", "ts" },
    -- },
    -- before_init = require 'neodev.lsp'.before_init
    lua_ls = {
        settings = {
            workspace = { checkThirdParty = false, },
            Lua = {
                diagnostics = { globals = { 'vim' } },
                runtime = { version = "LuaJIT" },
            }
        },
    },
    gopls = {
        settings = {
            gopls = {
                semanticTokens = true,
                staticcheck = true
            }
        }
    },
    texlab = { filetypes = { "plaintex", "tex", "rmd", "quarto" }, },
    clangd = {
        capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = "utf-16" }),
        filetypes = { "c", "cpp", "cuda" }
    },
    -- r_language_server = {},
    omnisharp = {},
    asm_lsp = {},
}

-- local mason_packages = {}
--
-- for server, _ in pairs(servers) do
--     table.insert(mason_packages, toMason[server])
-- end
--
-- utils.ensure_installed(mason_packages)

local border = {
      {"╭", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╮", "FloatBorder"},
      {"│", "FloatBorder"},
      {"╯", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╰", "FloatBorder"},
      {"│", "FloatBorder"},
}

-- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
}

local on_attach = function()
    require("lsp_signature").on_attach({
        bind = true,
        doc_lines = 0,
        hint_enable = true,
        hint_prefix = " ", -- TODO: replace with user.icons reference
        handler_opts = {
            border = "rounded" -- double, rounded, single, shadow, none, or a table of borders
        }
    })

    require "user.mappings".set_lsp_mappings()
end

-- setup all servers
for server, extra in pairs(servers) do
    local settings = {
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
    }

    settings = vim.tbl_deep_extend("force", settings, extra)
    lspconfig[server].setup(settings)
end

-- Jdtls configuration
function M.Jdtls_configure()
    vim.notify_once("jdtls is disabled")

    vim.notify("Tweak jdtls install_path!")
    require('jdtls').start_or_attach {
        cmd = { lspinstall_path .. '/jdtls/bin/jdtls',
            '/home/evan/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t') },
        root_dir = require('jdtls.setup').find_root({ 'gradle.build', 'pom.xml', '.git' }),
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

    local finders = require 'telescope.finders'
    local sorters = require 'telescope.sorters'
    local actions = require 'telescope.actions'
    local pickers = require 'telescope.pickers'

    require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
        local opts = {}
        pickers.new(opts, {
            prompt_title    = prompt,
            finder          = finders.new_table {
                results = items,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = label_fn(entry),
                        ordinal = label_fn(entry),
                    }
                end,
            },
            sorter          = sorters.get_generic_fuzzy_sorter(),
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
augroup JavaLSP
autocmd!
autocmd FileType java lua require"user.lsp".Jdtls_configure()
augroup end
]]

-- pylsp configuration
function Find_python_venv()
    -- return the path to a currently activated python venv
    -- supports Conda, pyenv, pipenv
    if vim.env.CONDA_PREFIX ~= nil then
        return vim.env.CONDA_PREFIX
    elseif vim.env.PYENV_VIRTUAL_ENV ~= nil then
        return vim.env.PYENV_VIRTUAL_ENV
    else
        local pipe = io.popen("pipenv --venv 2> /dev/null")
        if pipe == nil then
            return ""
        end
        local line = pipe:read()
        if pipe ~= nil then
            pipe:close()
        end
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
    lspconfig.pylsp.setup {
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
    require("lspconfig").pylsp.manager.try_add()
end

-- vim.cmd [[
--     augroup Pylsp
--         autocmd!
--         autocmd FileType python lua Pylsp_setup()
--     augroup end
-- ]]
-- }}}

-- vim.cmd [[
--     augroup diagnostics_on_hold
--     autocmd!
--     autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
--     augroup end
-- ]]

return M
