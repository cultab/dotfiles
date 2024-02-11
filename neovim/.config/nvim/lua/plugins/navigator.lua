return {
	{
		'numToStr/Navigator.nvim',
		version = false,
		keys = {
			{ "<M-h>", "<CMD>NavigatorLeft<CR>" },
			{ "<M-j>", "<CMD>NavigatorDown<CR>" },
			{ "<M-k>", "<CMD>NavigatorUp<CR>" },
			{ "<M-l>", "<CMD>NavigatorRight<CR>" },
		},
		opts = {
			-- Save modified buffer(s) when moving to mux
			-- nil - Don't save (default)
			-- 'current' - Only save the current modified buffer
			-- 'all' - Save all the buffers
			auto_save = nil,

			-- Disable navigation when the current mux pane is zoomed in
			disable_on_zoom = false,

			-- Multiplexer to use
			-- 'auto' - Chooses mux based on priority (default)
			-- table - Custom mux to use
			mux = 'auto'
		}
	},
}
