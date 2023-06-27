local call = require "user.util".call

local markdown_like = {
    query = vim.treesitter.query.parse(
        "markdown",
        [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
            ]]
    ),
    treesitter_language = "markdown",
    headline_highlights = call(function()
        local t = {}
        for i = 1, 6 do
            t[i] = "Headline" .. i
        end
        return t
    end),
    codeblock_highlight = "CodeBlock",
    dash_highlight = "Dash",
    dash_string = "-",
    quote_highlight = "Quote",
    quote_string = "┃",
    fat_headlines = false,
    fat_headline_upper_string = " ", -- "▄",
    fat_headline_lower_string = " ", -- "▀",
}


require "headlines".setup {
    quarto = markdown_like,
    rmd = markdown_like,
    markdown = markdown_like,
}

vim.cmd [[highlight link @headline1 @variable.builtin ]]
vim.cmd [[highlight link @headline2 MatchParen ]]
vim.cmd [[highlight link @headline3 @string ]]
vim.cmd [[highlight link @headline4 @operator ]]
vim.cmd [[highlight link @headline5 @function ]]
vim.cmd [[highlight link @headline6 @constructor ]]
