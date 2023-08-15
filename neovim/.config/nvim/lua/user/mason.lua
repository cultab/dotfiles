local M = {}

require 'mason'.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜ ",
            package_uninstalled = "✗"
        }
    }
})

local Registry = require 'mason-registry'
local Package = require 'mason-core.package'

M.ensure_installed = function(tools)
    for _, tool in ipairs(tools) do
        local name, version = Package.Parse(tool)

        local pkg = Registry.get_package(name)

        if not pkg:is_installed() then
            vim.notify("Installing " .. name .. "@latest version")
            pkg:install()
            return
        end

        pkg:get_installed_version(function(success, version_or_err)
            if not success then
                vim.notify("error: " .. version_or_err)
                return
            end

            -- local installed_version = string.sub(version_or_err, 2, #version_or_err)
            local installed_version = version_or_err
            local is_pinned_version = version == installed_version
            -- vim.notify(name .. ": " .. (version and version or "nil") .. "|" ..  version_or_err)
            --
            if is_pinned_version or not version then
                -- vim.notify(name .. "@" .. installed_version .. " already installed")
                return
            end

            vim.notify("Updating " .. tool .. " to version v" .. version)
            pkg:install({ version = version })

        end)

    end
end

return M
