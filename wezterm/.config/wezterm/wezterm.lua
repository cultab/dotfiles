local wezterm = require("wezterm")
local act = wezterm.action

local hostname = wezterm.hostname
local get_proc_name = require("utils").get_proc_name
local conditionalActivatePane = require("utils").conditionalActivatePane

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme_dirs = { "~/.config/wezterm/colors" }
config.color_scheme = require("colorscheme")

config.wsl_domains = { {
	name = "WSL:void",
	distribution = "void",
	default_cwd = "~",
} }

config.ssh_domains = { {
	name = "SSH:void",
	remote_address = "localhost",
	username = "evan",
} }

config.term = "wezterm"
config.default_domain = hostname() == "winbox" and "SSH:void" or nil

local name
name = "Hermit"
-- name = "Cozette"
-- name = "CozetteHiDpi"
-- name = "CozetteVector"
-- name = "Iosevka Term"
-- name = "Terminus (TTF)"
-- name = "Monaspace"

-- For Cozette
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

	-- default to size for normal cozette
	config.font_size = 6
	if name:find(".*HiDpi") then
		wezterm.log_info("HiDpi")
		config.font_size = 12
	elseif name:find(".*Vector") then
		config.font_size = 19
	end
elseif name:find("Monaspace") then
	if hostname() ~= "void" then
		config.font_size = 12
	end
	config.line_height = 1.2
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

-- enable_tab_bar = false
config.use_fancy_tab_bar = false
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}
-- config.freetype_load_flags = "DEFAULT"

-- allow_square_glyphs_to_overflow_width = "Never",
-- cell_width = 1.1,

config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false

-- config.mux_output_parser_coalesce_delay_ms = 3
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 144

config.disable_default_key_bindings = true
config.leader = {
	key = "s",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}
config.keys = {
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "d", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "s", mods = "LEADER", action = act.ShowTabNavigator },
	{ key = "l", mods = "LEADER", action = act.ShowDebugOverlay },
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "h", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-left") },
	{ key = "j", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-down") },
	{ key = "k", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-up") },
	{ key = "l", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-right") },
	{ key = "h", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 4 }) },
	{ key = "j", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 4 }) },
	{ key = "k", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 4 }) },
	{ key = "l", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 4 }) },
	{ key = "s", mods = "LEADER|CTRL", action = act.ActivateCopyMode },
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
	{ key = "u", mods = "ALT", action = act.ScrollToPrompt(-1) },
	{ key = "d", mods = "ALT", action = act.ScrollToPrompt(1) },
}
config.mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = act.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
}

config.hyperlink_rules = {
	-- Linkify things that look like URLs and the host has a TLD name.
	-- Compiled-in default. Used if you don't specify any hyperlink_rules.
	{
		regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
		format = "$0",
	},

	-- linkify email addresses
	-- Compiled-in default. Used if you don't specify any hyperlink_rules.
	{
		regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
		format = "mailto:$0",
	},

	-- file:// URI
	-- Compiled-in default. Used if you don't specify any hyperlink_rules.
	{
		regex = [[\bfile://\S*\b]],
		format = "$0",
	},

	-- Linkify things that look like URLs with numeric addresses as hosts.
	-- E.g. http://127.0.0.1:8000 for a local development server,
	-- or http://192.168.1.1 for the web interface of many routers.
	{
		regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
		format = "$0",
	},

	-- -- Make task numbers clickable
	-- -- The first matched regex group is captured in $1.
	-- {
	--     regex = [[\b[tT](\d+)\b]],
	--     format = 'https://example.com/tasks/?t=$1',
	-- },
	--
	-- -- Make username/project paths clickable. This implies paths like the following are for GitHub.
	-- -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
	-- -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
	-- -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
	{
		regex = [[["' /]([\w\d]{1}[-\w\d]*)/([\w\d]{1}[\.\-\w\d]*)["' ]{1}]],
		format = "https://www.github.com/$1/$2",
	},
}

wezterm.on("ActivatePaneDirection-right", function(window, pane)
	conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	conditionalActivatePane(window, pane, "Down", "j")
end)

if hostname() == "winbox" then
	config.font_dirs = { "C:/Users/evan/.local/share/fonts" }
	wezterm.on(
		"format-tab-title",
		-- function(tab, tabs, panes, config, hover, max_width)
		function(tab, _, _, _, _, _)
			local proc_name = get_proc_name(tab.active_pane)

			if proc_name == "" or proc_name == nil then
				proc_name = "shell"
			end

			local title = tab.tab_index + 1 .. ": " .. proc_name
			return {
				{ Text = " " .. title .. " " },
			}
		end
	)
end

wezterm.on("update-status", function(window, pane)
	local host_icon
	local h = hostname()
	if h == "winbox" then
		host_icon = wezterm.nerdfonts.dev_windows
	elseif h == "void" then
		host_icon = wezterm.nerdfonts.linux_void
	elseif h == "pop-os" then
		host_icon = wezterm.nerdfonts.linux_pop_os
	end
	if not host_icon then
		host_icon = "n/a"
	end
	window:set_left_status(wezterm.format({
		{ Background = { AnsiColor = "Blue" } },
		{ Foreground = { AnsiColor = "Black" } },
		{ Text = " " .. host_icon .. " SYSTEM " },
	}))
	local clock = wezterm.nerdfonts.fa_clock_o
	-- I like my date/time in this style, also: "Wed Mar 3 08:14"
	local date = wezterm.strftime("%a %b %-d %H:%M")
	window:set_right_status(wezterm.format({
		-- { Background = { AnsiColor = "Blue" } },
		-- { Foreground = { AnsiColor = "Black" } },
		{ Text = " " .. clock .. " " },
		{ Text = date .. " " },
	}))
end)

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

return config
