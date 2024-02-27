local M = {}
local icons = require 'user.icons'
LastCommand = nil

---@enum level
local levels = {
	TRACE = 0,
	DEBUG = 1,
	INFO = 2,
	WARN = 3,
	ERROR = 4,
	OFF = 5,
}
---@param msg string
---@param level level
local function notify(msg, level)
	vim.notify(msg, level, { title = "user/command.lua", icon = icons.misc.term })
end

local function ToggleTerm(cmd)
	require 'toggleterm'.exec(cmd)
end

local function Tmux(cmd)
	notify("the tmux backend is still unimplemented", "warn")
end


---Returns executable suffix based on platform
---REF: Navigator.nvim
---@return string
local function suffix()
	local uname = vim.loop.os_uname()
	if string.find(uname.release, 'WSL.*$') or string.find(uname.sysname, '^Win') then
		return '.exe'
	end
	return ''
end

--- @class direction
--- @field new string
--- @field old string
--- @field split string
--- @type direction[]
local directions = {
	{
		new = "right",
		old = "left",
		split = "right"
	},
	{
		new = "down",
		old = "up",
		split = "bottom"
	},
}

do
	CommandDirection = 1
end

vim.api.nvim_create_user_command("CommandDirection", function ()
	CommandDirection = (CommandDirection % 2 + 1)
end, {desc = "Toggles pane direction for running commands"})


local function weztermCli(subcmd)
	local cli = "wezterm" .. suffix() .. " cli "
	local pipe = io.popen(cli .. subcmd)
	if not pipe then
		return "", "failed to run wezterm cli subcmd: " .. subcmd
	end
	local ret = pipe:read()
	pipe:close()
	return ret, nil
end

local function weztermRun(cmd, pane_id)
	local _, err = weztermCli("send-text --no-paste --pane-id " .. pane_id .. " -- '" .. cmd .. "\n'")
	if err ~= nil then
		notify("failed to run command: " .. err, levels.ERROR)
		return
	end
end

local function Wezterm(cmd)
	local direction = directions[CommandDirection]
	local pane, err = weztermCli("get-pane-direction ".. direction.new)
	if err ~= nil then
		notify(err, levels.ERROR)
	end
	if not pane then
		pane = weztermCli("split-pane --" .. direction.split)
		_, err = weztermCli("activate-pane-direction " .. direction.old)
		if err ~= nil then
			notify(err, levels.ERROR)
		end
	end
	weztermRun(cmd, pane)
end

-- local backend = ToggleTerm
local backend = Wezterm

local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local popup_options = {
	relative = "editor",
	position = '50%',
	size = {
		width = 24,
	},
	border = {
		style = "rounded",
		text = {
			top = icons.misc.term .. "cmd: ",
			top_align = "left",
		},
	},
	win_options = {
		winhighlight = "Normal:Normal",
	},
}

M.run_command = function()
	local input = Input(popup_options, {
		prompt = "$ ",
		default_value = "",
		on_close = function()
			-- print("Input closed!")
		end,
		on_submit = function(command)
			if command then
				LastCommand = command
				backend(command)
			end
		end,
		-- on_change = function(value)
		--     print("Value changed: ", value)
		-- end,
	})

	-- unmount component when cursor leaves buffer
	input:on(event.BufLeave, function()
		input:unmount()
	end)

	input:on(event.InsertLeave, function()
		input:unmount()
	end)
	-- mount/open the component
	input:mount()
	-- vim.ui.input({ prompt = icons.misc.term .. "cmd: ", completion = 'shellcmd' }, function(command)
	--     if command then
	--         LastCommand = command
	--         backend(command)
	--     end
	-- end)
end

M.run_last_command = function()
	if LastCommand then
		backend(LastCommand)
	else
		notify("No command to repeat", levels.WARN)
	end
end


--- @alias rule table<string, fun(string?):string>
--- @type rule[]
local rules = {
	["report%.rmd"] = function(_)
		return "make render"
	end,
	["%.qmd"] = function(_)
		return "quarto render"
	end,
	[".*%.py"] = function(filepath)
		return "python3 " .. filepath
	end,
	[".*%.lua"] = function(filepath)
		return "nvim -l " .. filepath
	end,
	["Makefile"] = function(_)
		return "make"
	end,
}

M.run_current_file = function()
	local command = vim.api.nvim_buf_get_name(0)
	local filename = vim.fn.expand('%:t')
	local filepath = vim.fn.expand('%:p')

	for pattern, callback in pairs(rules) do
		if string.find(filename, pattern) then
			command = callback(filepath)
			goto run
		end
	end

	do -- HACK: restrict scope of local 'perms' so we can goto after it :)
		-- if we're gonna run the file as is, check if it's executable first
		local perms = vim.fn.getfperm(filepath)
		if not perms:find("x") then
			vim.ui.select({ "Yes", "No" }, {
					prompt = icons.misc.term .. "make executable?"
				},
				function(choice)
					if choice and choice:find("[Yy]") then
						backend("chmod +x " .. filepath)
						backend(command)
						LastCommand = command
					else
						notify("didn't run file, as it's not executable", levels.INFO)
					end
				end)
			goto exit
		end
	end

	::run::
	backend(command)
	LastCommand = command
	::exit::
end

return M
