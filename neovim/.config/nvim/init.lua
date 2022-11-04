--                                         _                      --
--                   _                    | |                     --
--                  |_|                   | |                     --
--  ______  __   __  _   ___________      | |  _    _   ______    --
-- |  __  | \ \ / / | | |  __   __  |     | | | |  | | |  __  |   --
-- | |  | |  \ v /  | | | |  | |  | |     | | | |  | | | |  | |   --
-- | |  | |   \ /   | | | |  | |  | |  _  | | | |__| | | |__| |_  --
-- |_|  |_|    v    |_| |_|  |_|  |_| |_| |_| |______| |________| --

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
