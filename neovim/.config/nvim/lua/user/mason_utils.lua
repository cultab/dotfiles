-- vim.g.python3_host_prog = "~/.pyenv/versions/nvim/bin/python"

local M = {}

local Registry = require 'mason-registry'
local Package = require 'mason-core.package'

M.ensure_installed = function(tools)
    for _, tool in ipairs(tools) do
        Registry:on("package:install:failed", function (pkg, _)
            vim.notify("user/mason_utils: failed to install package: \"" .. pkg.spec.name .. "\"!")
        end)
        local name, version = Package.Parse(tool)

        if not Registry.has_package(name) then
            print("user/mason_utils error: no package with name '" .. name .. "'")
            return
        end

        local pkg = Registry.get_package(name)

        if not pkg:is_installed() then
            vim.notify("Installing " .. name .. "@latest version")
            pkg:install()
            goto continue
        -- else
        --     vim.notify(name .. "is installed")
            vim.notify("Installing " .. name .. "@" .. (version and version or "latest"))
            pkg:install( { version = version } and version or nil )
            return
        end

        pkg:get_installed_version(function(success, version_or_err)
            if not version then
                return
            end
            if not success then
                vim.notify("user/lsp error: " .. version_or_err .. " for " .. name)
                return
            end

            local is_pinned_version = version == version_or_err
            -- vim.notify(name .. ": " .. (version and version or "nil") .. "|" ..  version_or_err)
            --
            if is_pinned_version then
                -- vim.notify(name .. "@" .. installed_version .. " already installed")
                -- vim.notify(name .. "@" .. installed_version .. " already installed")
                -- vim.notify(name .. "@" .. version_or_err .. " already installed")
                return
            end

            vim.notify("Updating " .. tool .. " to @" .. version)
            pkg:install({ version = version })

        end)

        ::continue::
    end
end


return M
