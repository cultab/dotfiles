local M = {}
LastCommand = nil

M.run_command = function()
    vim.ui.input({ prompt = "cmd: ", completion = 'shellcmd' }, function (command)
        if command then
            LastCommand = command
            vim.cmd(":1TermExec cmd='" .. command .. "'")
        end
    end)
end

M.run_last_command = function()
    if LastCommand then
        vim.cmd(":1TermExec cmd='" .. LastCommand .. "'")
    else
        vim.notify("No command to repeat", nil, { title = "mappings.lua" })
    end
end

M.run_current_file = function()
    local command = vim.api.nvim_buf_get_name(0)
    local filename = vim.fn.expand('%:t')

    -- special cases
    if filename == "report.rmd" then
        command = "make render"
    elseif filename == "report.qmd" then
        command = "quarto render " .. filename .. "--to pdf"
    end

    vim.cmd(":1TermExec cmd='" .. command .. "'")
    LastCommand = command
end

return M
