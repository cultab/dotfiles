local M = {}

local partial = require('user.util').partial
local luasnip = require 'luasnip'
local telescope = require 'telescope.builtin'

-- load my mapping DSL
local map = require('user.map').map

-- easier navigation in normal / visual / operator pending mode
map 'n' { 'nzz' }
map 'N' { 'Nzz' }
map '*' { '*zz' }
map '#' { '#zz' }

-- slice line
map 'S' { 'i<CR><ESC>k$' }

-- This unsets the last search pattern register by hitting ESC
map '<esc>' { vim.cmd.nohlsearch }

-- Change text without putting the text into register
map 'c' { '"_c' }
map 'C' { '"_C' }
map 'p' { '"_dP', '', 'v' }
map 'cc' { '"_cc' }
map 'x' { '"_x' }

--  I never use Ex mode, so re-run macros instead
map 'Q' { '@@' }

map '<leader>=' {
	partial(require('conform').format, { async = true, lsp_fallback = true }),
	'format buffer [Conform]',
	'nv',
}

-- sane movement through wrapping lines
map 'j' { 'gj', nil, 'nv' }
map 'k' { 'gk', nil, 'nv' }

map 'H' { '^', 'Goto Line Beginning', nil, 'nv' }
map 'L' { '$', 'Goto Line End', nil, 'nv' }

map '<leader>c' { nil, 'Run command' }
map '<leader>cc' { require('user.command').run_command, 'shell [c]ommand' }
map '<leader>cl' { require('user.command').run_last_command, 'repeat [l]ast command' }
map '<leader>cr' { require('user.command').run_current_file, '[r]un current file' }

map '<leader>o' { require('user.configs').config_picker, '[o]pen config picker' }

map '<leader>t' { nil, '[t]ext/[t]elescope', 'nv' }
map '<leader>tt' { ':Tabularize<space>/', '[t]abularize', 'v' }
map '<leader>te' { vim.cmd.EasyAlign, '[e]asy align', 'v' }
map '<leader>te' { require('telescope').extensions.emoji.emoji, '[e]moji Picker' }
map '<leader>tk' { telescope.keymaps, '[k]eymaps' }
map '<leader>tn' { vim.cmd.Nerdy, '[n]erdfont Symbols' }
map '<leader>tc' { partial(vim.cmd.Telescope, 'todo-comments'), 'todo [c]omments' }

map '<leader>l' { vim.cmd.Lazy, '[l]azy pkg manager' }

map '<leader><space>' { vim.cmd.BufferPick, 'Pick Buffer' }
map '<leader>f' { partial(telescope.find_files, { follow = true, hidden = true }), '[f]ind files' }
map '<leader>/' { partial(telescope.live_grep, { additional_args = { '--follow' } }), 'Live grep' }
map '<leader>h' { telescope.help_tags, 'Search [h]elp Tags' }
map '<leader>n' { require('user.newfile').new_file, '[n]ew file' }
map '<leader>x' {
	function()
		vim.api.nvim_buf_delete(0, {})
	end,
	'Delete buffer',
}
map '<leader>e' { partial(vim.cmd.e, '.'), 'Open file [e]xplorer' }

map '<leader>g' { nil, '[g]it' }
map '<leader>gs' { partial(vim.cmd.Gitsigns, 'stage_hunk'), '[s]tage hunk' }
map '<leader>gr' { partial(vim.cmd.Gitsigns, 'reset_hunk'), '[r]eset hunk' }
map '<leader>gR' { partial(vim.cmd.Gitsigns, 'reset_buffer'), '[R]eset buffer' }
map '<leader>gp' { partial(vim.cmd.Gitsigns, 'preview_hunk'), '[p]review hunk' }
map '<leader>gb' { partial(vim.cmd.Gitsigns, 'blame_line'), '[b]lame line' }

map '<M-h>' { vim.cmd.NavigatorLeft }
map '<M-j>' { vim.cmd.NavigatorDown }
map '<M-k>' { vim.cmd.NavigatorUp }
map '<M-l>' { vim.cmd.NavigatorRight }

---
--- If any LSP server attached to the current buffer can provide the @server_capability,
--- use @lsp_func with @lsp_args as arguments else use the normal mode command @vim_cmd.
---
---@param server_capability string
---@param lsp_func function
---@param lsp_args table?
---@param vim_cmd string
local function if_lsp_else_vim(server_capability, lsp_func, lsp_args, vim_cmd)
	local clients = vim.lsp.get_active_clients { bufn = 0 }
	local capabillity_supported = false
	for _, client in ipairs(clients) do
		if client.server_capabilities[server_capability] and client.name ~= 'null-ls' then
			capabillity_supported = true
			break
		end
	end

	if capabillity_supported then
		if type(lsp_args) == 'table' then
			lsp_args = unpack(lsp_args)
		end
		lsp_func(lsp_args)
	else
		vim.cmd(vim.api.nvim_replace_termcodes(vim_cmd, true, false, true))
	end
end

map 'K' { partial(if_lsp_else_vim, 'hoverProvider', vim.lsp.buf.hover, nil, ':normal! K'), 'Hover documentation' }
-- map '<leader>=' { partial(if_lsp_else_vim, "documentFormattingProvider", vim.lsp.buf.format, { async = true }, ":normal gg=G<C-o>"), "Format buffer", 'n' }
-- map '=' { partial(if_lsp_else_vim, "documentFormattingProvider", vim.lsp.buf.range_formatting, { async = true }, "="), "Format buffer", 'v' }

local builtin = require 'telescope.builtin'
map '[d' { vim.diagnostic.goto_prev, 'previous [d]iagnostic' }
map ']d' { vim.diagnostic.goto_next, 'next [d]iagnostic' }
map '<leader>d' {
	function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
	'Show line diagnostics',
}
map '<leader>q' { builtin.loclist, 'Open lo[q]list' } -- not actually called lo'q'list :^)
map '<leader>Q' { builtin.quickfix, 'Open [Q]uickfix' }

function M.set_lsp_mappings()
	map 'gD' {
		function()
			vim.lsp.buf.declaration()
			vim.cmd.normal 'zz'
		end,
		'Goto [D]eclaration [LSP]',
	}
	map 'gd' {
		function()
			vim.lsp.buf.definition()
			vim.cmd.normal 'zz'
		end,
		'Goto [d]efinition [LSP]',
	}
	map 'gi' { builtin.lsp_implementations, 'Goto [i]mplementation [LSP]' }
	map 'gr' { builtin.lsp_references, 'Goto [r]eferences [LSP]' }
	map '<leader>D' { builtin.lsp_definitions, 'Show type [d]efinition [LSP]' }
	map '<leader>r' { vim.lsp.buf.rename, '[r]ename symbol [LSP]' }
	map '<A-CR>' { vim.lsp.buf.code_action, 'Code Action [LSP]' }
end

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

function M.get_cmp_mappings()
	local cmp = require 'cmp'
	return {
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				if #cmp.get_entries() == 1 then
					cmp.confirm { select = true }
				else
					cmp.select_next_item()
				end
			elseif has_words_before() then
				cmp.complete()
				if #cmp.get_entries() == 1 then
					cmp.confirm { select = true }
				end
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		-- ['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm { select = false },
	}
	-- map '<C-d>' { function() if not require("cmp").scroll_docs(4) then return "<C-d>" end end, "Scroll documentation down", expr = true }
	-- map '<C-u>' { function() if not require("cmp").scroll_docs(-4) then return "<C-u>" end end, "Scroll documentation up", expr = true }
end

map '<C-n>' {
	function()
		luasnip.jump(1)
	end,
	'Next snippet node',
	'is',
}
map '<C-p>' {
	function()
		luasnip.jump(-1)
	end,
	'Prev snippet node',
	'is',
}
map '<C-e>' {
	function()
		if luasnip.choice_active() then
			luasnip.change_choice(1)
		end
	end,
	'Prev snippet node',
	'is',
}

function M.set_welcome_mappings()
	map 'q' { vim.cmd.q, 'Quit', 'nv', buffer = true }
	-- local grp = vim.api.nvim_create_augroup("DASH" , {})
	--
	-- vim.api.nvim_create_autocmd( "BufLeave" , {
	--     group = grp,
	--     buffer = 0,
	--     command = "bdelete",
	-- })
end

-- TODO: in lua or remove entirely
vim.cmd [[
" barbar
" Move to previous/next
nnoremap <silent>    <A-,> :echo "Try \<leader\>b!"<CR>
nnoremap <silent>    <A-.> :echo "Try \<leader\>b!!!"<CR>
" nnoremap <silent>    <A-,> :BufferPrevious<CR>
" nnoremap <silent>    <A-.> :BufferNext<CR>
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
return M
