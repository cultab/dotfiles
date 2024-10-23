local M = {}

local partial = require('user.util').partial
-- local luasnip = require 'luasnip'

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

map '<leader>=' { '<Plug>Format', 'format buffer [Conform]', 'nv' }

-- sane movement through wrapping lines
-- NOTE: checks v:count so relative jumps still work :^)
map 'j' { 'v:count == 0 ? "gj" : "j"', nil, 'nv', expr = true }
map 'k' { 'v:count == 0 ? "gk" : "k"', nil, 'nv', expr = true }

map 'H' { 'g^', 'Goto Line Beginning', 'nv' }
map 'L' { 'g$', 'Goto Line End', 'nv' }

map '<leader>c' { nil, 'Run command' }
map '<leader>cc' { vim.cmd.CommandRun, 'shell [c]ommand' }
map '<leader>cl' { vim.cmd.CommandLast, 'repeat [l]ast command' }
map '<leader>cr' { vim.cmd.CommandFile, '[r]un current file' }
map '<leader>ct' { vim.cmd.CommandChangeDirection, '[t]oggle pane direction' }

map '<leader>o' { require('user.configs').config_picker, '[o]pen config picker' }

map '<leader>t' { nil, '[t]ext/[t]elescope', 'nv' }
map '<leader>tt' { ':Tabularize<space>/', '[t]abularize', 'v' }
map '<leader>te' { vim.cmd.EasyAlign, '[e]asy align', 'v' }
map '<leader>te' { partial(vim.cmd.Telescope, 'emoji'), '[e]moji picker' }
map '<leader>tk' { partial(vim.cmd.Telescope, 'keymaps'), '[k]eymaps' }
map '<leader>tn' { vim.cmd.Nerdy, '[n]erdfont Symbols' }
map '<leader>tc' { partial(vim.cmd.Telescope, 'todo-comments'), 'todo [c]omments' }

map '<leader>l' { vim.cmd.Lazy, '[l]azy pkg manager' }

map '<leader><space>' { '<Plug>(cokeline-pick-focus)', 'Pick Buffer' }
map '<leader>x' { '<Plug>(cokeline-pick-close)', 'Pick Buffer to close' }
map '<M-c>' { vim.cmd.bdelete, '[c]lose buffer' }
map '<leader>X' { partial(vim.api.nvim_buf_delete, 0, {}), 'e[X]punge current buffer' }
map '<leader>f' { partial(vim.cmd.Telescope, 'find_files', 'follow=true', 'hidden=true'), '[f]ind files' }
map '<leader>/' { function() require('telescope.builtin').live_grep({ additional_args='--follow' }) end, 'g[/]re/p' }
map '<leader>h' { partial(vim.cmd.Telescope, 'help_tags'), 'search [h]elp tags' }
map '<leader>n' { require('user.newfile').new_file, '[n]ew file' }
map '<leader>u' { vim.cmd.UndotreeToggle, '[u]ndo tree' }
map '<leader>e' { vim.cmd.Oil, '[e]xplore files' }

map '<leader>g' { nil, '[g]it' }
map '<leader>ga' { partial(vim.cmd.Gitsigns, 'stage_hunk'), '[a]dd hunk' }
map '<leader>gA' { partial(vim.cmd.Gitsigns, 'stage_buffer'), '[A]dd buffer' }
map '<leader>gr' { partial(vim.cmd.Gitsigns, 'reset_hunk'), '[r]eset hunk' }
map '<leader>gR' { partial(vim.cmd.Gitsigns, 'reset_buffer'), '[R]eset buffer' }
map '<leader>gv' { partial(vim.cmd.Gitsigns, 'preview_hunk'), '[v]iew hunk' }
map '<leader>gb' { partial(vim.cmd.Gitsigns, 'blame_line'), '[b]lame line' }
map '<leader>gc' { function() require('tinygit').smartCommit() end, '[c]ommit changes' }
map '<leader>gp' { function() require('tinygit').push() end, '[p]ush commits' }

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
local function if_capability_else_fallback(server_capability, lsp_func, lsp_args, vim_cmd)
	local clients = vim.lsp.get_clients { bufn = 0 }
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

map 'K' {
	partial(if_capability_else_fallback, 'hoverProvider', vim.lsp.buf.hover, nil, ':normal! K'),
	'Hover documentation',
}
-- map '<leader>=' { partial(if_lsp_else_vim, "documentFormattingProvider", vim.lsp.buf.format, { async = true }, ":normal gg=G<C-o>"), "Format buffer", 'n' }
-- map '=' { partial(if_lsp_else_vim, "documentFormattingProvider", vim.lsp.buf.range_formatting, { async = true }, "="), "Format buffer", 'v' }

map '[d' { vim.diagnostic.goto_prev, 'previous [d]iagnostic' }
map ']d' { vim.diagnostic.goto_next, 'next [d]iagnostic' }
map '<leader>d' { partial(vim.diagnostic.open_float, nil, { focusable = false }), 'Show line diagnostics' }
map '<leader>q' { partial(vim.cmd.Telescope, 'loclist'), 'open lo[q]list' } -- not actually called lo'q'list :^)
map '<leader>Q' { partial(vim.cmd.Telescope, 'quickfix'), 'open [Q]uickfix' }

function M.set_lsp_mappings()
	map 'gD' {
		function()
			vim.lsp.buf.declaration()
			vim.cmd.normal 'zz'
		end,
		'[g]oto [D]eclaration [LSP]',
	}
	map 'gd' {
		function()
			vim.lsp.buf.definition()
			vim.cmd.normal 'zz'
		end,
		'[g]oto [d]efinition [LSP]',
	}
	map 'gi' { partial(vim.cmd.Telescope, 'lsp_implementations'), '[g]oto [i]mplementation [LSP]' }
	map 'gr' { partial(vim.cmd.Telescope, 'lsp_references'), '[g]oto [r]eferences [LSP]' }
	map '<leader>D' { partial(vim.cmd.Telescope, 'lsp_definitions'), 'Show type [d]efinition [LSP]' }
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

-- map '<C-n>' {
-- 		partial(luasnip.jump, 1)
-- 	'Next snippet node',
-- 	'is',
-- }
-- map '<C-p>' {
-- 		partial(luasnip.jump, -1)
-- 	'Prev snippet node',
-- 	'is',
-- }
-- map '<C-e>' {
-- 	function()
-- 		if luasnip.choice_active() then
-- 			luasnip.change_choice(1)
-- 		end
-- 	end,
-- 	'Prev snippet node',
-- 	'is',
-- }

function M.set_welcome_mappings()
	map 'q' { vim.cmd.q, '[q]uit', 'nv', buffer = true }
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
" nnoremap <silent>    <A-,> :echo "Try \<leader\>b!"<CR>
" nnoremap <silent>    <A-.> :echo "Try \<leader\>b!!!"<CR>
" nnoremap <silent>    <A-,> :BufferPrevious<CR>
" nnoremap <silent>    <A-.> :BufferNext<CR>
" Re-order to previous/next
" nnoremap <silent>    <A-[> :BufferMovePrevious<CR>
" nnoremap <silent>    <A-]> :BufferMoveNext<CR>
" Close buffer
" nnoremap <silent>    <A-c> :BufferClose<CR>

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
