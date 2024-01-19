local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

M.config_picker = function(opts)
  opts = opts or {}

   pickers.new(opts, {
        prompt_title = "Open Configuration for:",
        finder = finders.new_table {
            results = {
                { "Dunst",                   "~/.config/dunst/no_theme.dunstrc"                       },
                { "Polybar",                 "~/.config/polybar/config.ini",                cd = true },
                { "Simple X keybind daemon", "~/.config/sxhkd/sxhkdrc"                                },
                { "Zoomer Shell",            "~/.config/zsh/.zshrc"                                   },
                { "bspwm",                   "~/.config/bspwm/bspwmrc"                                },
                { "gitconfig",               "~/.config/git/config"                                   },
                { "neovim plugins",          "~/.local/share/nvim/lazy",                    cd = true },
                { "neovim",                  "~/.config/nvim/init.lua",                     cd = true },
                { "starship prompt",         "~/.config/starship.toml"                                },
                { "tmux",                    "~/.config/tmux/tmux.conf",                              },
                { "themr",                   "~/.config/themr/themes.yaml",                 cd = true },
                { "wezterm",                 "~/.config/wezterm/wezterm.lua",                         },
                { "xresources",              "~/.config/xrdb/Xresources.xdefaults"        , cd = true },
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
                    vim.cmd.cd(vim.fs.dirname(selection.path))
                end
                vim.cmd.edit(selection.path)
            end)
            return true
        end,
    }):find()
end

return M
