local function get_fd()
	local suc, errcode, ret = os.execute 'fd'

	vim.notify 'plugin/telescope: could not find fd (get it?)'
	return 'asdfg'
end

return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		{ 'xiyaowong/telescope-emoji.nvim' },
		{ '2kabhishek/nerdy.nvim', cmd = 'Nerdy' },
		{ 'nvim-lua/popup.nvim' },
		{ 'nvim-lua/plenary.nvim' },
	},
	config = function()
		local actions = require 'telescope.actions'

		-- HACK: see: https://github.com/nvim-telescope/telescope.nvim/issues/2501#issuecomment-1561838990
		vim.api.nvim_create_autocmd('WinLeave', {
			callback = function()
				if vim.bo.ft == 'TelescopePrompt' and vim.fn.mode() == 'i' then
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'i', false)
				end
			end,
		})

		require('telescope').setup {
			defaults = {
				-- file_sorter = require'telescope.sorters'.get_fzy_sorter,
				-- generic_sorter = require'telescope.sorters'.get_fzy_sorter,
				mappings = { i = { ['<esc>'] = actions.close } },
			},
		}
		require('telescope').load_extension 'emoji'
		require('telescope').load_extension 'fzf'
	end,
}
