return {
    'stevearc/conform.nvim',
    config = function()
        local opts = {
            sh = { "shellcheck" },
            bib = { "bibtex_tidy" },
            toml = { "taplo" },
            css = { "stylelint" }
        }
        local mason_packages = {}
        for _, formatters in pairs(opts) do
            for _, fmt in ipairs(formatters) do
                fmt = string.gsub(fmt, "_", "-")
                table.insert(mason_packages, fmt)
            end
        end
        -- vim.notify("plugin/nvim-lint: ensure_installed:", mason_packages)
        require "user.mason_utils".ensure_installed(mason_packages)
    end,
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
