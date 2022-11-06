--                                         _                      --
--                   _                    | |                     --
--                  |_|                   | |                     --
--  ______  __   __  _   ___________      | |  _    _   ______    --
-- |  __  | \ \ / / | | |  __   __  |     | | | |  | | |  __  |   --
-- | |  | |  \ v /  | | | |  | |  | |     | | | |  | | | |  | |   --
-- | |  | |   \ /   | | | |  | |  | |  _  | | | |__| | | |__| |_  --
-- |_|  |_|    v    |_| |_|  |_|  |_| |_| |_| |______| |________| --

require 'impatient'
require 'user.plugins'
require 'user.options'
require 'user.visual'
require "user.statusline"
require 'user.mappings'

require 'user.treesitter'
require 'user.welcome'
require 'user.telescope'
require 'user.mason'
require 'user.lsp'
require 'user.null-lsp'

vim.g.committia_open_only_vim_starting = 0

local disabled_built_ins = {
    -- "netrw",
    -- "netrwPlugin",
    -- "netrwSettings",
    -- "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    -- "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end
