local M = {}

function M.foldfunc()
    -- get vim variables needed
    local start = vim.v.foldstart
    -- local fend = vim.v.foldend
    -- @type string
    local line = vim.fn.getline(start)
    local comment_string = vim.api.nvim_buf_get_option(0, 'commentstring')

    -- extract before and after comment characters (if they exist)
    local s_loc = string.find(comment_string, '%%s')
    -- from start to %s - 1
    local before = string.sub(comment_string, 1, s_loc - 1)
    -- from %s + len(%s) = 2 to end
    local after = string.sub(comment_string, s_loc + 2, #comment_string)

    -- create strings of spaces of the correct length to replace the comment strings
    -- only do it for the comment string that's before the comment,
    -- so the comment starts at the same column when folding
    local before_space = ''
    for _=1 , #before do
        before_space = before_space .. ' '
    end

    -- for the other half incase I change my mind
    local after_space = ''
    -- for _=1, #after  do
    --     after_space = after_space .. ' '
    -- end

    --  TODO: escape more than '*' and '-', should escape all magic chars instead
    before = string.gsub(before, '%*', '%%*')
    after = string.gsub(after, '%*', '%%*')
    before = string.gsub(before, '%-', '%%-')
    after = string.gsub(after, '%-', '%%-')

    -- remove fold markers
    line = string.gsub(line, '}' .. '}}', '' ) -- HACK: split fold markers to trick vim to not see them, when editing this file
    line = string.gsub(line, '{' .. '{{', '' )

    -- remove comment string
    line = string.gsub(line, before, before_space)
    line = string.gsub(line, after, after_space)

    -- return line .. " ﬌ " .. fend - start .. " lines"
    return line
end

_G.MyFoldText = M.foldfunc
M.lua_global_func = 'v:lua.MyFoldText()'

return M

