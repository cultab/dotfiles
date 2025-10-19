local M = {}

local Registry = require 'mason-registry'
local Package = require 'mason-core.package'

notify = function(msg, level)
	if not level then
		level = vim.log.levels.INFO
	end
	vim.schedule(function()
		vim.notify(msg, vim.log.levels.INFO, { title = 'Mason utils:' })
	end)
end

Registry:on('package:install:failed', function(pkg, _)
	notify('failed to install package: "' .. pkg.spec.name .. '"!', vim.log.levels.ERROR)
end)
Registry:on('package:install:success', function(pkg, _)
	notify('installed package: "' .. pkg.spec.name .. '"!', vim.log.levels.ERROR)
end)

M.ensure_installed = function(tools)
	for _, tool in ipairs(tools) do
		local name, version = Package.Parse(tool)

		if not Registry.has_package(name) then
			notify('no package with name "' .. name .. '"', vim.log.levels.ERROR)
			return
		end

		local pkg = Registry.get_package(name)

		if not pkg:is_installed() then
			notify('installing ' .. name .. '...')
			pkg:install()
			return
		end

		::continue::
	end
end

return M
