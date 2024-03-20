local icons = require 'user.icons'

---@alias Buffer table
---@alias Component table

return {
	{
		'willothy/nvim-cokeline',
		dependencies = {
			'nvim-lua/plenary.nvim', -- Required for v0.4.0+
			'nvim-tree/nvim-web-devicons',
		},
		version = false,
		event = 'VeryLazy',
		config = function()
			local coke = require 'cokeline'
			local is_picking_focus = require('cokeline.mappings').is_picking_focus
			local is_picking_close = require('cokeline.mappings').is_picking_close

			local is_picking = function()
				return is_picking_close() or is_picking_focus()
			end

			local get_hex = require('cokeline.hlgroups').get_hl_attr

			local active = get_hex('TabLineSel', 'bg')
			local inactive = get_hex('PmenuThumb', 'bg')

			local normal = get_hex('Normal', 'fg')
			local bg = get_hex('Normal', 'bg')

			coke.setup {
				---@type integer
				show_if_buffers_are_at_least = 1,

				buffers = {
					-- A looser version of `filter_valid`, use this function if you still
					-- want the `cokeline-{switch,focus}-{prev,next}` mappings to work for
					---@type false | fun(buf: Buffer):boolean
					filter_visible = function(buffer)
						return not buffer.is_focused
					end,
				},
				default_hl = {
					fg = function(buffer)
						if buffer.is_focused then
							return bg
						else
							return normal
						end
					end,

					bg = function(buffer)
						if buffer.is_focused then
							return active
						else
							return inactive
						end
					end,

					-- default: unset.
					---@type nil | string | function(buffer): string,
					sp = nil,

					---@type nil | boolean | fun(buf: Buffer):boolean
					bold = nil,
					---@type nil | boolean | fun(buf: Buffer):boolean
					italic = nil,
					---@type nil | boolean | fun(buf: Buffer):boolean
					underline = nil,
					---@type nil | boolean | fun(buf: Buffer):boolean
					undercurl = nil,
					---@type nil | boolean | fun(buf: Buffer):boolean
					strikethrough = nil,
				},

				-- The highlight group used to fill the tabline space
				fill_hl = 'TabLineFill',

				---@type Component[]
				components = {
					{
						text = function(buffer)
							local special_ft = {
								TelescopePrompt = { name = 'Telescope', icon = icons.misc.term },
								dashboard = { name = 'Dashboard', icon = icons.misc.dashboard },
								oil = { name = 'Oil', icon = icons.misc.folder },
								help = { icon = '󰞋' },
								DressingInput = { name = 'Prompt', icon = '' },
							}

							if buffer.is_first then
								local filename, icon
								local s = special_ft[vim.bo.filetype]
								if s ~= nil then
									filename = s.name
									icon = s.icon
								end

								if not filename then
									filename = vim.fn.expand '%:t' or 'n/a'
								end

								if not icon then
									icon = require('nvim-web-devicons').get_icon_by_filetype(vim.bo.filetype) or '[f]'
								end

								return ' ' .. icon .. ' ' .. filename .. ' ' .. icons.separator.left
							else
								return ''
							end
						end,
						fg = bg,
						bg = active,
					},
					{
						text = icons.separator.left,
						fg = function(buffer)
							if buffer.is_focused then
								return active
							else
								return inactive
							end
						end,
						bg = bg,
					},
					{
						text = function(buffer)
							if is_picking() then
								return ' ' .. buffer.pick_letter .. ' '
							else
								return ' ' .. buffer.devicon.icon
							end
						end,
						fg = function(buffer)
							if is_picking() then
								return vim.g.terminal_color_1
							else
								if buffer.is_focused then
									return bg
								else
									return buffer.devicon.color
								end
							end
						end,
						bold = is_picking(),
					},
					{
						text = function(buffer)
							return buffer.unique_prefix
						end,
						fg = get_hex('Comment', 'fg'),
						italic = true,
					},
					{
						text = function(buffer)
							return buffer.filename .. ' '
						end,
					},
					{
						text = 'x',
						on_click = function(_, _, _, _, buffer)
							buffer:delete()
						end,
					},
					{
						text = ' ',
					},
					{
						text = icons.separator.right,
						fg = function(buffer)
							if buffer.is_focused then
								return active
							else
								return inactive
							end
						end,
						bg = bg,
					},
					{
						text = ' ',
						bg = bg,
					},
				},
			}
		end,
	},
}
