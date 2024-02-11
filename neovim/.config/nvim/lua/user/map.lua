local M = {}

local wk = require "which-key"




--- @alias mode
--- | '"n"'  # normal mode
--- | '"v"'  # visual mode
--- | '"i"'  # insert mode
--- | string # combination of modes

--- @alias action function | string

--- @class mapping
--- @field [1] action # action
--- @field [2] string # mapping description
--- @field [3] mode   # mode
--- @field expr boolean?
--- @field noremap boolean?
--- @field silent boolean?
--- @field buffer boolean?


--- Map a key to a lua function or vimscript snippet also add a description.
---
--- map keycode:string { lua function | vimscript:string , description:string }
---
--- Example:
--- ```lua
--- map 'gD' { vim.lsp.buf.declaration, "Goto declaration [LSP]" }
--- ```
---
--- ## An optional third argument determines the mode the key is bound in.
---
--- Example:
---
--- mapping `<leader>=` to `vim.lsp.buf.range_format()` in visual mode:
---
--- ```lua
--- map '<leader>=' { vim.lsp.buf.range_formatting, "Format range", 'v' }
--- ```
---
--- ## Silent and expr can also be given as named arguments
---
--- Example:
--- ```lua
--- map '<C-d>' { function() return '<C-d>' end, "Do nothing", expr = true }
--- ```
---
--- @class Map
--- @operator call:fun(key: string): fun(mapping_args: mapping)
--- @overload fun(key: string): fun(mapping_args: mapping)
M.map = setmetatable({}, {
	__call = function(_, key)
		--- @param mapping_args mapping
		return function(mapping_args)
			-- default to normal mode
			local temp = mapping_args[3] or "n"
			--- @type mode[]
			local modes = {}
			for mode in string.gmatch(temp, ".") do
				table.insert(modes, mode)
			end

			--- @type action?
			local action = mapping_args[1]
			--- @type string
			local description = mapping_args[2] or ""
			--- @type boolean
			local expr = mapping_args["expr"] or false
			--- @type boolean
			local silent = mapping_args["silent"] or true
			--- @type boolean
			local noremap = mapping_args["noremap"] or true
			--- @type boolean
			local buffer = mapping_args["buffer"] or false

			if action ~= nil then -- real keymap
				vim.keymap.set(modes, key, action, {
					desc = description,
					silent = silent,
					expr = expr,
					noremap = noremap,
					buffer = buffer,
				})
			else -- which-key group name
				-- set the mapping for each mode
				for mode in pairs(modes) do
					wk.register {
						{ [key] = { name = description } },
						{ mode = mode }
					}
				end
			end
		end
	end,
})

return M
