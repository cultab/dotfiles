return {
	'stevearc/conform.nvim',
	config = function()
		require 'conform'.setup {
			sh = { "shellcheck" },
			bib = { "bibtex_tidy" },
			toml = { "taplo" },
			css = { "stylelint" }
		}
		require "user.mason_utils".ensure_installed {
			"shellcheck",
			"bibtex-tidy",
			"taplo",
			"stylelint",
		}
	end,
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
