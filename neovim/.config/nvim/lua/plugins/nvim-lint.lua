return {
    "mfussenegger/nvim-lint",
    config = function()
        require('lint').linters_by_ft = {
            -- cpp = { 'clang-tidy' },
            gitcommit = { 'commitlint' },
            go = { "golangcilint" },
            sh = { "shellcheck" },
            bash = { "shellcheck" },
            css = { "stylelint" },
            zsh = { "zsh" },
        }
        -- vim.print("plugin/nvim-lint: ensure_installed:", mason_packages)
        require "user.mason_utils".ensure_installed {
            "commitlint",
            "golangci-lint",
            "shellcheck",
            "stylelint",
        }
        vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
    end
}
