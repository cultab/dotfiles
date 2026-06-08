local wezterm = require("wezterm") ---@type Wezterm
local act = wezterm.action
local mux = wezterm.mux

M = {}

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
---@param s string
---@return string
function M.basename(s)
	return (string.gsub(s, "(.*[/\\])(.*)", "%2"))
end

---Reads user vars from either a PaneInformation snapshot (has the `user_vars`
---field) or a live Pane object (has the `get_user_vars()` method).
---@param pane PaneInformation|Pane
---@return table<string, string>
M.get_user_vars = function(pane)
	if pane.user_vars ~= nil then
		return pane.user_vars
	elseif pane.get_user_vars ~= nil then
		return pane:get_user_vars()
	end
	return {}
end

---Resolves a display name for a tab: an explicit tab title if set, otherwise the
---basename of the active pane's foreground process, falling back to WEZTERM_PROG.
---@param tab TabInformation
---@return string
M.get_tab_name = function(tab)
	local title = tab.tab_title
	if title and #title > 0 then
		return title
	end

	-- https://wezterm.org/config/lua/PaneInformation.html
	local pane_info = tab.active_pane

	-- current_working_dir is nil if I pull up the Debug Overlay for example
	if pane_info.current_working_dir == nil then
		-- assume the process is also nil
		return "N/A"
	end

	-- https://wezterm.org/config/lua/wezterm.mux/get_pane.html
	local pane = mux.get_pane(pane_info.pane_id)
	if pane ~= nil then
		-- https://wezterm.org/config/lua/pane/get_foreground_process_info.html
		local process_info = pane:get_foreground_process_info()
		if process_info ~= nil then
			return M.basename(process_info.executable)
		end
	end

	return M.get_proc_name(pane_info)
end

---@param pane PaneInformation|Pane
---@return string
M.get_proc_name = function(pane)
	local name = M.get_user_vars(pane)["WEZTERM_PROG"]

	if not name then
		return ""
	end

	-- get argv[0] only
	return (string.gsub(name, " .*", ""))
end

M.isViProcess = function(pane, _)
	-- HACK: workaround for workvim not having Navigator.nvim
	if true then
		return false
	end
	local patterns = {
		"n?vim",
		"git", -- from `git commit`
		"gc",
		"gca",
	}
	for _, ptrn in ipairs(patterns) do
		if M.get_proc_name(pane):find(ptrn) ~= nil then
			return true
		end
	end
	return false
end

---returns wezterm's config dir, respecting XDG_CONFIG_HOME and falling back to HOME/.config (Linux/macOS) or %USERPROFILE%/.config (Windows)
---@return string
function M.get_config_dir()
	local dir = os.getenv("XDG_CONFIG_HOME")
	if dir then
		return dir .. "/wezterm"
	end

	local home = os.getenv("HOME")
	if home then
		dir = home .. "/.config"
		return dir .. "/wezterm"
	end

	-- Try Windows fallback
	local userprofile = os.getenv("USERPROFILE")
	if userprofile then
		dir = userprofile .. "\\.config"
		return dir .. "\\wezterm"
	end

	-- Last resort: current directory
	return ".wezterm"
end

M.conditionalActivatePane = function(window, pane, pane_direction, vim_direction)
	if M.isViProcess(pane, window) then
		window:perform_action(
			-- This should match the keybinds you set in Neovim.
			act.SendKey({ key = vim_direction, mods = "ALT" }),
			pane
		)
	else
		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
	end
end

return M
