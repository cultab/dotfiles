return {
    "mfussenegger/nvim-lint",
    config = function()
        local linters_by_ft = {
            -- cpp = { 'clang-tidy' },
            gitcommit = { 'commitlint' },
            go = { "golangcilint" },
            sh = { "shellcheck" },
            bash = { "shellcheck" },
            css = { "stylelint" },
            zsh = { "zsh" },
        }
        require('lint').linters_by_ft = linters_by_ft
        local mason_packages = {}
        for _, linters in pairs(linters_by_ft) do
            if linters.skip then
                goto continue
            end
            for _, linter in ipairs(linters) do
                table.insert(mason_packages, linter)
            end
            ::continue::
        end
        table.insert(mason_packages, "golangci-lint")
        -- vim.print("plugin/nvim-lint: ensure_installed:", mason_packages)
        require"user.mason_utils".ensure_installed(mason_packages)
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
    end
}
