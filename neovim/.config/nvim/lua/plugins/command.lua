return {
	'cultab/command.nvim',
	dev = true,
	dir = '/home/evan/repos/command.nvim',
	init = function()
		vim.g.command = {
			icon = require('user.icons').misc.term,
		}
	end,
	-- opts = { icon = require('user.icons').misc.term },
	-- cmd = {
	-- 	'CommandChangeDirection',
	-- 	'CommandRun',
	-- 	'CommandFile',
	-- 	'CommandLast',
	-- },
}
