local M = {}

local wk = require "which-key"

-- Map a key to a lua function or vimscript snippet also add a description.
--
-- map keycode:string { lua function | vimscript:string , description:string }
--
-- # How to import:
--
-- ```lua
-- local map = require'/path/to/map'.map
-- ```
--
-- Example:
-- ```lua
-- map 'gD' { vim.lsp.buf.declaration, "Goto declaration [LSP]" }
-- ```
--
-- ## An optional third argument determines the mode the key is bound in.
--
-- Example:
--
-- mapping `<leader>=` to `vim.lsp.buf.range_format()` in visual mode:
--
-- ```lua
-- map '<leader>=' { vim.lsp.buf.range_formatting, "Format range", 'v' }
-- ```
--
-- ## Silent and expr can also be given as named arguments
--
-- Example:
-- ```lua
-- map '<C-d>' { function() return '<C-d>' end, "Do nothing", expr = true }
-- ```
M.map = setmetatable({}, {
    __call = function(_, key)
        -- @param mapping_args list
        local closure = function(mapping_args)
            -- default to normal mode
            local temp = mapping_args[3] or "n"
            local modes = {}
            for mode in string.gmatch(temp, ".") do
                table.insert(modes, mode)
            end

            -- @type string | function | nil
            local mapping = mapping_args[1]
            -- @type string
            local description = mapping_args[2] or ""
            -- @type boolean
            local expr = mapping_args["expr"] or false
            -- @type boolean
            local silent = mapping_args["silent"] or true
            -- @type boolean
            local noremap = mapping_args["noremap"] or true

            if mapping ~= nil then -- real keymap
                vim.keymap.set(modes, key, mapping, {
                    silent = silent,
                    expr = expr,
                    desc = description,
                    noremap = noremap,
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
        return closure
    end,
})

return M
