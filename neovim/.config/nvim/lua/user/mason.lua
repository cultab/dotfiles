local M = {}

require'mason'.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜ ",
            package_uninstalled = "✗"
        }
    }
})

local registry = require'mason-registry'

M.ensure_installed = function(tools)
    for _, tool in pairs(tools) do
        -- support auto-installing pinned versions
        local version = nil -- disable for now
        local package = registry.get_package(tool)
        if not package:is_installed() then
            if version then
                vim.notify("Installing " .. tool .. "@v" .. version)
                package:install(version)
            else
                vim.notify("Installing " .. tool  .. " latest version")
                package:install()
            end
        end
    end
end

return M
