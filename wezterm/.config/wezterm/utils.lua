local wezterm = require("wezterm") ---@type Wezterm
local act = wezterm.action
local mux = wezterm.mux

M = {}

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function M.basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

M.get_user_vars = function(pane)
	if pane.user_vars ~= nil then
		return pane.user_vars
	elseif pane.get_user_vars ~= nil then
		return pane:get_user_vars()
	end
end

M.get_tab_name = function(tab)
	local title = tab.tab_title
	if title and #title > 0 then
		return title
	end

	-- https://wezfurlong.org/wezterm/config/lua/pane/index.html
	local pane_info = tab.active_pane
	local cwd = pane_info.current_working_dir

	-- cwd is nil if I pull up the Debug Overlay for example
	if cwd == nil then
		-- assume process is also nil
		return "N/A"
	end

	-- https://wezfurlong.org/wezterm/config/lua/wezterm.mux/get_pane.html
	local pane = mux.get_pane(pane_info.pane_id)
	-- https://wezfurlong.org/wezterm/config/lua/pane/get_foreground_process_info.html
	local process_info = pane:get_foreground_process_info()
    if process_info ~= nil then
	    local process_name = process_info.executable
	    process_name = M.basename(process_name)
		return process_name
    end

	return M.get_proc_name(tab.active_pane)
end
---comment
---@param pane TabInformation|MuxTab
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

---returns wezterm's config dir, respecting XDG_CONFIG_HOME and falling back to HOME/.config
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
        return "C:/Users/katsandr/.config/wezterm"
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
