local M = {}

---Call {func}
---@param func function
---@return any?
function M.call(func)
	return func()
end

---Return the partial application of {func} with {args}
---@param func fun(...: any): any?
---@param ... any
---@return fun(...: any?): any?
function M.partial(func, ...)
	local initial_args = { ... }
	return function(...)
		local more_args = { ... }
		-- copy instead of reference
		local args = {unpack(initial_args)}
		-- append more_args to args list
		for _, value in ipairs(more_args) do
			table.insert(args, value)
		end
		func(unpack(args))
	end
end

---Apply arguments to a function
---@param func function(...: any): any
---@param ... any
---@return any?
function M.apply(func, ...)
	local args = { ... }
	return func(unpack(args))
end

local function zipgen(args)
	-- find minimum
	local min = #args[1]
	for i = 2, #args, 1 do
		min = #args[i] < min and #args[i] or min
	end

	-- create list with 'i'th element from all iterators
	for i = 1, min do
		local ans = {}
		for j = 1, #args do
			-- get 'j'th iterator's 'i'th element
			ans[j] = args[j][i]
		end

		-- return list of 'i'th elements
		coroutine.yield(unpack(ans))
	end
end

-- python like zip iterator
function M.zip(...)
	local args = { ... }
	return coroutine.wrap(function()
		zipgen(args)
	end)
end

function M.to_vim_list(tbl)
	local ret = ''
	for key, value in pairs(tbl) do
		ret = ret .. key .. ':' .. value .. ','
	end

	return string.sub(ret, 1, #ret - 1)
end

return M
