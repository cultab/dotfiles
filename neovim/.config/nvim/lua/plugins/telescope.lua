
return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
        config = function()
            local actions = require('telescope.actions')


            require("telescope").setup{
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
                        find_command = { "fd" }
                    }
                }
            }
            require('telescope').load_extension('fzf')
            require("telescope").load_extension("emoji")
        end
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'xiyaowong/telescope-emoji.nvim' },

}

