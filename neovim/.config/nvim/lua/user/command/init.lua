local M = {}
local icons = require 'user.icons'
local notify = require'user.command.utils'.notify

LastCommand = nil


CommandDirection = 1
local config = {}
local backend

--- @type backend[]
local backends = {
	wezterm = require'user.command.wezterm',
	tmux = require'user.command.tmux',
	toggleterm = require'user.command.toggleterm',
}

local default_opts = {
	use = "wezterm"
}

M.setup = function (opts)
	config = vim.tbl_deep_extend('force', default_opts, opts or {})
	config.backend = backends[config.use]
	if not config.backend then
		notify("No such backend: " .. config.use, 'error')
	end
end

M.change_direction = function ()
	if not config.backend.directions then
		notify("Changing directions is not supported using backend: " .. config.use, 'error')
		return
	end
	CommandDirection = (CommandDirection % #config.backend.directions + 1)
	notify("Changed command direction to ".. config.backend.directions[CommandDirection].name, 'info')
end

vim.api.nvim_create_user_command("CommandDirection", M.change_direction, {desc = "Toggles pane direction for running commands"})


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
				config.backend.run(command)
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
	--         config.backend.run(command)
	--     end
	-- end)
end

M.run_last_command = function()
	if LastCommand then
		config.backend.run(LastCommand)
	else
		notify("No command to repeat", 'warn')
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
						config.backend.run("chmod +x " .. filepath)
						config.backend.run(command)
						LastCommand = command
					else
						notify("didn't run file, as it's not executable", 'info')
					end
				end)
			goto exit
		end
	end

	::run::
	config.backend.run(command)
	LastCommand = command
	::exit::
end

return M
