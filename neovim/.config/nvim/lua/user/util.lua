local M = {}

M.call = function(func)
    return func()
end

M.partial = function(func, ...)
    local args = {...}
    return function()
        func(unpack(args))
    end
end

local zipgen = function(args)
    -- find minimum
    local min = #args[1]
    for i = 2, #args, 1 do
        min = #args[i] < min and #args[i] or min
    end

    -- create list with 'i'th element from all iterators
    for i=1, min do
        local ans = {}
        for j=1, #args do
            -- get 'j'th iterator's 'i'th element
            ans[j] = args[j][i]
        end

        -- return list of 'i'th elements
        coroutine.yield(unpack(ans))
    end
end

-- python like zip iterator
M.zip = function(...)
    local args = {...}
    return coroutine.wrap(function() zipgen(args) end)
end

M.to_vim_list = function(tbl)
    local ret = ""
    for key, value in pairs(tbl) do
        ret = ret .. key .. ":" .. value .. ","
    end

    return string.sub(ret, 1, #ret - 1)
end

return M
