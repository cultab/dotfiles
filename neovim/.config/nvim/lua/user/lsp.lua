-- vim.g.python3_host_prog = "~/.pyenv/versions/nvim/bin/python"

local M = {}
local cmp = require "user.cmp"
local lspconfig = require("lspconfig")

require'nvim-autopairs'.setup{ fast_wrap = {} }
require"neodev".setup { lspconfig = false }

require'mason-lspconfig'.setup{
    ensure_installed = {
        "bashls",
        "tsserver",
        "sumneko_lua",
        "pylsp",
    }
}

local capabilities = cmp.capabilities

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

M.on_attach = on_attach

local clangd_caps = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = "utf-16" })

local servers = {
    -- jedi_language_server = {},
    pylsp = {
    settings = {-- {{{
    pylsp = {
        plugins =  {
            pydocstyle = { enabled = true },
            mypy = { enabled = true },
            jedi_completion = { enabled = false },
            -- pylint = { enabled = true },
            rope_completion = { enabled = true, eager = true },
            isort = { enabled = true },
            black = { enabled = true },
        }
    }
    },-- }}}
    },
    bashls = {},
    tsserver = {},
    sumneko_lua = { before_init=require'neodev.lsp'.before_init },
    gopls = {
    settings = { --{{{
        gopls = {
            semanticTokens = true,
            staticcheck = true
        }
    } --}}}
    },
    texlab = { filetypes = { "plaintex", "tex", "rmd" }, },
    clangd = {
        capabilities = clangd_caps,
        filetypes = { "c", "cpp", "cuda" }
    },
    r_language_server = {}
}

for server, extra in pairs(servers) do
    local settings = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    settings = vim.tbl_deep_extend("force", settings, extra)
    lspconfig[server].setup(settings)
end

-- Jdtls configuration --{{{
function Jdtls_configure()
    vim.notify_once("jdtls is disabled")

    vim.notify("Tweak jdtls install_path!")
    require('jdtls').start_or_attach{
        cmd = { lspinstall_path .. '/jdtls/bin/jdtls', '/home/evan/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')},
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

-- pylsp configuration {{{

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
