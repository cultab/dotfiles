local M = {}

local cmp = require 'cmp'
local luasnip = require 'luasnip'

-- load my mapping DSL
local map = require "user.map".map
local partial = require "user.util".partial

-- easier navigation in normal / visual / operator pending mode
map "n" { "nzz" }
map "N" { "Nzz" }
map "*" { "*zz" }
map "#" { "#zz" }

-- slice line
map "S" { "i<CR><ESC>k$" }

-- This unsets the last search pattern register by hitting ESC
map "<esc>" { "<cmd>nohlsearch<cr>" }

-- Change text without putting the text into register                                                                                                                                                                asdasfdsakfjhkjhkjashdkjhsakjdhkjhsadh                     askjdhkjhsakjdhsakjddddddddddddddddda sdha kjshdkj ha
map "c" { "\"_c" }
map "C" { "\"_C" }
map "p" { "\"_dP", "", 'v' }
map "cc" { "\"_cc" }
map "x" { "\"_x" }

--  I never use Ex mode, so re-run macros instead
map "Q" { "@@" }

map '<leader>=' { partial(require "conform".format, { async = true, lsp_fallback = true }), "Format buffer [Conform]", 'nv' }

-- sane movement through wrapping lines
map "j" { "gj", nil, 'nv' }
map "k" { "gk", nil, 'nv' }

map "U" { "<C-r>", "Redo" }
map "H" { "^", "Goto Line Beginning" }
map "L" { "$", "Goto Line End" }

map "<leader><space>" { "<cmd>ToggleTerm 1<CR>", "Toggle terminal" }

map "<leader>c" { nil, "Run command" }
map "<leader>cc" { require "user.command".run_command, "Run command" }
map "<leader>cl" { require "user.command".run_last_command, "Repeat last command" }
map "<leader>cr" { require "user.command".run_current_file, "Run current file" }

map "<leader>o" { require 'user.configs'.config_picker, "Open config picker" }

map "<leader>t" { nil, "Text operations", 'nv' }
map "<leader>tt" { ":Tabularize<space>/", "Tabularize", 'v' }
map "<leader>ta" { "<cmd>EasyAlign<CR>", "Easy Align", 'v' }
map "<leader>te" { "<cmd>Telescope emoji<CR>", "Emoji Picker" }
map "<leader>tt" { "<cmd>Telescope todo-comments<CR>", "Todo, Fixme etc.", 'n' }

map "<leader>b" { "<cmd>BufferPick<CR>", "Pick buffer" }
map "<leader>f" { require "telescope.builtin".find_files, "Find files" }
map "<leader>/" { require "telescope.builtin".live_grep, "Live grep" }
map "<leader>h" { require "telescope.builtin".help_tags, "Search help tags" }
map "<leader>n" { require "user.newfile".new_file, "New file" }
map "<leader>x" { function() vim.api.nvim_buf_delete(0, {}) end, "Delete buffer" }
map "<leader>d" { "<CMD>Lexplore<CR>", "Open file explorer" }

map "<leader>g" { nil, "Version Control [Git]" }
map "<leader>gs" { require "gitsigns".stage_hunk, "Stage hunk" }
map "<leader>gr" { require "gitsigns".reset_hunk, "Reset hunk" }
map "<leader>gR" { require "gitsigns".reset_buffer, "Reset buffer" }
map "<leader>gp" { require "gitsigns".preview_hunk, "Preview hunk" }
map "<leader>gb" { require "gitsigns".blame_line, "Blame line" }
-- map "<leader>gn" { require"neogit".open,                    "Open Neogit" }
-- map "<leader>gc" { require"telescope.builtin".git_commits, "Commits"  }
-- map "<leader>gb" { require"telescope.builtin".git_branches, "Branches" }
-- map "<leader>gs" { require"telescope.builtin".git_status,   "Status"   }
-- map "<leader>gp" { require"telescope.builtin".git_bcommits, "Commits in buffer" }

map "<M-h>" { "<CMD>NavigatorLeft<CR>" }
map "<M-j>" { "<CMD>NavigatorDown<CR>" }
map "<M-k>" { "<CMD>NavigatorUp<CR>" }
map "<M-l>" { "<CMD>NavigatorRight<CR>" }


map '<C-d>' { function()
    if not require("cmp").scroll_docs(4) then
        return "<C-d>"
    end
end, "Scroll documentation down", expr = true
}

map '<C-u>' { function()
    if not require("cmp").scroll_docs(-4) then
        return "<C-u>"
    end
end, "Scroll documentation up", expr = true
}

---
---If any LSP server attached to the current buffer can provide the @server_capability,
---use @lsp_func with @lsp_args as arguments else use the normal mode command @vim_cmd.
---
---@param server_capability string
---@param lsp_func function
---@param lsp_args table | any
---@param vim_cmd string
---@return nil
local function if_lsp_else_vim(server_capability, lsp_func, lsp_args, vim_cmd)
    local clients = vim.lsp.get_active_clients { bufn = 0 }
    local capabillity_supported = false
    for _, client in ipairs(clients) do
        if client.server_capabilities[server_capability] and client.name ~= "null-ls" then
            capabillity_supported = true
            break
        end
    end

    if capabillity_supported then
        if type(lsp_args) == "table" then
            lsp_args = unpack(lsp_args)
        end
        lsp_func(lsp_args)
    else
        vim.cmd(vim.api.nvim_replace_termcodes(vim_cmd, true, false, true))
    end
end

map 'K' { partial(if_lsp_else_vim, "hoverProvider", vim.lsp.buf.hover, {}, ":normal! K"), "Hover documentation" }
-- map '<leader>=' { partial(if_lsp_else_vim, "documentFormattingProvider", vim.lsp.buf.format, { async = true }, ":normal gg=G<C-o>"), "Format buffer", 'n' }
-- map '=' { partial(if_lsp_else_vim, "documentFormattingProvider", vim.lsp.buf.range_formatting, { async = true }, "="), "Format buffer", 'v' }


function M.set_lsp_mappings()
    map 'gD' { vim.lsp.buf.declaration, "Goto declaration [LSP]" }
    map 'gd' { vim.lsp.buf.definition, "Goto definition [LSP]" }
    map 'gi' { vim.lsp.buf.implementation, "Goto implementation [LSP]" }
    map '<C-k>' { vim.lsp.buf.signature_help, "Open signature help [LSP]", "i" }
    map '<leader>D' { vim.lsp.buf.type_definition, "Show type definition [LSP]" }
    map '<leader>R' { vim.lsp.buf.references, "Show references [LSP]" }
    map '<leader>r' { vim.lsp.buf.rename, "Rename symbol [LSP]" }
    map '<A-CR>' { vim.lsp.buf.code_action, "Code Action [LSP]" }
    map '[' { vim.diagnostic.goto_prev, "Previous diagnostic [LSP]" }
    map ']' { vim.diagnostic.goto_next, "Next diagnostic [LSP]" }
    map '<leader>e' { function() vim.diagnostic.open_float(nil, { focusable = false }) end, "Show line diagnostics [LSP]" }
    map '<leader>q' { function() vim.diagnostic.setloclist() end, " Open quickfix [LSP] " }
end

function M.get_cmp_mappings()
    return {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }
        ),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }
        ),
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }
end

function M.set_welcome_mappings()
    vim.cmd [[
    nnoremap <buffer> q <CMD>q<CR>
    augroup DASH
    autocmd!
    autocmd BufLeave <buffer> bdelete
    augroup END
    ]]
end

-- TODO: in lua or remove entirely
vim.cmd [[
" barbar
" Move to previous/next
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <A-[> :BufferMovePrevious<CR>
nnoremap <silent>    <A-]> :BufferMoveNext<CR>
" Close buffer
nnoremap <silent>    <A-c> :BufferClose<CR>
]]

-- from the good ol' init.vim
-- it's mostly vim-compatible
-- so it stays here for now
-- TODO: in lua
vim.cmd [[
" so much more convenient
map <space> <leader>
]]



-- TODO: in lua
vim.cmd [[
" sometimes I get off the shift key too slowly, ~~maybe don't do it then?~~,
" HA abbr to the rescue
cabbr Q q
cabbr W w
cabbr Wq wq
cabbr WQ wq
cabbr Wa wa
cabbr WA wa
]]

-- Unused for now {{{
local nop = function(nothing)
    return nothing
end


nop [[
" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz

" cut line
nnoremap S i<CR><ESC>k$

" split prefix, C-w is taken by tmux
" nnoremap <C-a> <C-w>

" This unsets the last search pattern register by hitting ESC
nnoremap <silent><ESC> :nohlsearch<CR>

" easier navigation in normal / visual / operator pending mode
noremap H ^
noremap L $

" Change text without putting the text into register
noremap c "_c
noremap C "_C
vnoremap p "_dP
noremap cc "_cc
noremap x "_x

" I never use Ex mode, so re-run macros instead
nnoremap Q @@

" sane movement through wrapping lines
noremap <silent>j gj
noremap <silent>k gk
]] -- }}}
return M
