local M = {}
local icons = require 'user.icons'
LastCommand = nil

local function ToggleTerm(cmd)
    require 'toggleterm'.exec(cmd)
end

local function Tmux(cmd)
    vim.notify("user/command: the tmux backend is still unimplemented")
end

local function weztermCli(subcmd)
    local cli = "wezterm cli "
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
        vim.notify("user/command failed to run command: " .. err)
        return
    end
end

local function Wezterm(cmd)
    local pane, err = weztermCli("get-pane-direction right")
    if err ~= nil then
        vim.notify("user/command: " .. err)
    end
    if not pane then
        pane = weztermCli("split-pane --right")
        _, err = weztermCli("activate-pane-direction left")
        if err ~= nil then
            vim.notify(err)
        end
    end
    weztermRun(cmd, pane)
end

-- local backend = ToggleTerm
local backend = Wezterm


M.run_command = function()
    vim.ui.input({ prompt = icons.misc.term .. "cmd: ", completion = 'shellcmd' }, function(command)
        if command then
            LastCommand = command
            backend(command)
        end
    end)
end

M.run_last_command = function()
    if LastCommand then
        backend(LastCommand)
    else
        vim.notify(icons.misc.term .. "No command to repeat", nil, { title = "mappings.lua" })
    end
end

M.run_current_file = function()
    local command = vim.api.nvim_buf_get_name(0)
    local filename = vim.fn.expand('%:t')

    -- special cases
    if filename == "report.rmd" then
        command = "make render"
    elseif filename == "report.qmd" then
        command = "quarto render " .. filename .. " --to pdf"
    elseif string.gmatch(filename, ".*\\.py") then
        command = "python3 " .. filename
    end

    backend(command)
    LastCommand = command
end

return M
