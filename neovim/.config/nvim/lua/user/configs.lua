local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- our picker function: colors
M.config_picker = function(opts)
  opts = opts or {}

    pickers.new(opts, {
        prompt_title = "Open Configuration for:",
        finder = finders.new_table {
            results = {
                { "bspwm",                   "~/.config/bspwm/bspwmrc"                                },
                { "Dunst",                   "~/.config/dunst/no_theme.dunstrc"                       },
                { "Polybar",                 "~/.config/polybar/config.ini"                           },
                { "neovim",                  "~/.config/nvim/init.lua",                     cd = true },
                { "neovim plugins",          "~/.local/share/nvim/site/pack/packer/start/", cd = true },
                { "Simple X keybind daemon", "~/.config/sxhkd/sxhkdrc"                                },
                { "xresources",              "~/.config/xrdb/Xresources.xdefaults"        , cd = true },
                { "Zoomer Shell",            "~/.config/zsh/.zshrc"                                   },
                { "themr",                   "~/.config/themr/themes.yaml",                 cd = true },
                { "gitconfig",               "~/.config/git/config"                                   }
            },
            entry_maker = function(entry)
                return {
                    value = entry[1],
                    display = entry[1],
                    ordinal = entry[1],
                    path = vim.fn.expand(entry[2]),
                    cd = entry.cd or false
                }
            end
        },
        sorter = conf.generic_sorter(opts),
        previewer = conf.file_previewer(opts),
        attach_mappings = function(prompt_bufnr) -- , map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection.cd then
                    -- vim.cmd('cd ' .. vim.fs.dirname(selection.path))
                    vim.cmd.cd(vim.fs.dirname(selection.path))
                end
                vim.cmd.edit(selection.path)
            end)
            return true
        end,
    }):find()
end

return M
