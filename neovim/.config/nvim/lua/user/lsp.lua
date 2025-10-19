local M = {}
local utils = require 'user.mason_utils'
local lspconfig = require 'lspconfig'
local toMason = require('mason-lspconfig').get_mappings().lspconfig_to_package

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- local capabilities = {}

local servers = {
	rust_analyzer = {},
	jedi_language_server = {},
	nil_ls = {},
	-- pylsp = {
	-- 	settings = {
	-- 		pylsp = {
	-- 			plugins = {
	-- 				pydocstyle = {
	-- 					enabled = true,
	-- 					ignore = {
	-- 						'D101',
	-- 						'D102',
	-- 						'D103',
	-- 						'D105',
	-- 						'D203',
	-- 						'D107',
	-- 						'D100',
	-- 						'D212',
	-- 					},
	-- 				},
	-- 				mypy = { enabled = true },
	-- 				pylint = {
	-- 					enabled = false,
	-- 					ignore = {
	-- 						'C0116',
	-- 						'C0114',
	-- 					},
	-- 				},
	-- 				jedi_completion = { enabled = true },
	-- 				rope_completion = {
	-- 					enabled = false,
	-- 					eager = true,
	-- 				},
	-- 				isort = { enabled = true },
	-- 			},
	-- 		},
	-- 	},
	-- },
	-- pylyzer = {},
	ts_ls = {
		filetype = { 'js', 'ts' },
	},
	lua_ls = {
		settings = {
			Lua = {
				hint = { enable = true },
				diagnostics = { globals = { 'vim' } },
				runtime = { version = 'LuaJIT' },
			},
			workspace = {
				checkThirdParty = false,
			},
		},
	},
	gopls = {
		settings = {
			gopls = {
				semanticTokens = true,
				-- staticcheck = true,
				analyses = {
					unusedparams = true,
				},
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	},
	-- texlab = { filetypes = { 'plaintex', 'tex', 'rmd', 'quarto' } },
	clangd = {
		capabilities = vim.tbl_deep_extend('force', capabilities, { offsetEncoding = 'utf-16' }),
		filetypes = { 'c', 'cpp', 'cuda' },
	},
	-- omnisharp = {},
	asm_lsp = {},
	r_language_server = {},
	golangci_lint_ls = {
		default_config = {
			cmd = { 'golangci-lint-langserver' },
			root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
			init_options = {
				command = {
					'golangci-lint',
					'run',
					'--enable-all',
					'--disable',
					'lll',
					'--out-format',
					'json',
					'--issues-exit-code=1',
				},
			},
		},
	},
}

-- local mason_packages = {}
--
-- for server, _ in pairs(servers) do
-- 	table.insert(mason_packages, toMason[server])
-- end
--
-- utils.ensure_installed(mason_packages)

local border = {
	{ '╭', 'FloatBorder' },
	{ '─', 'FloatBorder' },
	{ '╮', 'FloatBorder' },
	{ '│', 'FloatBorder' },
	{ '╯', 'FloatBorder' },
	{ '─', 'FloatBorder' },
	{ '╰', 'FloatBorder' },
	{ '│', 'FloatBorder' },
}

-- LSP settings (for overriding per client)
local handlers = {
	['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

local on_attach = function()
	-- require('lsp_signature').on_attach {
	-- 	bind = true,
	-- 	doc_lines = 0,
	-- 	hint_enable = true,
	-- 	hint_prefix = ' ', -- TODO: replace with user.icons reference
	-- 	handler_opts = {
	-- 		border = 'rounded', -- double, rounded, single, shadow, none, or a table of borders
	-- 	},
	-- }

	require('user.mappings').set_lsp_mappings()
	vim.lsp.inlay_hint.enable()
end

-- setup all servers
for server, extra in pairs(servers) do
	local settings = {
		on_attach = on_attach,
		capabilities = capabilities,
		handlers = handlers,
	}

	settings = vim.tbl_deep_extend('force', settings, extra)
	lspconfig[server].setup(settings)
end

return M
