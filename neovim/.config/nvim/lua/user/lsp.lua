local utils = require "user.lsp_utils"
local toMason = require "mason-lspconfig".get_mappings().lspconfig_to_mason

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.cmd [[
augroup JavaLSP
autocmd!
autocmd FileType java lua utils.Jdtls_configure()
augroup end
]]

local servers = {
    -- jedi_language_server = {},
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pydocstyle = {
                        enabled = true,
                        ignore = {
                            "D103",
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
    tsserver = {
        filetype = { "js", "ts" },
    },
    -- before_init = require 'neodev.lsp'.before_init
    lua_ls = {
        settings = {
            workspace = { checkThirdParty = false, },
            Lua = {
                diagnostics = { globals = { 'vim' } },
                runtime = { version = "LuaJit" },
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
    r_language_server = {},
    golangci_lint_ls = {
        default_config = {
            cmd = { 'golangci-lint-langserver' },
            -- root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
            init_options = {
                command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json", "--issues-exit-code=1" },
            }
        },
    },
    omnisharp = {},
    asm_lsp = {},
}

local mason_packages = {}

for server, _ in pairs(servers) do
    table.insert(mason_packages, toMason[server])
end

utils.ensure_installed(mason_packages)
utils.setup_servers(servers)
