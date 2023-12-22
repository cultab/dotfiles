local function get_fd()
    local suc, errcode, ret = os.execute("fd")

    vim.notify("plugin/telescope: could not find fd (get it?)")
    return "asdfg"
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
                    mappings = { i = { ["<esc>"] = actions.close } },
                },
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
