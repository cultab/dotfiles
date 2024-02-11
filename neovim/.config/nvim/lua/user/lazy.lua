local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
	spec = {
		{ "folke/lazy.nvim" },
		{ import = "plugins" }
	},
	ui = {
		border = 'rounded',
		icons = require 'user.icons'.lazy,
	},
	defaults = {
		lazy = false,
		version = "*", -- latest tagged
		--version = false, -- latest commit
	},
	install = {
		missing = true,
		colorscheme = { require 'user.colorscheme' },
	},
	change_detection = {
		enabled = true,
		notify = true,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				-- "netrw",
				-- "netrwPlugin",
				-- "netrwSettings",
				-- "netrwFileHandlers",
				"gzip",
				"zip",
				"zipPlugin",
				"tar",
				"tarPlugin",
				"getscript",
				"getscriptPlugin",
				"vimball",
				"vimballPlugin",
				"2html_plugin",
				"logipat",
				"rrhelper",
				-- "spellfile_plugin",
				"matchit"

			}
		}
	}
}
