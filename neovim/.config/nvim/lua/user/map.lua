local M = {}

function P(a)
    print(vim.inspect(a))
end

local wk = require "which-key"

-- TODO: other modes? "s", "o", "x", "l", "c", "t"
local function prototype() return {
    mappings = {
        n = {},
        v = {},
        i = {},
    }
} end

-- Map a key to a lua function or vimscript snippet also add a description.
--
-- map keycode:string { lua function | vimscript:string , description:string }
--
-- Example:
-- ```lua
-- map 'gD' { vim.lsp.buf.declaration, "Goto declaration [LSP]" }
-- ```
--
-- An optional third argument determines the mode the key is bound in.
--
-- Example:
-- mapping `<leader>=` to `vim.lsp.buf.range_format` in visual mode:
-- ```lua
-- map '<leader>=' { vim.lsp.buf.range_formatting, "Format range", 'v' }
-- ```
_G.map = setmetatable(prototype(), {
    -- enable syntax like:  map "<leader>a"  { vim.lsp.buf.rename , "some desc" }
    -- if mode is missing, assume normal mode
    -- if mapping is missing, name the group
    __call = function(self, key)
        -- @param mapping_args list
        local closure = function (mapping_args)
            -- default to normal mode
            local modes = "n"
            -- if another set of modes is given, overwrite "n"
            if mapping_args[3] then
                modes = mapping_args[3]
            end

            -- set the mapping for each mode
            for i = 1, #modes do
                self.mappings[modes:sub(i, i)][key] = mapping_args
            end
        end
        return closure
    end,
    __index = {
        register = function (self)
            local registry = {}
            for mode, mappings in pairs(self.mappings) do
                for key, mapping_args in pairs(mappings) do
                    -- @type string|function|nil
                    local mapping = mapping_args[1]
                    -- @type string|nil
                    local description = mapping_args[2]

                    if description == nil then
                        description = ""
                    end

                    if mapping ~= nil then -- real keymap
                        table.insert(registry, {
                            { [key] = { mapping, description } },
                            { mode = mode }
                        })
                    else                  -- keymap group name
                        table.insert(registry, {
                            { [key] = { name = description } },
                            { mode = mode }
                        })
                    end
                end
            end
            -- empty out registered mappings
            wk.register(registry)
            self.mappings = prototype().mappings
        end
    }
})

return M
