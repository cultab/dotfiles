local M = {}

M.new_file = function()
	vim.ui.input({ prompt = 'file name: ', completion = 'file' }, function(file_name)
		if file_name then
			vim.cmd('tabnew ' .. file_name)
		end
	end)
end

return M
