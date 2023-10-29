-- vim.g.python3_host_prog = "~/.pyenv/versions/nvim/bin/python"

local M = {}

local lspconfig = require("lspconfig")
local Registry = require 'mason-registry'
local Package = require 'mason-core.package'

M.ensure_installed = function(tools)
    for _, tool in ipairs(tools) do
        local name, version = Package.Parse(tool)

        local pkg = Registry.get_package(name)

        if not pkg:is_installed() then
            vim.notify("Installing " .. name .. "@latest version")
            pkg:install()
            return
        -- else
        --     vim.notify(name .. "is installed")
        end

        pkg:get_installed_version(function(success, version_or_err)
            if not success then
                vim.notify("error: " .. version_or_err)
                return
            end

            -- local installed_version = string.sub(version_or_err, 2, #version_or_err)
            local installed_version = version_or_err
            local is_pinned_version = version == installed_version
            -- vim.notify(name .. ": " .. (version and version or "nil") .. "|" ..  version_or_err)
            --
            if is_pinned_version or not version then
                -- vim.notify(name .. "@" .. installed_version .. " already installed")
                return
            end

            vim.notify("Updating " .. tool .. " to version v" .. version)
            pkg:install({ version = version })

        end)

    end
end


-- Setup lspconfig.
M.capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

M.on_attach = function()
    -- require("lsp_signature").on_attach({{{{
    --      bind = true,
    --      doc_lines = 0,
    --      hint_enable = true,
    --      hint_prefix = " ",
    --      handler_opts = {
    --          border = "shadow"
    --     }
    -- })}}}

    require "user.mappings".set_lsp_mappings()
end

-- setup all servers
M.setup_servers = function(servers)
    for server, extra in pairs(servers) do
        local settings = {
            on_attach = M.on_attach,
            capabilities = M.capabilities,
        }

        settings = vim.tbl_deep_extend("force", settings, extra)
        lspconfig[server].setup(settings)
    end
end

-- Jdtls configuration --{{{
function Jdtls_configure()
    vim.notify_once("jdtls is disabled")

    vim.notify("Tweak jdtls install_path!")
    require('jdtls').start_or_attach {
        cmd = { lspinstall_path .. '/jdtls/bin/jdtls',
        '/home/evan/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t') },
        root_dir = require('jdtls.setup').find_root({ 'gradle.build', 'pom.xml', '.git' }),
        on_attach = on_attach,
        capabilities = M.capabilities
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
    lspconfig.pylsp.setup {
        cmd = { 'pylsp_start' },
        on_attach = on_attach,
        settings = {
            pylsp = {
                plugins = get_pyls_plugins()
            }
        },
        capabilities = M.capabilities
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
