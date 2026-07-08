local wezterm = require("wezterm") ---@type Wezterm

local M = {}

-- TODO: use this
local fonts = {
	cozette = {
		{ family = "CozetteHiDpi" },
		{ family = "CozetteHiDpi", assume_emoji_presentation = true },
	},
}

M.set_font = function(config, name)
	if name:find("Iosevka") then
		SPACE = " "
	end
	-- For Cozette
	if name:find("Iosevka.*") then
		config.font_size = 12
	end

	if name:find("Cozette") then
		config.font = wezterm.font_with_fallback({
			{ family = name, assume_emoji_presentation = true },
			{ family = name },
		})
		config.custom_block_glyphs = false

		config.underline_thickness = "2px"
		config.underline_position = "-2px"

		-- disable italics :(
		config.font_rules = {
			{
				italic = true,
				font = wezterm.font({
					family = name,
					weight = "Bold",
					style = "Normal",
				}),
			},
		}
		-- disable italics and bold :(, :)
		config.font_rules = {
			{
				italic = true,
				font = wezterm.font({
					family = name,
					weight = "Bold",
					style = "Normal",
				}),
			},
			{
				italic = false,
				intensity = "Bold",
				font = wezterm.font({
					family = name,
					weight = "Regular",
					style = "Normal",
				}),
			},
		}

		-- default to size for normal cozette
		config.font_size = 6
		if name:find(".*HiDpi") then
			wezterm.log_info("HiDpi")
			config.font_size = 12
		elseif name:find(".*Vector") then
			config.font_size = 9 -- or 19
		end
	elseif name:find("Monaspace") then
		-- if hostname() ~= "void" then
		config.font_size = 12
		-- end
		config.line_height = 1.1
		config.underline_position = "-2px"
		config.font = wezterm.font_with_fallback({
			{ family = "Monaspace Neon" },
		})
		config.font_rules = {
			{ -- Xenon is dim
				italic = false,
				intensity = "Half",
				font = wezterm.font({
					family = "Monaspace Xenon",
					weight = "Light",
					style = "Normal",
				}),
			},
			{ -- Argon is bold
				italic = false,
				intensity = "Bold",
				font = wezterm.font({
					family = "Monaspace Argon",
					weight = "Bold",
					style = "Normal",
				}),
			},
			{ -- Radon is italic
				intensity = "Bold",
				italic = true,
				font = wezterm.font({
					family = "Monaspace Radon",
					weight = "Bold",
					style = "Italic",
				}),
			},
			{ -- Radon is italic
				italic = true,
				intensity = "Half",
				font = wezterm.font({
					family = "Monaspace Radon",
					weight = "Light",
					style = "Italic",
				}),
			},
			{ -- Radon is italic
				italic = true,
				intensity = "Normal",
				font = wezterm.font({
					family = "Monaspace Radon",
					style = "Normal",
				}),
			},
		}
	else
		config.font = wezterm.font_with_fallback({
			{ family = name },
		})
	end
	return config
end

return M
