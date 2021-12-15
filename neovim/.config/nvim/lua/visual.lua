function _G.MyFoldText()--{{{
    -- get vim variables needed
    local start = vim.v.foldstart
    local fend = vim.v.foldend
    local line = vim.fn.getline(start)
    local comment_string = vim.api.nvim_buf_get_option(0, 'commentstring')

    -- extract before and after comment characters (if they exist)
    local s_loc = string.find(comment_string, '%%s')
    local before = string.remove(comment_string, s_loc, #comment_string + 1)
    local after = string.remove(comment_string, 1, s_loc + 2)

    -- create strings of spaces of the correct length to replace the comment strings
    -- only do it for the comment string that's before the comment,
    -- so the comment starts at the same column when folding
    local before_space = ''
    for _=1 , #before do
        before_space = before_space .. ' '
    end

    -- for the other half incase I change my mind
    local after_space = ''
    -- for _=1, #after  do
    --     after_space = after_space .. ' '
    -- end

    --  TODO: escape more than '*' and '-', should escape all magic chars instead
    before = string.gsub(before, '%*', '%%*')
    after = string.gsub(after, '%*', '%%*')
    before = string.gsub(before, '%-', '%%-')
    after = string.gsub(after, '%-', '%%-')

    -- remove fold markers
    line = string.gsub(line, '}' .. '}}', '' ) -- HACK: split fold markers to trick vim to not see them, when editing this file
    line = string.gsub(line, '{' .. '{{', '' )

    -- remove comment string
    line = string.gsub(line, before, before_space)
    line = string.gsub(line, after, after_space)

    return line .. " ﬌ " .. fend - start .. " lines"
end--}}}

vim.o.termguicolors = true
vim.o.foldtext = 'v:lua.MyFoldText()'

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

--{{{ lsp

require("lsp-colors").setup({
    Error = "#db4b4b",
    Warning = "#e0af68",
    Information = "#0db9d7",
    Hint = "#10B981"
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- local icons = {--{{{
--     Class       = " (Class)",
--     Color       = " (Color)",
--     Constant    = " (Constant)",
--     Constructor = " (Constructor)",
--     Enum        = " (Enum)",
--     EnumMember  = " (EnumMember)",
--     Field       = " (Field)",
--     File        = " (File)",
--     Folder      = " (Folder)",
--     Function    = " (Function)",
--     Interface   = " (Interface)",
--     Keyword     = " (Keyword)",
--     Method      = "ƒ (Method)",
--     Module      = " (Module)",
--     Property    = " (Property)",
--     Snippet     = "﬌ (Snippet)",
--     Struct      = " (Struct)",
--     Text        = " (Text)",
--     Unit        = " (Unit)",
--     Value       = " (Value)",
--     Variable    = " (Variable)",
-- }--}}}

-- local kinds = vim.lsp.protocol.CompletionItemKind
-- for i, kind in ipairs(kinds) do
--     kinds[i] = icons[kind] or kind
-- end

--}}}

 -- used as separator for windows
vim.o.fillchars = "vert:│"
--  HACK: see: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59#issuecomment-806398054
vim.o.listchars = "nbsp:␣,trail:·,extends:>,precedes:<,tab:  "
vim.o.list = true

require("indent_blankline").setup {
    -- enabled = true,
    char = '┊', -- '│┊'
    use_treesitter = true,
    show_current_context = true,
    show_first_indent_level = false,
    show_trailing_blankline_indent = true,
    filetype_exclude = {'help', 'terminal', 'dashboard', 'lspinstaller'},
    context_patterns = { 'class', 'function', 'method', '^if', '^while', '^for', '^table', 'block', 'arguments', 'loop' },
    space_char_blankline = " ",
}

vim.wo.colorcolumn = "99999"

vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = 'auto:2-4'
vim.o.foldmethod = 'marker'

vim.o.scrolloff=3 -- keep lines above and below cursor
vim.o.sidescroll=6
vim.o.showmode = false
vim.o.showcmd = true

-- o.colorcolumn = "80"
vim.o.background = "dark"
vim.o.cursorline = true -- highlight current line

-- Colorscheme Options
--
local sidebars = { "qf", "vista_kind", "terminal", "packer" }
local transparent = false
local lualine_bold = true
local italic_functions = true
local hide_inactive_status = true

vim.g.palenight_terminal_italics = true
vim.g.solarized_extra_hi_groups = true
-- g.lightline#colorscheme#github_light#faithful = 0
vim.g.ayucolor = "dark"

-- Tokyonight {{{
vim.g.tokyonight_style = "storm"
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

vim.cmd "colorscheme gruvbox-flat"

vim.cmd [[
augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]
