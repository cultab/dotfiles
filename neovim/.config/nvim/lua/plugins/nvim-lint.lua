return {
	'mfussenegger/nvim-lint',
	config = function()
		require('lint').linters_by_ft = {
			-- cpp       = { 'clang-tidy' },
			gitcommit = { 'gitlint' },
			go = { 'golangcilint' },
			sh = { 'shellcheck' },
			bash = { 'shellcheck' },
			zsh = { 'zsh' },
			make = { 'checkmake' },
			dockerfile = { 'hadolint' },
			rust = { 'ruff' },
		}
		-- vim.print("plugin/nvim-lint: ensure_installed:", mason_packages)
		require('user.mason_utils').ensure_installed {
			'golangci-lint',
			'shellcheck',
			'checkmake',
			'hadolint',
			'ruff',
		}

		vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'InsertLeave', 'BufWritePost' }, {
			callback = function()
				require('lint').try_lint()
				-- vim.notify("Tried to lint: " .. math.random())
			end,
		})
	end,
	event = 'VeryLazy',
}
