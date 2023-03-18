vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
-- vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 15
vim.cmd [[
    let g:netrw_list_hide=netrw_gitignore#Hide()
]]

-- TODO: keybinds, see: https://vonheikemen.github.io/devlog/tools/using-netrw-vim-builtin-file-explorer/ "Keymaps"

require'netrw'.setup()
