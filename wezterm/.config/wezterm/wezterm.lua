local wezterm = require("wezterm") ---@type Wezterm
local act = wezterm.action

local utils = require("utils")
local conditionalActivatePane = utils.conditionalActivatePane

-- This table will hold the configuration.
local config = {} ---@type Config
SPACE = ""

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.enable_kitty_graphics = true
config.window_close_confirmation = "NeverPrompt"

config.color_scheme_dirs = { "~/.config/wezterm/colors" }
config.color_scheme = require("colorscheme")

config.wsl_domains = { {
	name = "WSL Ubuntu",
	distribution = "Ubuntu",
	default_cwd = "~",
} }

-- config.ssh_domains = { {
-- 	name = "SSH:void",
-- 	remote_address = "localhost",
-- 	username = "evan",
-- } }

config.ssh_domains = {
	{
		name = "vps",
		remote_address = "vps"
	},
	{
		name = "devpc",
		remote_address = "devpc",
		local_echo_threshold_ms = 200,
	},
}

config.term = "xterm"

local hostname = wezterm.hostname()
local font = nil
if hostname == "winbox" then
	config.default_domain = "WSL:void"
	config.font_dirs = { "C:/Users/evan/.local/share/fonts" }
end

if hostname == "abyss" then
	config.default_prog = { "/home/linuxbrew/.linuxbrew/bin/zsh", "-l" }
	font = "Monaspace"
end

if hostname == "L-5CG54917G7" then
	-- config.default_domain = "devpc"
	-- config.default_prog = { "powershell.exe" }
	config.scrollback_lines = 10000
	font = "Iosevka Term"
end

if font == nil then
	font = 'Iosevka'
end
-- extra space for fonts like Iosevka

-- font = "Hermit"
-- font = "Cozette"
-- font = "CozetteHiDpi"
-- font = "CozetteVector"
-- font = "Terminus (TTF)"
-- font = "Monaspace"
-- font = "Fira Code"
-- font = "Monocraft"
config = require("fonts").set_font(config, font)


-- config.enable_tab_bar = true
config.enable_wayland = true
config.use_fancy_tab_bar = false
config.window_decorations = "NONE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
-- config.freetype_load_flags = "DEFAULT"

-- config.allow_square_glyphs_to_overflow_width = "Never"
-- cell_width = 1.1,

config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = false

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

-- "Black", "White"  "Silver" }
local colors =
	{ "Maroon", "Green", "Olive", "Navy", "Purple", "Teal", "Red", "Lime", "Yellow", "Blue", "Fuchsia", "Aqua" }
local force_colors = {
	default = "Yellow",
	abyss = "Teal",
	laptop = "Blue",
	devpc = "Maroon",
}
-- local colors = { "Maroon", "Green", "Olive", "Navy", "Purple", "Teal", "Red", "Lime", "Yellow", "Blue", "Fuchsia", "Aqua" }

local GHhash = function(str)
	-- https://gist.github.com/scheler/26a942d34fb5576a68c111b05ac3fabe
	-- also try https://github.com/lancelijade/qqwry.lua/blob/master/crc32.lua

	-- HACK: truncated just enough so cursor's animated titles stops being annoying
	str = wezterm.truncate_right(str, 26)
	local h = 5381
	for c in str:gmatch(".") do
		h = ((h << 5) + h) + string.byte(c)
	end

	-- wezterm.log_info("str: '" .. str .. "' hash: " .. h)
	return h
end

wezterm.on(
	"format-tab-title",
	-- function(tab, tabs, panes, config, hover, max_width)
	function(tab, _, _, _, hover, _)
		local tab_name = utils.get_tab_name(tab)

		local idx = (GHhash(tab_name) % #colors) + 1
		local tab_color = colors[idx]
		local format = {}
		if tab.is_active then
			format = {
				{ Background = { Color = scheme.background } },
				{ Foreground = { AnsiColor = tab_color } },
				{ Text = LEFT_SEPARATOR },
				{ Foreground = { Color = scheme.background } },
				{ Background = { AnsiColor = tab_color } },
				{
					Text = tab.tab_index + 1 .. ": " .. tab_name,
				},
				{ Background = { Color = scheme.background } },
				{ Foreground = { AnsiColor = tab_color } },
				{ Text = RIGHT_SEPARATOR },
			}
		elseif hover then
			format = {
				{ Background = { Color = scheme.background } },
				{ Foreground = { AnsiColor = tab_color } },
				{ Attribute = { Intensity = "Bold" } },
				{ Attribute = { Italic = false } },
				{ Text = " " },
				{
					Text = tab.tab_index + 1 .. ": " .. tab_name,
				},
				{ Text = " " },
			}
		else
			format = {
				{ Background = { Color = scheme.background } },
				{ Foreground = { AnsiColor = tab_color } },
				{ Text = " " },
				{
					Text = tab.tab_index + 1 .. ": " .. tab_name,
				},
				{ Text = " " },
			}
		end

		return format
	end
)

-- WezTerm truncates the whole rendered tab title (separators included) to
-- config.tab_max_width, which defaults to 16; keep it high enough that names
-- are never cut off.
config.tab_max_width = 255

wezterm.on("update-status", function(window, pane)
	local host_icon
	local h = utils.get_user_vars(pane)["WEZTERM_HOST"]
	if not h then
		h = wezterm.hostname()
	end
	host_name = h
	-- IDEA: turn into function that returns an obj with hostname and icon, also use icon for tabs
	if h == "winbox" then
		host_icon = wezterm.nerdfonts.dev_windows
		host_name = "win"
	elseif h == "void" then
		host_icon = wezterm.nerdfonts.linux_void
	elseif h == "pop-os" then
		host_icon = wezterm.nerdfonts.linux_pop_os
	elseif h == "abyss" then
		host_icon = wezterm.nerdfonts.linux_fedora
	elseif h:find("bakatsandr1") then
		host_icon = wezterm.nerdfonts.linux_ubuntu
		host_name = "devpc"
	elseif h == "L-5CG54917G7" then
		host_icon = wezterm.nerdfonts.linux_ubuntu
		host_name = "laptop"
	end
	if not host_icon then
		host_icon = "n/a"
	end

	local status_color = force_colors[host_name] or force_colors.default

	local pretty_host = " " .. host_icon .. SPACE
	local workspace = window:mux_window():get_workspace()

	local tabs = window:mux_window():tabs()
	local mid_width = 0
	for idx, tab in ipairs(tabs) do
		local tab_name = utils.get_tab_name(tab)

		-- +5 is the rendering around the name: a separator/space on each side
		-- plus "N: " (the idx shouldn't increase past 9 lol)
		-- column_width, not #: tab names can hold wide/multi-byte glyphs
		mid_width = mid_width + wezterm.column_width(tab_name) + 5
	end

	-- wezterm.log_info("a: ", wezterm.column_width(pretty_host))
	-- wezterm.log_info("b: ", wezterm.column_width(workspace))
	local tab_width = window:active_tab():get_size().cols
	-- wezterm.log_info("midwidth: " .. mid_width)
	local max_left = (tab_width - mid_width) / 2
		- wezterm.column_width(pretty_host)
		- wezterm.column_width(workspace)
		-- - wezterm.column_width(title)
	
		max_left = math.max(0, max_left)

	local left_cells = {
		{ Background = { AnsiColor = status_color } },
		{ Foreground = { Color = scheme.background } },
		{ Text = pretty_host .. " " .. workspace },
		{ Background = { Color = scheme.background } },
		{ Foreground = { AnsiColor = status_color } },
		{ Text = RIGHT_SEPARATOR },
		{ Text = wezterm.pad_left(" ", max_left) },
	}


	window:set_left_status(wezterm.format(left_cells))

	local function bat_icon(b)
		local pct = math.floor(b.state_of_charge * 100 + 0.5)
		local rounded = math.max(10, math.min(100, math.floor((pct + 5) / 10) * 10))
		-- HACK: when "Full" force key to "_nil+rounded" which does not exist as an icon, falling back to md_battery
		-- FIXME: just use 2 icons for Full = no icon, Charging = bolt, Discharing = down arrow
		local key = (b.state == "Charging" and "md_battery_charging_" or b.state == "Full" and "_nil" or "md_battery_")
			.. rounded
		return wezterm.nerdfonts[key] or wezterm.nerdfonts.md_battery
	end

	local dir = pane:get_current_working_dir()

	local bat = ""
	for _, b in ipairs(wezterm.battery_info()) do
		bat = bat_icon(b) .. " " .. string.format("%.0f%%", b.state_of_charge * 100)
	end

	local meta = pane:get_metadata() or {}
	local tardy = "ok"
	if meta.is_tardy then
		local secs = meta.since_last_response_ms / 1000.0
		tardy = string.format("%5.1fs⏳", secs)
	end
	-- wezterm.log_info("scheme bg" .. scheme.background)
	-- wezterm.log_info("status" .. status_color)
	local right_status = {
		{ Background = { Color = scheme.background } },
		{ Foreground = { AnsiColor = status_color } },
		{ Text = LEFT_SEPARATOR },
		{ Background = { AnsiColor = status_color } },
		{ Foreground = { Color = scheme.background } },
		{ Text = bat .. SPACE },
		{ Text = tardy .. SPACE },
		{ Text = "@" .. host_name .. " " },
	}
	window:set_right_status(wezterm.format(right_status))
end)

config.launch_menu = {}

for use, port in pairs({ srmcp = 8787, srchat = 8790 }) do
	table.insert(config.launch_menu, {
		label = "Port forward " .. port .. " for " .. use,
		domain = { DomainName = "local" }, -- the local domain
		args = {
			"ssh",
			"-L",
			port .. ":localhost:" .. port,
			"devpc", -- hardcoded hostname
		},
	})
end

config.disable_default_key_bindings = true
config.leader = {
	key = "s",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}

config.keys = {
	{
		key = "r",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Rename workspace:",
			action = wezterm.action_callback(function(window, _, line)
				if line and line ~= "" then
					wezterm.mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
	{
		key = "t",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Rename tab (empty to clear):",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "\\", mods = "LEADER", action = act.SplitPane({ direction = "Right" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitPane({ direction = "Left" }) },
	{ key = "-", mods = "LEADER", action = act.SplitPane({ direction = "Down" }) },
	{ key = "_", mods = "LEADER|SHIFT", action = act.SplitPane({ direction = "Up" }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "d", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
	{
		key = "s",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "FUZZY|DOMAINS|WORKSPACES|LAUNCH_MENU_ITEMS" }),
	},
	{ key = "s", mods = "LEADER|CTRL", action = act.ActivateCopyMode },
	{ key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "l", mods = "LEADER", action = act.ShowDebugOverlay },
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = "ALT", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "ALT", action = act.ActivateTabRelative(-1) },
	{ key = "h", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-left") },
	{ key = "j", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-down") },
	{ key = "k", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-up") },
	{ key = "l", mods = "ALT", action = act.EmitEvent("ActivatePaneDirection-right") },
	{ key = "h", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 4 }) },
	{ key = "j", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 4 }) },
	{ key = "k", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 4 }) },
	{ key = "l", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 4 }) },
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
	{ key = "u", mods = "ALT", action = act.ScrollToPrompt(-1) },
	{ key = "d", mods = "ALT", action = act.ScrollToPrompt(1) },
}

for i = 1, 10 do
	if i == 10 then
		key = 0
	else
		key = i
	end
  table.insert(config.keys, {
    key = tostring(key),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
end


config.mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = act.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
	-- Slower scroll up/down (3 lines instead of Page Up/Down)
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "NONE",
		action = wezterm.action.ScrollByLine(-2),
		alt_screen = false,
	},
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "NONE",
		action = wezterm.action.ScrollByLine(2),
		alt_screen = false,
	},
}

config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Linkify things that look like URLs with numeric addresses as hosts.
-- E.g. http://127.0.0.1:8000 for a local development server,
-- or http://192.168.1.1 for the web interface of many routers.
table.insert(config.hyperlink_rules, {
	regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
	format = "$0",
})

-- examples: RFC822 RFC-2324 rfc-422
table.insert(config.hyperlink_rules, {
	regex = [[(RFC|rfc|Rfc)-?([0-9]{1,5})]],
	format = "https://datatracker.ietf.org/doc/html/rfc$2",
	-- format = "https://www.rfcreader.com/#rfc$2"
})

local ok, mod = pcall(require, "internal")
if ok then
	config = mod.clickable_testbed(config)
end

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
