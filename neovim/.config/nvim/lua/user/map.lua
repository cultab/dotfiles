local M = {}

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
_G.map = setmetatable({ mappings = {} }, {
    -- enable syntax like:  map "<leader>a"  { vim.lsp.buf.rename , "some desc" }
    -- if mode is missing, assume normal mode
    -- if mapping is missing, name the group
    __call = function(self, key)
        -- @param mapping_args list
        local closure = function (mapping_args)
            self.mappings[key] = mapping_args
        end
        return closure
    end,
    __index = {
        register = function (self)
            for key, mapping_args in pairs(self.mappings) do
                -- @type string|function|nil
                local mapping = mapping_args[1]
                -- @type string|nil
                local description = mapping_args[2]
                -- @type string|nil
                local mode = mapping_args[3]

                if mode == nil then
                    mode = "n"
                end

                -- print("key: " .. key .. " to " .. vim.inspect(mapping) .. " in " .. mode)
                if mapping ~= nil then
                    for i = 1, #mode do
                        wk.register(
                            { [key] = { mapping, description } },
                            { mode = mode:sub(i, i) }
                        )
                    end
                else
                    for i = 1, #mode do
                        wk.register(
                            { [key] = { name = description } } ,
                            { mode = mode:sub(i, i) }
                        )
                    end
                end
            end
            -- print(vim.inspect(self.mappings))
        end
    }
})


                        -- if type(mapping) == "function" then
                        --     vim.api.nvim_set_keymap(mode:sub(i, i), key, '', { callback = mapping, desc = description })
                        -- else
                        --     vim.api.nvim_set_keymap(mode:sub(i, i), key, mapping, { desc = description })
                        -- end

return M
