return {
    {
        'williamboman/mason.nvim',
        config = function()
            require 'mason'.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜ ",
                        package_uninstalled = "✗"
                    }
                }
            })
            local lsp = require 'user.lsp'

            lsp.ensure_installed {
                -- "bash-language-server",
                -- "typescript-language-server",
                "python-lsp-server",
                "lua-language-server",
                "gopls",
                "clangd",
                -- "golangci-lint-langserver",
                -- "pylyzer"
            }
            return

                lsp.setup_servers {
                    -- jedi_language_server = {},
                    pylsp = { settings = { pylsp = { plugins = {
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
                    } } }, },
                    -- pylyzer = {},
                    bashls = {},
                    tsserver = {
                        filetype = { "js", "ts" },
                    },
                    -- before_init = require 'neodev.lsp'.before_init
                    lua_ls = { settings = {
                        workspace = {
                            checkThirdParty = false,
                        },
                        Lua = {
                            diagnostics = { globals = { 'vim' } }
                        }
                    },
                    },
                    gopls = { settings = { gopls = {
                        semanticTokens = true,
                        staticcheck = true
                    }
                    }
                    },
                    texlab = { filetypes = { "plaintex", "tex", "rmd", "quarto" }, },
                    clangd = {
                        capabilities = vim.tbl_deep_extend("force", lsp.capabilities, { offsetEncoding = "utf-16" }),
                        filetypes = { "c", "cpp", "cuda" }
                    },
                    r_language_server = {},
                    golangci_lint_ls = { default_config = {
                        cmd = { 'golangci-lint-langserver' },
                        -- root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
                        init_options = {
                            command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format",
                                "json",
                                "--issues-exit-code=1" },
                        }
                    },
                    },
                    omnisharp = {},
                    asm_lsp = {},
                }
        end
    },
    'williamboman/mason-lspconfig.nvim',
    {
        'neovim/nvim-lspconfig',
        version = false,
    },
    'folke/lsp-colors.nvim',
}
