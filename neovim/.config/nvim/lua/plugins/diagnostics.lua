return {
    "dgagn/diagflow.nvim",
    event = "LspAttach",
    opts = {
        enable = function()
            return vim.bo.filetype ~= "lazy"
        end,
        enable = true,
        -- max_width = 60,         -- The maximum width of the diagnostic messages
        -- max_height = 10,        -- the maximum height per diagnostics
        -- format = function(diagnostic)
        --     return diagnostic.message
        -- end,
        -- gap_size = 1,
        scope = 'cursor',        -- 'cursor', 'line' this changes the scope, so instead of showing errors under the cursor, it shows errors on the entire line.
        -- text_align = 'right',                                      -- 'left', 'right'
        placement = 'top',       -- 'top', 'inline'
        inline_padding_left = 0, -- the padding left when the placement is inline
        show_sign = true,        -- set to true if you want to render the diagnostic sign before the diagnostic message
        -- border_chars = {
        --     top_left = "┌",
        --     top_right = "┐",
        --     bottom_left = "└",
        --     bottom_right = "┘",
        --     horizontal = "─",
        --     vertical = "│"
        -- },
        -- show_borders = false,
    }
}
