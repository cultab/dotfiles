local M = {}

vim.g.barbar_auto_setup = false

M.config = function()
    require 'bufferline'.setup {
        -- Enable/disable animations
        animation = false,

        -- Enable/disable auto-hiding the tab bar when there is a single buffer
        auto_hide = false,

        -- Enable/disable current/total tabpages indicator (top right corner)
        tabpages = true,

        -- Enable/disable close button
        closable = true,

        -- Enables/disable clickable tabs
        --  - left-click: go to buffer
        --  - middle-click: delete buffer
        clickable = true,

        -- Excludes buffers from the tabline
        -- exclude_ft = {},
        -- exclude_name = {},

        -- Hide buffers
        hide = { current = false, inactive = false, visible = false },


        icons = {
            filetype = { enabled = true },
            separator = { left = '▎', },
            button = '',
            modified = { button = '●' },
            pinned = { button = '車' },
            inactive = { separator = { left = '▎' } }
        },

        -- Default is to insert after current buffer.
        insert_at_end = true,
        insert_at_start = false,

        -- Sets the maximum padding width with which to surround each tab
        maximum_padding = 1,

        -- Sets the minimum padding width with which to surround each tab
        minimum_padding = 0,

        -- Sets the maximum buffer name length.
        maximum_length = 30,

        -- If set, the letters for each buffer in buffer-pick mode will be
        -- assigned based on their name. Otherwise or in case all letters are
        -- already assigned, the behavior is to assign letters in order of
        -- usability (see order below)
        semantic_letters = true,

        -- New buffer letters are assigned in this order. This order is
        -- optimal for the qwerty keyboard layout but might need adjustement
        -- for other layouts.
        letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

        -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
        -- where X is the buffer number. But only a static string is accepted here.
        no_name_title = "Unnamed buf",
    }
end

return M
