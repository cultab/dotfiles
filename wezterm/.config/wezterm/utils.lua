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

---Reads the title from either a PaneInformation snapshot (has the `title` field)
---or a live Pane object (has the `get_title()` method). This is the same title
---the left status bar shows.
---@param pane PaneInformation|Pane
---@return string?
M.get_pane_title = function(pane)
	if pane.title ~= nil then
		return pane.title
	elseif pane.get_title ~= nil then
		return pane:get_title()
	end
	return nil
end

---Resolves a display name for a tab: an explicit tab title if set, otherwise the
---basename of the active pane's foreground process, falling back to WEZTERM_PROG.
---@param tab TabInformation | MuxTab
---@return string
M.get_tab_name = function(tab)
	-- TabInformation carries `tab_title` as a field; MuxTab only has get_title()
	local title = tab.tab_title
	if title == nil and tab.get_title ~= nil then
		title = tab:get_title()
	end
	if title and #title > 0 then
		return title
	end

	-- https://wezterm.org/config/lua/PaneInformation.html
	local pane_info
	pane_info = tab.active_pane
	if type(pane_info) == "function" then
		pane_info = tab:active_pane()
	end
	-- if not pane_info then
	-- 	return "N/A"
	-- end

	-- current_working_dir is nil if I pull up the Debug Overlay for example
	-- if pane_info.current_working_dir == nil then
	-- 	-- assume the process is also nil
	-- 	return "N/A"
	-- end

	return M.get_proc_name(pane_info)
end

---Strips `--listen <socket>` out of a command string. nvim is launched with one
---and the socket path is pure noise in a tab name.
---@param s string
---@return string
local function strip_listen_socket(s)
	return (s:gsub("%s+%-%-listen[%s=]+%S+", ""))
end

---Fish-style path shortening: abbreviates intermediate dirs, except the first,
---to their first letter (keeping the dot of dot-dirs) when there are 2 or more
---of them.
---Given "~/ws/something/else" returns "~/ws/s/else".
---Anything that doesn't look like a bare path is returned unchanged.
---@param s string
---@return string
function M.shorten_path(s)
	if not s:match("^[~/]") or s:find("%s") then
		return s
	end
	local parts = {}
	for p in s:gmatch("[^/]+") do
		table.insert(parts, p)
	end
	-- "~" is kept as-is; for absolute paths the root is implicit
	local first = parts[1] == "~" and 2 or 1
	if #parts - first < 2 then
		return s
	end
	for i = first + 1, #parts - 1 do
		parts[i] = parts[i]:match("^%.?" .. utf8.charpattern) or parts[i]
	end
	local prefix = s:sub(1, 1) == "/" and "/" or ""
	return prefix .. table.concat(parts, "/")
end

---@param pane PaneInformation|Pane
---@return string
M.get_proc_name = function(pane)
	local name = "" 
	-- local name = M.get_user_vars(pane)["WEZTERM_PROG"]

	if not name then
		return "..."
	end
	if name == "" then
		-- sitting at the prompt: the pane title is more useful than "shell",
		-- but it is shell-set so it can be arbitrarily long
		local title = M.get_pane_title(pane)
		if title and #title > 0 then
			return wezterm.truncate_right(M.shorten_path(strip_listen_socket(title)), 100)
		end
		return "shell"
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
