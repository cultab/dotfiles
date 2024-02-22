local null_ls = require 'null-ls'
local on_attach = require('user.lsp').on_attach
null_ls.setup {
	sources = {
		-- disabled{{{
		-- null_ls.builtins.code_actions.proselint,
		-- null_ls.builtins.diagnostics.vale.with({
		--     -- filetypes = {},
		--     -- filetypes = { "markdown", "tex", "text" },
		--     extra_args = { "--config=" .. vim.fn.expand("~/.config/doc/vale/.vale.ini")}
		--     -- args = { "--config=/home/evan/.config/doc/vale/.vale.ini", "--no-exit", "--output=JSON", "$FILENAME" }
		-- }),}}}
		-- Go
		-- null_ls.builtins.diagnostics.golangci_lint,
		-- R
		null_ls.builtins.formatting.styler,
		-- shell
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.diagnostics.shellcheck,
		-- null_ls.builtins.formatting.shellharden, -- 1/2 rust is borked
		-- python
		-- null_ls.builtins.diagnostics.pylint,
		-- null_ls.builtins.diagnostics.pydocstyle,
		-- null_ls.builtins.diagnostics.mypy,
		-- null_ls.builtins.formatting.black,
		-- null_ls.builtins.formatting.isort,
		-- c++
		null_ls.builtins.diagnostics.cppcheck,
		-- generic
		null_ls.builtins.formatting.trim_whitespace,
		-- null_ls.builtins.formatting.codespell,
	},
	on_attach = on_attach,
	should_attach = function(bufnr)
		-- disable on void package templates
		return not vim.api.nvim_buf_get_name(bufnr):match '.*/srcpkgs/.*/template$'
	end,
}

local mason = require 'user.mason'

local tools = {
	'shellcheck',
	'shfmt@v3.7.0',
	'shellharden',
	'black',
}

mason.ensure_installed(tools)
