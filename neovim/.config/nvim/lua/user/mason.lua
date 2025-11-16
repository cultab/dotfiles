local M = {}

local Registry = require 'mason-registry'
local Package = require 'mason-core.package'

function M.ensure_installed(tools)
	for _, tool in ipairs(tools) do
		local name, version = Package.Parse(tool)

		local pkg = Registry.get_package(name)

		if not pkg:is_installed() then
			vim.notify('Installing ' .. name .. '@' .. (version and version or 'latest'))
			pkg:install({ version = version } and version or nil)
			return
		end

		pkg:get_installed_version(function(success, version_or_err)
			if not success then
				vim.notify('mason get installed version error: ' .. version_or_err .. '\n' .. 'tool:' .. name)
				return
			end

			local is_pinned_version = version == version_or_err
			-- vim.notify(name .. ": " .. (version and version or "nil") .. "|" ..  version_or_err)
			--
			if is_pinned_version or not version then
				-- vim.notify(name .. "@" .. version_or_err .. " already installed")
				return
			end

			vim.notify('Updating ' .. tool .. ' to @' .. version)
			pkg:install { version = version }
		end)
	end
end

return M
