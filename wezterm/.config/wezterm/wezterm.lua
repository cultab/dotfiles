local wezterm = require("wezterm") ---@type Wezterm
local act = wezterm.action

local hostname = wezterm.hostname
local utils = require("utils")
local get_proc_name = require("utils").get_proc_name
local conditionalActivatePane = require("utils").conditionalActivatePane

-- This table will hold the configuration.
local config = {} ---@type Config

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.window_close_confirmation = "NeverPrompt"

config.color_scheme_dirs = { "~/.config/wezterm/colors" }
config.color_scheme = require("colorscheme")

-- config.wsl_domains = { {
-- 	name = "WSL:void",
-- 	distribution = "void",
-- 	default_cwd = "~",
-- } }

-- config.ssh_domains = { {
-- 	name = "SSH:void",
-- 	remote_address = "localhost",
-- 	username = "evan",
-- } }


config.term = "wezterm"

if hostname() == "winbox" then
	config.default_domain = "WSL:void"
	config.font_dirs = { "C:/Users/evan/.local/share/fonts" }
end

if hostname() == "abyss" then
	config.default_prog = { "/home/linuxbrew/.linuxbrew/bin/zsh", "-l" }
end

if hostname() == "C-5CG54917G7" then
	config.default_domain = "SSHMUX:devpc"
	config.default_prog = { 'powershell.exe' }
end

local name
-- name = "Hermit"
-- name = "Cozette"
-- name = "CozetteHiDpi"
-- name = "CozetteVector"
-- name = "Iosevka Term"
-- name = "Terminus (TTF)"
name = "Monaspace"
-- name = "Fira Code"
-- name = "Monocraft"

-- For Cozette
if name:find("Iosevka.*") then
	config.font_size = 12
elseif name:find("Cozette") then
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
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
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

local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]
if not scheme then
	local cfg = utils.get_config_dir()
	scheme, _ = wezterm.color.load_scheme(cfg .. "/colors/" .. config.color_scheme .. ".toml")
end

local LEFT_SEPARATOR = wezterm.nerdfonts.ple_left_half_circle_thick
local RIGHT_SEPARATOR = wezterm.nerdfonts.ple_right_half_circle_thick

-- triangles 
-- local LEFT_SEPARATOR = wezterm.nerdfonts.ple_lower_right_triangle
-- local RIGHT_SEPARATOR = wezterm.nerdfonts.ple_upper_left_triangle

config.tab_bar_style = {
	new_tab = "",
	new_tab_hover = "",
}

config.colors = {
	tab_bar = {
		-- The color of the strip that goes along the top of the window
		-- (does not apply when fancy tab bar is in use)
		background = scheme.background,
	},
}

---returns str padded and truncated to be exactly n chars long
---@param str string
---@param n integer
local function fixed_width(str, n)
	local mid = math.floor(((n + 0) / 2) - #str / 2)

	return wezterm.truncate_right(wezterm.pad_right((" "):rep(mid) .. str, n), n)
end

wezterm.on(
	"format-tab-title",
	-- function(tab, tabs, panes, config, hover, max_width)
	function(tab, _, _, _, _, _)
		local proc_name = get_proc_name(tab.active_pane)

		if proc_name == "" or proc_name == nil then
			proc_name = "shell"
		end

		local format = {}
		if tab.is_active then
			format = {
				{ Background = { Color = scheme.background } },
				{ Foreground = { AnsiColor = "Blue" } },
				{ Text = LEFT_SEPARATOR },
				{ Foreground = { Color = scheme.background } },
				{ Background = { AnsiColor = "Blue" } },
				{
					Text = tab.tab_index + 1 .. ":" .. fixed_width(proc_name, 7),
				},
				{ Background = { Color = scheme.background } },
				{ Foreground = { AnsiColor = "Blue" } },
				{ Text = RIGHT_SEPARATOR },
			}
		else
			format = {
				{ Background = { Color = scheme.background } },
				{ Text = " " },
				{
					Text = tab.tab_index + 1 .. ":" .. fixed_width(proc_name, 7),
				},
				{ Text = " " },
			}
		end

		return format
	end
)

wezterm.on("update-status", function(window, pane)
	local host_icon
	local h = hostname()
	if h == "winbox" or h == "C-5CG54917G7" then
		host_icon = wezterm.nerdfonts.dev_windows
	elseif h == "void" then
		host_icon = wezterm.nerdfonts.linux_void
	elseif h == "pop-os" then
		host_icon = wezterm.nerdfonts.linux_pop_os
	elseif h == "abyss" then
		host_icon = wezterm.nerdfonts.linux_fedora
	end
	if not host_icon then
		host_icon = "n/a"
	end

	local pretty_host = " " .. host_icon .. " " .. h

	local tabs = window:mux_window():tabs()
	local mid_width = 0
	for idx, tab in ipairs(tabs) do
		-- title lenght of 9 plus 2 padding chars around the title
		-- title is 9 because the proc name is fixed to 7 + 1 ':' and the tab index (which shouldn't increase past 9 lol)
		mid_width = mid_width + 9 + 2
	end

	local tab_width = window:active_tab():get_size().cols
	local max_left = (tab_width / 2 - mid_width / 2) - #pretty_host

	window:set_left_status(wezterm.format({
		{ Background = { AnsiColor = "Blue" } },
		{ Foreground = { Color = scheme.background } },
		{ Text = pretty_host },
		{ Background = { Color = scheme.background } },
		{ Foreground = { AnsiColor = "Blue" } },
		{ Text = RIGHT_SEPARATOR },
		{ Background = { Color = scheme.background } },
		{ Text = wezterm.pad_left(" ", max_left) },
	}))

	local clock = wezterm.nerdfonts.fa_clock_o
	-- I like my date/time in this style, also: "Wed Mar 3 08:14"
	local date = wezterm.strftime("%a %b %-d %H:%M")
	window:set_right_status(wezterm.format({
		{ Background = { Color = scheme.background } },
		{ Foreground = { AnsiColor = "Blue" } },
		{ Text = LEFT_SEPARATOR },
		{ Background = { AnsiColor = "Blue" } },
		{ Foreground = { Color = scheme.background } },
		{ Text = date },
		{ Text = " " .. clock .. " " },
	}))
end)

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

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
	{ key = "s", mods = "LEADER", action = act.ShowLauncher },
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

return config
