local wezterm = require("wezterm")
local act = wezterm.action

M = {}

M.get_user_vars = function(pane)
	if pane["user_vars"] ~= nil then
		return pane.user_vars
	elseif pane["get_user_vars"] ~= nil then
		return pane:get_user_vars()
	end
end

M.get_proc_name = function(pane)
	local name = M.get_user_vars(pane)["WEZTERM_PROG"]

	if not name then
		return ""
	end

	-- get argv[0] only
	return string.gsub(name, " .*", "")
end

M.isViProcess = function(pane, _)
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
