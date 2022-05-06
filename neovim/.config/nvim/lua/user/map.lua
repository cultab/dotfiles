local M = {}

local function P(a)
    print(vim.inspect(a))
end

local wk = require "which-key"

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
-- Example, let's map <leader>= to vim.lsp.buf.range_formatting in visual mode:
-- ```lua
-- map '<leader>=' { vim.lsp.buf.range_formatting, "Format range", 'v' }
-- ```
-- TODO: other modes? "s", "o", "x", "l", "c", "t"
local function prototype() return {
    mappings = {
        n = {},
        v = {},
        i = {},
    }
} end

_G.map = setmetatable(prototype(), {
    -- enable syntax like:  map "<leader>a"  { vim.lsp.buf.rename , "some desc" }
    -- if mode is missing, assume normal mode
    -- if mapping is missing, name the group
    __call = function(self, key)
        -- @param mapping_args list
        local closure = function (mapping_args)
            local mode = ""
            -- default to normal mode
            if mapping_args[3] then
                mode = mapping_args[3]
            else
                mode = "n"
            end
            self.mappings[mode][key] = mapping_args
        end
        return closure
    end,
    __index = {
        register = function (self)
            -- P(self)
            for mode, mappings in pairs(self.mappings) do
                for key, mapping_args in pairs(mappings) do
                    -- @type string|function|nil
                    local mapping = mapping_args[1]
                    -- @type string
                    local description = mapping_args[2]

                    if mapping ~= nil then
                        wk.register(
                            { [key] = { mapping, description } },
                            { mode = mode }
                        )
                    else
                        wk.register(
                            { [key] = { name = description } } ,
                            { mode = mode }
                        )
                    end
                end
            end
            -- empty out registered mappings
            self.mappings = prototype().mappings
        end
    }
})


                        -- if type(mapping) == "function" then
                        --     vim.api.nvim_set_keymap(mode:sub(i, i), key, '', { callback = mapping, desc = description })
                        -- else
                        --     vim.api.nvim_set_keymap(mode:sub(i, i), key, mapping, { desc = description })
                        -- end

return M
