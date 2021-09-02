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

    --  TODO: escape more than '*' and '-', should escape all magic chars instead
    before = string.gsub(before, '%*', '%%*')
    after = string.gsub(after, '%*', '%%*')
    before = string.gsub(before, '%-', '%%-')
    after = string.gsub(after, '%-', '%%-')

    -- remove fold markers
    line = string.gsub(line, '}' .. '}}', '' ) -- HACK: split fold markers to trick vim to not see them
    line = string.gsub(line, '{' .. '{{', '' )

    -- remove comment string
    line = string.gsub(line, before, '')
    line = string.gsub(line, after, '')

    print(before)
    return line .. " ﬌ " .. fend - start .. " lines"
end--}}}

O.termguicolors = true
O.foldtext = 'v:lua.MyFoldText()'

cmd [[highlight link CompeDocumentation Normal]]

--{{{ lsp

-- vim.g.coq_settings = { display = { pum = { source_context = {"",""} } } }
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local icons = {--{{{
    Class       = " (Class)",
    Color       = " (Color)",
    Constant    = " (Constant)",
    Constructor = " (Constructor)",
    Enum        = " (Enum)",
    EnumMember  = " (EnumMember)",
    Field       = " (Field)",
    File        = " (File)",
    Folder      = " (Folder)",
    Function    = " (Function)",
    Interface   = " (Interface)",
    Keyword     = " (Keyword)",
    Method      = "ƒ (Method)",
    Module      = " (Module)",
    Property    = " (Property)",
    Snippet     = "﬌ (Snippet)",
    Struct      = " (Struct)",
    Text        = " (Text)",
    Unit        = " (Unit)",
    Value       = " (Value)",
    Variable    = " (Variable)",
}--}}}

local kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(kinds) do
    kinds[i] = icons[kind] or kind
end

-- Capture real implementation of function that sets signs{{{
-- NOTE: see https://www.reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a/
local orig_set_signs = vim.lsp.diagnostic.set_signs
local set_signs_limited = function(diagnostics, bufnr, client_id, sign_ns, opts)

    -- original func runs some checks, which I think is worth doing
    -- but maybe overkill
    if not diagnostics then
        diagnostics = diagnostic_cache[bufnr][client_id]
    end

    -- early escape
    if not diagnostics then
        return
    end

    -- Work out max severity diagnostic per line
    local max_severity_per_line = {}
    for _,d in pairs(diagnostics) do
        if max_severity_per_line[d.range.start.line] then
            local current_d = max_severity_per_line[d.range.start.line]
            if d.severity < current_d.severity then
                max_severity_per_line[d.range.start.line] = d
            end
        else
            max_severity_per_line[d.range.start.line] = d
        end
    end

    -- map to list
    local filtered_diagnostics = {}
    for i,v in pairs(max_severity_per_line) do
        table.insert(filtered_diagnostics, v)
    end

    -- call original function
    orig_set_signs(filtered_diagnostics, bufnr, client_id, sign_ns, opts)
end
vim.lsp.diagnostic.set_signs = set_signs_limited--}}}
--}}}

 -- used as separator for windows
O.fillchars = "vert:│"
O.listchars = "nbsp:␣,trail:·,extends:>,precedes:<,tab:  "
-- for tab : ┊
O.list = true
G.indent_blankline_enabled = true
G.indent_blankline_char = '│' -- '┊'
G.indent_blankline_filetype_exclude = {'help', 'terminal', 'dashboard'}
G.indent_blankline_use_treesitter = true
G.indent_blankline_show_current_context = true
G.indent_blankline_context_patterns = { 'class', 'function', 'method', '^if', '^while', '^for', '^table', 'block', 'arguments', 'loop' }
--  HACK: see: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59#issuecomment-806398054
vim.wo.colorcolumn = "99999"

O.number = true
O.relativenumber = false
O.signcolumn = 'auto:2-4'
O.foldmethod = 'marker'

O.scrolloff=3 -- keep lines above and below cursor
O.sidescroll=6
O.showmode = false
O.showcmd = true

-- o.colorcolumn = "80"
O.background = "dark"
O.cursorline = true -- highlight current line

-- Colorscheme Options
--
local sidebars = { "qf", "vista_kind", "terminal", "packer" }
local lualine_bold = true
local italic_functions = true
local hide_inactive_status = true

G.palenight_terminal_italics = true
G.solarized_extra_hi_groups = true
-- g.lightline#colorscheme#github_light#faithful = 0
G.ayucolor = "dark"
G.tokyonight_style = "night"

-- Tokyonight {{{
G.tokyonight_style = "night"
G.tokyonight_italic_functions = italic_functions
G.tokyonight_sidebars = sidebars
G.tokyonight_lualine_bold = lualine_bold
G.tokyonight_hide_inactive_statusline = hide_inactive_status
--}}}
-- Gruvbox {{{
G.gruvbox_italic_functions = italic_functions
G.gruvbox_sidebars = sidebars
G.gruvbox_lualine_bold = lualine_bold
G.gruvbox_hide_inactive_statusline = hide_inactive_status
--}}}

cmd "colorscheme neon_latte"

-- HACK: see https://github.com/hoob3rt/lualine.nvim/issues/276
if not LOAD_lualine then
    require('lualine').setup{
        options = { theme = "catppuccino" }
    }
end

LOAD_lualine = true

function Reload_statusline(theme)
    require("plenary.reload").reload_module("lualine", true)
    require('lualine').setup{
        options = { theme = theme }
    }
end

cmd [[
augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]
