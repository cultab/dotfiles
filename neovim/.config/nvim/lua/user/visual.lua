if vim.g.nvui then
    -- Configure through vim commands
    vim.cmd [[
    ]]
end

local icons = require 'user.icons'

-- vim.g.ts_highlight_lua = true
-- vim.opt.pumblend = 20 -- pseudo transparency for popup windows

vim.o.foldtext = require 'user.foldfunc'.lua_global_func
vim.o.termguicolors = true
vim.o.laststatus = 3

vim.cmd [[highlight link CompeDocumentation Normal]]

-- Create a custom namespace. This will aggregate signs from all other
-- namespaces and only show the one with the highest severity on a
-- given line
local ns = vim.api.nvim_create_namespace("my_namespace")

-- Get a reference to the original signs handler
local orig_signs_handler = vim.diagnostic.handlers.signs

-- Override the built-in signs handler
vim.diagnostic.handlers.signs = {
    show = function(_, bufnr, _, opts)
        -- Get all diagnostics from the whole buffer rather than just the
        -- diagnostics passed to the handler
        local diagnostics = vim.diagnostic.get(bufnr)

        -- Find the "worst" diagnostic per line
        local max_severity_per_line = {}
        for _, d in pairs(diagnostics) do
            local m = max_severity_per_line[d.lnum]
            if not m or d.severity < m.severity then
                max_severity_per_line[d.lnum] = d
            end
        end

        -- Pass the filtered diagnostics (with our custom namespace) to
        -- the original handler
        local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
        orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
    end,
    hide = function(_, bufnr)
        orig_signs_handler.hide(ns, bufnr)
    end,
}

--require("lsp-colors").setup({
--    Error = "#db4b4b",
--    Warning = "#e0af68",
--    Information = "#0db9d7",
--    Hint = "#10B981"
--})

vim.diagnostic.config {
    float = {
        close_events = { 'InsertEnter' },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
    }
}

local signs = {
    Error = icons.diagnostic.error,
    Warn = icons.diagnostic.warn,
    Hint = icons.diagnostic.hint,
    Info = icons.diagnostic.info,
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- used as separator for windows

vim.opt.fillchars = {
    vert = icons.line.center_line,
    foldclose = icons.fold.close,
    foldopen = icons.fold.open,
    foldsep = icons.fold.sep,
}
vim.o.list = true
vim.opt.listchars = {
    nbsp = icons.listchars.nbsp,
    trail = icons.listchars.trail,
    tab = icons.listchars.tab,
    -- eol = "↲ ",
}

-- HACK: see: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59#issuecomment-806398054"
vim.wo.colorcolumn = "99999"

vim.o.number = true
vim.o.relativenumber = false
-- vim.o.signcolumn = 'yes:3'
vim.o.foldmethod = 'expr'
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldenable = true
vim.o.foldlevelstart = 99
vim.o.foldcolumn = "1"

vim.o.scrolloff = 1 -- keep lines above and below cursor
vim.o.sidescroll = 1
vim.o.showmode = false
vim.o.showcmd = true

vim.o.background = "dark"
vim.o.cursorline = true -- highlight current line

-- Colorscheme Options

local function scope()
    local sidebars = { "qf", "vista_kind", "terminal", "packer" }
    local transparent = false
    local lualine_bold = true
    local italic_functions = true
    local hide_inactive_status = true

    vim.g.palenight_terminal_italics = true
    vim.g.solarized_extra_hi_groups = true
    vim.g.ayucolor = "dark"

    -- Tokyonight {{{
    vim.g.tokyonight_transparent = transparent
    vim.g.tokyonight_italic_functions = italic_functions
    vim.g.tokyonight_sidebars = sidebars
    vim.g.tokyonight_lualine_bold = lualine_bold
    vim.g.tokyonight_hide_inactive_statusline = hide_inactive_status
    --}}}
    -- Gruvbox {{{
    vim.g.gruvbox_italic_functions = italic_functions
    vim.g.gruvbox_transparent = transparent
    vim.g.gruvbox_sidebars = sidebars
    vim.g.gruvbox_lualine_bold = lualine_bold
    vim.g.gruvbox_hide_inactive_statusline = hide_inactive_status
    --}}}
    -- vscode {{{
    vim.g.vscode_style = "dark"
    vim.g.vscode_italic_comment = 1
    --}}}
    -- oxocarbon {{{
    vim.g.oxocarbon_lua_keep_terminal = true
    -- }}}
end
scope()


vim.cmd [[
augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]
