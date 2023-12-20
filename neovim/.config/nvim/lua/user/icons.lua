return {
    diagnostic = {
        error = ' ',
        warn  = ' ',
        info  = ' ',
        hint  = ' '
    },
    fold = { -- WARN: single char wide
        close = "",
        open = "",
        sep = " ",
    },
    line = {
        center_dotted = '┊',
        center_line   = '│',
        left_thin     = '▏',
        left_medium   = '▎',
        left_thick    = '▊',
    },
    misc = {
        check       = "✓",
        close       = " ",
        grep        = " ",
        right_arrow = "➜",
        search      = " ",
        settings    = " ",
        settings2   = " ",
        term        = " ",
        x           = "✗",
    },
    listchars = {
        nbsp  = "␣",
        trail = "·",
        tab   = "   ",
        eol   = "↲ ",
    },
    file = {
        normal   = " ",
        modilied = '●',
        pinned   = '車',
    },
    git = {
        branch = " ",
    },
    diff = {
        outline = {
            added    = " ",
            modified = " ",
            removed  = " ",
        },
        bold = {
            added    = ' ',
            modified = '柳 ',
            removed  = ' ',
        },
    },
    progress = { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁", "  " },
    border = {
        square = {
            top_left     = "┌",
            top_right    = "┐",
            bottom_left  = "└",
            bottom_right = "┘",
            horizontal   = "─",
            vertical     = "│"
        },
        round = {
            top_left     = "╭",
            top_right    = "╮",
            bottom_left  = "╰",
            bottom_right = "╯",
            horizontal   = "─",
            vertical     = "│",
        }
    },
    lazy = {
        cmd = " ",
        config = "",
        event = "",
        ft = " ",
        init = " ",
        import = " ",
        keys = " ",
        lazy = "󰒲 ",
        loaded = "●",
        not_loaded = "○",
        plugin = " ",
        runtime = " ",
        require = "󰢱 ",
        source = " ",
        start = "",
        task = "✔ ",
        list = { "●", "➜", "★", "‒" },
    },
}
