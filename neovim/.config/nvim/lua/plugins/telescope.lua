local function get_fd()
    if vim.env.WSL_DISTRO_NAME == "Debian" then
        return "fdfind"
    end

    return "fd"
end

return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } },
        config = function()
            local actions = require('telescope.actions')


            require("telescope").setup {
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
                        find_command = { get_fd() }
                    }
                }
            }
            require("telescope").load_extension("emoji")
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        config = function()
            require('telescope').load_extension('fzf')
        end
    },
    { 'xiyaowong/telescope-emoji.nvim' },

}
