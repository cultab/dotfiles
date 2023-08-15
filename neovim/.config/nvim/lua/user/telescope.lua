local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        -- file_sorter = require'telescope.sorters'.get_fzy_sorter,
        -- generic_sorter = require'telescope.sorters'.get_fzy_sorter,
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
    },
    pickers = {
        find_files = {
            find_command = { "fdfind" }
        }
    }
}

require('telescope').load_extension('fzf')
require("telescope").load_extension("emoji")
